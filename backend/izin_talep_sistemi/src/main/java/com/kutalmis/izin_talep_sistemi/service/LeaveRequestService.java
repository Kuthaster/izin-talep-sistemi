package com.kutalmis.izin_talep_sistemi.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestApprovalDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestCountDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestDecisionDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestFilterDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeCountDTO;
import com.kutalmis.izin_talep_sistemi.entity.LeaveDecision;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequest;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequestApproval;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequestSpecifications;
import com.kutalmis.izin_talep_sistemi.entity.LeaveType;
import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.repository.LeaveRequestApprovalRepository;
import com.kutalmis.izin_talep_sistemi.repository.LeaveRequestRepository;
import com.kutalmis.izin_talep_sistemi.repository.LeaveTypeRepository;
import com.kutalmis.izin_talep_sistemi.repository.UserRepository;
import com.kutalmis.izin_talep_sistemi.utilities.ApprovalLevels;

import static com.kutalmis.izin_talep_sistemi.utilities.ApprovalLevels.roleForLevel;

@Service
public class LeaveRequestService {
    private final LeaveBalanceService leaveBalanceService;
    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveTypeRepository leaveTypeRepository;
    private final UserRepository userRepository;
    private final LeaveRequestApprovalRepository leaveRequestApprovalRepository;
    private static final int MAX_LEVEL = 3;

    public LeaveRequestService(LeaveRequestRepository leaveRequestRepository,
            LeaveTypeRepository leaveTypeRepository,
            UserRepository userRepository,
            LeaveRequestApprovalRepository leaveRequestApprovalRepository, LeaveBalanceService leaveBalanceService) {
        this.leaveRequestRepository = leaveRequestRepository;
        this.leaveTypeRepository = leaveTypeRepository;
        this.userRepository = userRepository;
        this.leaveRequestApprovalRepository = leaveRequestApprovalRepository;
        this.leaveBalanceService = leaveBalanceService;
    }

    public List<LeaveRequestDTO> getMyLeaveRequests(User caller, String status, String reason, Long leaveTypeId,
            LocalDate startDateFrom, LocalDate startDateTo) {
        Specification<LeaveRequest> spec = Specification
                .where(LeaveRequestSpecifications.belongsToUser(caller.getId()))
                .and(LeaveRequestSpecifications.hasStatus(status))
                .and(LeaveRequestSpecifications.hasReason(reason))
                .and(LeaveRequestSpecifications.hasLeaveType(leaveTypeId))
                .and(LeaveRequestSpecifications.startDateFrom(startDateFrom))
                .and(LeaveRequestSpecifications.startDateTo(startDateTo));

        return leaveRequestRepository.findAll(spec).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    private List<Long> approverDepartmentIds(User caller) {
        if (caller.getDepartment() == null) {
            return List.of();
        }
        return List.of(caller.getDepartment().getId());
    }

    public List<LeaveTypeCountDTO> getLeaveRequestCountByLeaveType(User caller) {
        List<LeaveType> leaveTypes = leaveTypeRepository.findAll();
        List<Long> departmentIds = (caller.getRole().getName() == RoleAuthority.ADMIN)
                ? null
                : approverDepartmentIds(caller);

        if (departmentIds != null && departmentIds.isEmpty()) {
            return List.of();
        }

        return leaveTypes.stream().map(lt -> {
            Long pending = countFor(lt.getId(), "PENDING", departmentIds);
            Long approved = countFor(lt.getId(), "APPROVED", departmentIds);
            Long rejected = countFor(lt.getId(), "REJECTED", departmentIds);
            Long cancelled = countFor(lt.getId(), "CANCELLED", departmentIds);
            Long expired = countFor(lt.getId(), "EXPIRED", departmentIds);
            Long total = pending + approved + rejected + cancelled + expired;
            return new LeaveTypeCountDTO(lt.getId(), lt.getName(), pending, approved, rejected, cancelled, expired,
                    total);
        }).collect(Collectors.toList());
    }

    private Long countFor(Long leaveTypeId, String status, List<Long> departmentIds) {
        return (departmentIds == null)
                ? leaveRequestRepository.countByStatusAndLeaveType_Id(status, leaveTypeId)
                : leaveRequestRepository.countByStatusAndLeaveType_IdAndUser_Department_IdIn(status, leaveTypeId,
                        departmentIds);
    }

    public LeaveRequestCountDTO getLeaveRequestCount(User caller) {

        if (caller.getRole().getName() == RoleAuthority.ADMIN) {
            Long pending = leaveRequestRepository.countByStatus("PENDING");
            Long approved = leaveRequestRepository.countByStatus("APPROVED");
            Long rejected = leaveRequestRepository.countByStatus("REJECTED");
            Long cancelled = leaveRequestRepository.countByStatus("CANCELLED");
            Long expired = leaveRequestRepository.countByStatus("EXPIRED");
            Long total = cancelled + rejected + pending + approved + expired;
            return new LeaveRequestCountDTO(pending, approved, rejected, cancelled, expired, total);
        }

        List<Long> departmentIds = approverDepartmentIds(caller);

        if (departmentIds.isEmpty()) {
            return new LeaveRequestCountDTO(0L, 0L, 0L, 0L, 0L, 0L);
        }

        Long pending = leaveRequestRepository.countByStatusAndUser_Department_IdIn("PENDING", departmentIds);
        Long approved = leaveRequestRepository.countByStatusAndUser_Department_IdIn("APPROVED", departmentIds);
        Long rejected = leaveRequestRepository.countByStatusAndUser_Department_IdIn("REJECTED", departmentIds);
        Long cancelled = leaveRequestRepository.countByStatusAndUser_Department_IdIn("CANCELLED", departmentIds);
        Long expired = leaveRequestRepository.countByStatusAndUser_Department_IdIn("EXPIRED", departmentIds);

        Long total = cancelled + rejected + pending + approved + expired;

        return new LeaveRequestCountDTO(pending, approved, rejected, cancelled, expired, total);
    }

    public List<LeaveRequestDTO> getRequestsForApproval(User caller, LeaveRequestFilterDTO filter) {
        Specification<LeaveRequest> filters = Specification
                .where(LeaveRequestSpecifications.hasStatus(filter.status()))
                .and(LeaveRequestSpecifications.hasReason(filter.reason()))
                .and(LeaveRequestSpecifications.hasLeaveType(filter.leaveTypeId()))
                .and(LeaveRequestSpecifications.startDateFrom(filter.startDateFrom()))
                .and(LeaveRequestSpecifications.startDateTo(filter.startDateTo()))
                .and(LeaveRequestSpecifications.approvedByApprover(filter.approverId()))
                .and(LeaveRequestSpecifications.hasCurrentLevel(filter.currentLevel()));

        if (caller.getRole().getName() == RoleAuthority.ADMIN) {
            return leaveRequestRepository.findAll(filters).stream()
                    .map(this::toDTO)
                    .collect(Collectors.toList());
        }

        List<Long> departmentIds = approverDepartmentIds(caller);

        if (departmentIds.isEmpty()) {
            return List.of();
        }

        Specification<LeaveRequest> spec = filters.and(LeaveRequestSpecifications.inDepartments(departmentIds));

        return leaveRequestRepository.findAll(spec).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public List<LeaveRequestDTO> createLeaveRequest(LeaveRequestCreateDTO dto, User caller) {

        userDepartmentNullCheck(caller);

        LeaveType leaveType = leaveTypeCheck(dto.leaveTypeId());

        dateChecks(dto.startDate(), dto.endDate());

        leaveTypeActiveCheck(leaveType);

        genderCheck(caller, leaveType);

        overlapCheck(caller, dto.startDate(), dto.endDate());

        List<LeaveRequestDTO> createdRequests = new ArrayList<>();
        LocalDate currentStart = dto.startDate();
        while (!currentStart.isAfter(dto.endDate())) {

            LocalDate currentEnd = (currentStart.getYear() == dto.endDate().getYear())
                    ? dto.endDate()
                    : LocalDate.of(currentStart.getYear(), 12, 31);

            LeaveRequest request = reserveRequest(
                    new LeaveRequestCreateDTO(dto.leaveTypeId(), currentStart, currentEnd, dto.reason()),
                    caller,
                    leaveType);
            createdRequests.add(toDTO(request));

            currentStart = currentEnd.plusDays(1);
        }
        return createdRequests;
    }

    private LeaveRequest reserveRequest(LeaveRequestCreateDTO dto, User caller, LeaveType leaveType) {
        int requestedDays = leaveBalanceService.countBusinessDays(dto.startDate(), dto.endDate());

        if (requestedDays <= 0) {
            throw new IllegalArgumentException("Seçilen tarihler arasında geçerli bir iş günü bulunamadı.");
        }

        leaveBalanceService.reserve(caller, leaveType, dto.startDate().getYear(), requestedDays);

        LeaveRequest request = new LeaveRequest();
        request.setUser(caller);
        request.setLeaveType(leaveType);
        request.setStartDate(dto.startDate());
        request.setEndDate(dto.endDate());
        request.setReason(toNullable(dto.reason()));
        request.setStatus("PENDING");
        request.setRequestedDays(requestedDays);
        request.setCurrentLevel(1);

        advanceChain(request, 1, 0);
        return leaveRequestRepository.save(request);
    }

    @Transactional
    public LeaveRequestDTO decide(Long requestId, User caller, LeaveRequestDecisionDTO dto) {

        String managerNote = toNullable(dto.managerNote());
        LeaveDecision decision = dto.decision();

        LeaveRequest request = leaveRequestCheck(requestId);

        if (!"PENDING".equals(request.getStatus())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Bu talep zaten sonuçlandırılmış.");
        }

        int level = request.getCurrentLevel();
        assertAuthority(caller, request, level);

        leaveRequestApprovalRepository.save(new LeaveRequestApproval(request, level, caller, decision, managerNote));

        if (decision == LeaveDecision.REJECTED) {
            request.setStatus("REJECTED");
            return toDTO(leaveRequestRepository.save(request));
        }

        long approvalsSoFar = leaveRequestApprovalRepository.countByLeaveRequest_Id(requestId);
        advanceChain(request, level + 1, (int) approvalsSoFar);

        if ("APPROVED".equals(request.getStatus())) {
            leaveBalanceService.consume(request.getUser(), request.getLeaveType(),
                    request.getStartDate().getYear(), request.getRequestedDays());
        }

        return toDTO(leaveRequestRepository.save(request));
    }

    private void assertAuthority(User caller, LeaveRequest request, int level) {
        if (caller.getRole().getName() == RoleAuthority.ADMIN) {
            return;
        }

        RoleAuthority requiredRole = roleForLevel(level);
        if (requiredRole == null || request.getUser().getDepartment() == null) {
            throw new IllegalStateException("Bu talep için onaylayıcı belirlenemiyor.");
        }

        User approver = userRepository
                .findByRole_NameAndDepartment_Id(requiredRole, request.getUser().getDepartment().getId())
                .orElseThrow(() -> new IllegalStateException(
                        "Bu departmanın " + level + ". seviye yöneticisi yok."));

        if (!approver.getId().equals(caller.getId())) {
            throw new AccessDeniedException("Yetkisiz İşlem");
        }
    }

    @Transactional
    public LeaveRequestDTO updateLeaveRequest(Long requestId, LeaveRequestCreateDTO dto, User caller) {
        LeaveRequest request = leaveRequestCheck(requestId);

        assertCanModify(caller, request);

        if (!"PENDING".equals(request.getStatus())) {
            throw new IllegalStateException("Bu talep zaten sonuçlandırılmış, düzenlenemez.");
        }

        if ((request.getCurrentLevel() == 1)
                || (request.getCurrentLevel() == 2
                        && !(caller.getRole().getName().equals(RoleAuthority.MANAGER_LEVEL_1)))
                || (request.getCurrentLevel() == 3
                        && !(caller.getRole().getName().equals(RoleAuthority.MANAGER_LEVEL_2)))
                || (request.getCurrentLevel() > 3)) {
            throw new IllegalStateException("Bu talep onay sürecine girdiği için artık düzenlenemez.");
        }

        dateChecks(dto.startDate(), dto.endDate());

        overlapCheck(caller, dto.startDate(), dto.endDate());

        requestMultiYearCheck(dto.startDate(), dto.endDate());

        LeaveType newLeaveType = leaveTypeCheck(dto.leaveTypeId());

        leaveTypeActiveCheck(newLeaveType);

        int oldRequestedDays = request.getRequestedDays();
        int newRequestedDays = leaveBalanceService.countBusinessDays(dto.startDate(), dto.endDate());

        if (newRequestedDays <= 0) {
            throw new IllegalArgumentException("Seçilen tarihler arasında geçerli bir iş günü bulunamadı.");
        }

        LeaveType oldLeaveType = request.getLeaveType();
        int oldYear = request.getStartDate().getYear();
        int newYear = dto.startDate().getYear();

        if (oldLeaveType.getId().equals(newLeaveType.getId()) && oldYear == newYear) {
            leaveBalanceService.updateReservation(caller, newLeaveType, newYear, oldRequestedDays, newRequestedDays);
        } else {
            leaveBalanceService.releaseReservedDays(caller, oldLeaveType, oldYear, oldRequestedDays);
            leaveBalanceService.reserve(caller, newLeaveType, newYear, newRequestedDays);
        }

        request.setLeaveType(newLeaveType);
        request.setStartDate(dto.startDate());
        request.setEndDate(dto.endDate());
        request.setRequestedDays(newRequestedDays);
        if (dto.reason() != null && !dto.reason().isBlank()) {
            request.setReason(dto.reason().trim());
        }

        return toDTO(leaveRequestRepository.save(request));
    }

    @Transactional
    public LeaveRequestDTO cancelLeaveRequest(Long requestId, User caller) {
        LeaveRequest request = leaveRequestCheck(requestId);

        assertCanModify(caller, request);

        if (!"PENDING".equals(request.getStatus())) {
            throw new IllegalStateException("Bu talep zaten sonuçlandırılmış, iptal edilemez.");
        }

        leaveBalanceService.releaseReservedDays(request.getUser(), request.getLeaveType(),
                request.getStartDate().getYear(), request.getRequestedDays());
        request.setStatus("CANCELLED");
        return toDTO(leaveRequestRepository.save(request));
    }

    public void deleteLeaveRequest(Long leaveRequestId) {
        LeaveRequest leaveRequest = leaveRequestCheck(leaveRequestId);

        if (!"PENDING".equals(leaveRequest.getStatus())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Sadece bekleyen (PENDING) talepler silinebilir.");
        }

        leaveBalanceService.releaseReservedDays(leaveRequest.getUser(), leaveRequest.getLeaveType(),
                leaveRequest.getStartDate().getYear(), leaveRequest.getRequestedDays());
        leaveRequestRepository.deleteById(leaveRequest.getId());
    }

    private void assertCanModify(User caller, LeaveRequest request) {
        if (caller.getRole().getName() == RoleAuthority.ADMIN) {
            return;
        }

        if (!request.getUser().getId().equals(caller.getId())) {
            throw new AccessDeniedException("Bu izin talebini değiştirme yetkiniz yok.");
        }
    }

    private LeaveRequestDTO toDTO(LeaveRequest request) {
        List<LeaveRequestApprovalDTO> approvals = leaveRequestApprovalRepository
                .findByLeaveRequest_IdOrderByLevelAsc(request.getId()).stream()
                .map(a -> new LeaveRequestApprovalDTO(
                        a.getLevel(),
                        a.getApprover().getFirstName() + " " + a.getApprover().getLastName(),
                        a.getDecision(),
                        a.getManagerNote(),
                        a.getDecidedAt()))
                .collect(Collectors.toList());

        return new LeaveRequestDTO(
                request.getId(),
                request.getUser().getFirstName() + " " + request.getUser().getLastName(),
                request.getLeaveType().getName(),
                request.getStartDate(),
                request.getEndDate(),
                request.getRequestedDays(),
                request.getStatus(),
                toNullable(request.getReason()),
                request.getCreatedAt(),
                request.getCurrentLevel(),
                approvals);
    }

    private void advanceChain(LeaveRequest request, int startLevel, int approvalsSoFar) {
        int requiredLevels = request.getLeaveType().getRequiredLevels();
        Long departmentId = request.getUser().getDepartment() != null
                ? request.getUser().getDepartment().getId()
                : null;

        Integer requesterLevel = ApprovalLevels.levelForRole(request.getUser().getRole().getName());
        int minStart = (requesterLevel != null) ? requesterLevel + 1 : 1;
        int level = Math.max(startLevel, minStart);

        if (approvalsSoFar >= requiredLevels || level > MAX_LEVEL) {
            request.setStatus("APPROVED");
            return;
        }

        while (level <= MAX_LEVEL) {
            RoleAuthority requiredRole = roleForLevel(level);
            User approver = (departmentId != null && requiredRole != null)
                    ? userRepository.findByRole_NameAndDepartment_Id(requiredRole, departmentId).orElse(null)
                    : null;

            if (approver == null) {
                request.setCurrentLevel(level);
                return;
            }

            boolean isSelf = approver.getId().equals(request.getUser().getId());
            if (!isSelf) {
                request.setCurrentLevel(level);
                return;
            }
            level++;
        }
        request.setStatus("APPROVED");
    }

    private static String toNullable(String s) {
        if (s == null)
            return null;
        String trimmed = s.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void userDepartmentNullCheck(User caller) {
        if (caller.getDepartment() == null) {
            throw new IllegalStateException("Departmanınız atanmamış, izin talebi oluşturamazsınız.");
        }
    }

    private LeaveType leaveTypeCheck(Long leaveTypeid) {
        return leaveTypeRepository.findById(leaveTypeid)
                .orElseThrow(() -> new IllegalArgumentException("İzin türü bulunamadı."));

    }

    private void dateChecks(LocalDate startDate, LocalDate endDate) {

        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Başlangıç tarihi bitiş tarihinden sonra olamaz.");
        }
        if (startDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Geçmişteki bir tarihe izin alamazsınız.");
        }
    }

    private void requestMultiYearCheck(LocalDate startDate, LocalDate endDate) {
        if (startDate.getYear() != endDate.getYear()) {
            throw new IllegalArgumentException(
                    "İzin güncellemeleri yılı aşamaz. Lütfen iptal edip yeni talep oluşturun.");
        }
    }

    private void leaveTypeActiveCheck(LeaveType leaveType) {
        if (!leaveType.getActive()) {
            throw new IllegalArgumentException("Bu izin türü artık kullanılamıyor.");
        }
    }

    private void genderCheck(User caller, LeaveType leaveType) {
        if (leaveType.getGenderRestriction() != null && !caller.getGender().equals(leaveType.getGenderRestriction())) {
            throw new AccessDeniedException("Cinsiyetinizden dolayı bu izin türünde talep yapamazsınız.");
        }
    }

    private void overlapCheck(User caller, LocalDate startDate, LocalDate endDate) {

        if (leaveRequestRepository.existsOverlappingRequest(caller.getId(), startDate, endDate, -1L)) {
            throw new IllegalArgumentException("Seçilen tarihler arasında bir talebiniz var.");
        }
    }

    private LeaveRequest leaveRequestCheck(Long leaveRequestId) {
        return leaveRequestRepository.findById(leaveRequestId)
                .orElseThrow(() -> new IllegalArgumentException(leaveRequestId + " ID'li izin talebi bulunamadı"));

    }
}