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
import com.kutalmis.izin_talep_sistemi.entity.DepartmentApprover;
import com.kutalmis.izin_talep_sistemi.entity.LeaveDecision;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequest;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequestApproval;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequestSpecifications;
import com.kutalmis.izin_talep_sistemi.entity.LeaveType;
import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentApproverRepository;
import com.kutalmis.izin_talep_sistemi.repository.LeaveRequestApprovalRepository;
import com.kutalmis.izin_talep_sistemi.repository.LeaveRequestRepository;
import com.kutalmis.izin_talep_sistemi.repository.LeaveTypeRepository;

@Service
public class LeaveRequestService {
    private final LeaveBalanceService leaveBalanceService;
    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveTypeRepository leaveTypeRepository;
    private final DepartmentApproverRepository departmentApproverRepository;
    private final LeaveRequestApprovalRepository leaveRequestApprovalRepository;
    private static final int MAX_LEVEL = 3;

    public LeaveRequestService(LeaveRequestRepository leaveRequestRepository,
            LeaveTypeRepository leaveTypeRepository,
            DepartmentApproverRepository departmentApproverRepository,
            LeaveRequestApprovalRepository leaveRequestApprovalRepository, LeaveBalanceService leaveBalanceService) {
        this.leaveRequestRepository = leaveRequestRepository;
        this.leaveTypeRepository = leaveTypeRepository;
        this.departmentApproverRepository = departmentApproverRepository;
        this.leaveRequestApprovalRepository = leaveRequestApprovalRepository;
        this.leaveBalanceService = leaveBalanceService;
    }

    public List<LeaveRequestDTO> getMyLeaveRequests(User caller, String status, String reason, Long leaveTypeId,
            LocalDate startDateFrom, LocalDate startDateTo) {
        Specification<LeaveRequest> spec = Specification
                .where(LeaveRequestSpecifications.belongsToUser(caller.getId())) // scope — mandatory
                .and(LeaveRequestSpecifications.hasStatus(status))
                .and(LeaveRequestSpecifications.hasReason(reason))
                .and(LeaveRequestSpecifications.hasLeaveType(leaveTypeId))
                .and(LeaveRequestSpecifications.startDateFrom(startDateFrom))
                .and(LeaveRequestSpecifications.startDateTo(startDateTo));

        return leaveRequestRepository.findAll(spec).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
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

        List<Long> departmentIds = departmentApproverRepository.findByApprover_Id(caller.getId()).stream()
                .map(da -> da.getDepartment().getId())
                .distinct()
                .collect(Collectors.toList());

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

        List<Long> departmentIds = departmentApproverRepository.findByApprover_Id(caller.getId()).stream()
                .map(da -> da.getDepartment().getId())
                .distinct()
                .collect(Collectors.toList());

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

        LeaveType leaveType = leaveTypeRepository.findById(dto.leaveTypeId())
                .orElseThrow(() -> new IllegalArgumentException("İzin türü bulunamadı."));

        if (dto.startDate().isAfter(dto.endDate())) {
            throw new IllegalArgumentException("Başlangıç tarihi bitiş tarihinden sonra olamaz.");
        }
        if (dto.startDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Geçmişteki bir tarihe izin alamazsınız.");
        }
        if (!Boolean.TRUE.equals(leaveType.getActive())) {
            throw new IllegalArgumentException("Bu izin türü artık kullanılamıyor.");
        }
        if (leaveType.getGenderRestriction() != null && !caller.getGender().equals(leaveType.getGenderRestriction())) {
            throw new AccessDeniedException("Cinsiyetinizden dolayı bu izin türünde talep yapamazsınız.");
        }
        if (leaveRequestRepository.existsOverlappingRequest(caller.getId(), dto.startDate(), dto.endDate(), -1L)) {
            throw new IllegalArgumentException("Seçilen tarihler arasında bir talebiniz var.");
        }

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
        System.out.println("reserveRequest start=" + dto.startDate() + " end=" + dto.endDate());

        int requestedDays = leaveBalanceService.countBusinessDays(dto.startDate(), dto.endDate());

        System.out.println("requestedDays=" + requestedDays);

        if (requestedDays <= 0) {
            throw new IllegalArgumentException("no valid business days within selected dtes.");
        }
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

        LeaveRequest request = leaveRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException(requestId + " ID'li izin talebi bulunamadı."));

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

    @SuppressWarnings("unused")
    private void advancePastSelfApprovals(LeaveRequest request) {
        int requiredLevels = request.getLeaveType().getRequiredLevels();
        int level = request.getCurrentLevel() + 1;

        while (level <= requiredLevels) {
            DepartmentApprover approver = departmentApproverRepository
                    .findByDepartment_IdAndLevel(request.getUser().getDepartment().getId(), level)
                    .orElse(null);

            boolean isSelfApproval = approver != null
                    && approver.getApprover().getId().equals(request.getUser().getId());

            if (!isSelfApproval) {
                break;
            }
            level++;
        }

        if (level > requiredLevels) {
            request.setStatus("APPROVED");
        } else {
            request.setCurrentLevel(level);
        }
    }

    private void assertAuthority(User caller, LeaveRequest request, int level) {
        if (caller.getRole().getName() == RoleAuthority.ADMIN) {
            return;
        }

        DepartmentApprover approver = departmentApproverRepository
                .findByDepartment_IdAndLevel(request.getUser().getDepartment().getId(), level)
                .orElseThrow(() -> new IllegalStateException(
                        "Bu departmanın " + level + ". seviye onaylayıcısı atanmamış."));

        if (!approver.getApprover().getId().equals(caller.getId())) {
            throw new AccessDeniedException("Yetkisiz İşlem");
        }
    }

    @Transactional
    public LeaveRequestDTO updateLeaveRequest(Long requestId, LeaveRequestCreateDTO dto, User caller) {
        LeaveRequest request = leaveRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException(requestId + " ID'li izin talebi bulunamadı."));

        assertCanModify(caller, request);

        if (!"PENDING".equals(request.getStatus())) {
            throw new IllegalStateException("Bu talep zaten sonuçlandırılmış, düzenlenemez.");
        }

        if (request.getCurrentLevel() > 1) {
            throw new IllegalStateException("Bu talep onay sürecine girdiği için artık düzenlenemez.");
        }

        if (dto.startDate().isAfter(dto.endDate())) {
            throw new IllegalArgumentException("Başlangıç tarihi bitiş tarihinden sonra olamaz.");
        }

        if (leaveRequestRepository.existsOverlappingRequest(caller.getId(), dto.startDate(), dto.endDate(),
                requestId)) {
            throw new IllegalArgumentException(
                    "Seçilen tarihler arasında zaten onaylı veya bekleyen bir talebiniz var.");
        }

        if (dto.startDate().getYear() != dto.endDate().getYear()) {
            throw new IllegalArgumentException(
                    "İzin güncellemeleri yılı aşamaz. Lütfen iptal edip yeni talep oluşturun.");
        }

        if (dto.startDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Geçmişteki bir tarihe izin alamazsınız.");
        }

        LeaveType newLeaveType = leaveTypeRepository.findById(dto.leaveTypeId())
                .orElseThrow(() -> new IllegalArgumentException("İzin türü bulunamadı."));

        if (!Boolean.TRUE.equals(newLeaveType.getActive())) {
            throw new IllegalArgumentException("Bu izin türü artık kullanılamıyor.");
        }

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
        LeaveRequest request = leaveRequestRepository.findById(requestId)
                .orElseThrow(() -> new IllegalArgumentException(requestId + " ID'li izin talebi bulunamadı."));
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
        LeaveRequest leaveRequest = leaveRequestRepository.findById(leaveRequestId)
                .orElseThrow(() -> new IllegalArgumentException(leaveRequestId + " ID'li talep bulunamadı."));

        if (!"PENDING".equals(leaveRequest.getStatus())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Sadece PENDING statüsündeki talepler silinebilir.");
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

        int level = startLevel;
        if (approvalsSoFar >= requiredLevels || level > MAX_LEVEL) {
            request.setStatus("APPROVED");
            return;
        }

        while (level <= MAX_LEVEL) {
            DepartmentApprover approver = departmentApproverRepository
                    .findByDepartment_IdAndLevel(request.getUser().getDepartment().getId(), level)
                    .orElse(null);

            if (approver == null) {
                request.setCurrentLevel(level);
                return;
            }

            boolean isSelf = approver.getApprover().getId().equals(request.getUser().getId());
            if (!isSelf) {
                request.setCurrentLevel(level);
                return;
            }
            level++;
        }
        request.setCurrentLevel(MAX_LEVEL + 1);
    }

    private static String toNullable(String s) {
        if (s == null)
            return null;
        String trimmed = s.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

}
