package com.kutalmis.izin_talep_sistemi.service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestApprovalDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestCountDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestDTO;
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
    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveTypeRepository leaveTypeRepository;
    private final DepartmentApproverRepository departmentApproverRepository;
    private final LeaveRequestApprovalRepository leaveRequestApprovalRepository;

    public LeaveRequestService(LeaveRequestRepository leaveRequestRepository,
                                LeaveTypeRepository leaveTypeRepository,
                                DepartmentApproverRepository departmentApproverRepository,
                                LeaveRequestApprovalRepository leaveRequestApprovalRepository) {
        this.leaveRequestRepository = leaveRequestRepository;
        this.leaveTypeRepository = leaveTypeRepository;
        this.departmentApproverRepository = departmentApproverRepository;
        this.leaveRequestApprovalRepository = leaveRequestApprovalRepository;
    }

    public List<LeaveRequestDTO> getMyLeaveRequests(User caller, String status, Long leaveTypeId,
                                                 LocalDate startDateFrom, LocalDate startDateTo) {
    Specification<LeaveRequest> spec = Specification
        .where(LeaveRequestSpecifications.belongsToUser(caller.getId()))   // scope — mandatory
        .and(LeaveRequestSpecifications.hasStatus(status))
        .and(LeaveRequestSpecifications.hasLeaveType(leaveTypeId))
        .and(LeaveRequestSpecifications.startDateFrom(startDateFrom))
        .and(LeaveRequestSpecifications.startDateTo(startDateTo));

    return leaveRequestRepository.findAll(spec).stream()
        .map(this::toDTO)
        .collect(Collectors.toList());
    }

    public List<LeaveRequestDTO> getRequestsForApproval(User caller, LeaveRequestFilterDTO filter) {
    Specification<LeaveRequest> filters = Specification
        .where(LeaveRequestSpecifications.hasStatus(filter.status()))
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

    
    public LeaveRequestCountDTO getLeaveRequestCount(User caller){
        
        if (caller.getRole().getName() == RoleAuthority.ADMIN){
            Long pending = leaveRequestRepository.countByStatus("PENDING");
            Long approved = leaveRequestRepository.countByStatus("APPROVED");
            Long rejected = leaveRequestRepository.countByStatus("REJECTED");
            Long cancelled = leaveRequestRepository.countByStatus("CANCELLED");
            Long total = cancelled + rejected + pending + approved;
            return new LeaveRequestCountDTO(pending, approved,rejected,cancelled, total);       
        }

        List<Long> departmentIds = departmentApproverRepository.findByApprover_Id(caller.getId()).stream()
        .map(da -> da.getDepartment().getId())
        .distinct()
        .collect(Collectors.toList());

        if (departmentIds.isEmpty()) {
            return new LeaveRequestCountDTO(0L, 0L, 0L, 0L, 0L);

        }

        Long pending = leaveRequestRepository.countByStatusAndUser_Department_IdIn("PENDING", departmentIds);
        Long approved = leaveRequestRepository.countByStatusAndUser_Department_IdIn("APPROVED", departmentIds);
        Long rejected = leaveRequestRepository.countByStatusAndUser_Department_IdIn("REJECTED", departmentIds);
        Long cancelled = leaveRequestRepository.countByStatusAndUser_Department_IdIn("CANCELLED", departmentIds);
        Long total = cancelled + rejected + pending + approved;

        return new LeaveRequestCountDTO(pending, approved,rejected,cancelled, total);
    }

    public LeaveRequestDTO createLeaveRequest(LeaveRequestCreateDTO dto, User caller) {
        if (leaveRequestRepository.existsByUserIdAndStatus(caller.getId(), "PENDING")){
            throw new IllegalStateException("Zaten bekleyen bir talebiniz var.");
        }

        if(dto.startDate().isAfter(dto.endDate())){
            throw new IllegalArgumentException("Başlangıç tarihi bitiş tarihinden sonra olamaz.");
        }

        if (dto.startDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Geçmişteki bir tarihe izin alamazsınız.");
        }

        LeaveType leaveType = leaveTypeRepository.findById(dto.leaveTypeId())
            .orElseThrow(() -> new IllegalArgumentException("İzin türü bulunamadı."));

        if (!Boolean.TRUE.equals(leaveType.getActive())) {
            throw new IllegalArgumentException("Bu izin türü artık kullanılamıyor.");
        }

        LeaveRequest request = new LeaveRequest();
        request.setUser(caller);
        request.setLeaveType(leaveType);
        request.setStartDate(dto.startDate());
        request.setEndDate(dto.endDate());
        request.setReason(dto.reason());
        request.setStatus("PENDING");

        request.setCurrentLevel(1);

        advanceChain(request, 1, 0);    

        LeaveRequest savedRequest = leaveRequestRepository.save(request);

        return toDTO(savedRequest);
    }

    @Transactional
    public LeaveRequestDTO decide(Long requestId, User caller, String note, LeaveDecision decision) {

    LeaveRequest request = leaveRequestRepository.findById(requestId)
        .orElseThrow(() -> new IllegalArgumentException(requestId + " ID'li izin talebi bulunamadı."));

    if (!"PENDING".equals(request.getStatus())) {
        throw new IllegalStateException("Bu talep zaten sonuçlandırılmış.");
    }

    int level = request.getCurrentLevel();
    assertCanDecide(caller, request, level);

    leaveRequestApprovalRepository.save(new LeaveRequestApproval(request, level, caller, decision, note));

    if (decision == LeaveDecision.REJECTED) {
        request.setStatus("REJECTED");
        return toDTO(leaveRequestRepository.save(request));
    }

    long approvalsSoFar = leaveRequestApprovalRepository.countByLeaveRequest_Id(requestId);
    advanceChain(request, level + 1, (int) approvalsSoFar);

    return toDTO(leaveRequestRepository.save(request));
    }

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

    private void assertCanDecide(User caller, LeaveRequest request, int level) {
        if (caller.getRole().getName() == RoleAuthority.ADMIN) {
            return;
        }

        DepartmentApprover approver = departmentApproverRepository
            .findByDepartment_IdAndLevel(request.getUser().getDepartment().getId(), level)
            .orElseThrow(() -> new IllegalStateException(
                "Bu departmanın " + level + ". seviye onaylayıcısı atanmamış."));

        if (!approver.getApprover().getId().equals(caller.getId())) {
            throw new AccessDeniedException("Bu izin talebini onaylama/reddetme yetkiniz yok.");
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

    if (dto.startDate().isBefore(LocalDate.now())) {
        throw new IllegalArgumentException("Geçmişteki bir tarihe izin alamazsınız.");
    }

    LeaveType leaveType = leaveTypeRepository.findById(dto.leaveTypeId())
        .orElseThrow(() -> new IllegalArgumentException("İzin türü bulunamadı."));

    if (!Boolean.TRUE.equals(leaveType.getActive())) {
        throw new IllegalArgumentException("Bu izin türü artık kullanılamıyor.");
    }

    request.setLeaveType(leaveType);
    request.setStartDate(dto.startDate());
    request.setEndDate(dto.endDate());
    request.setReason(dto.reason());

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

        request.setStatus("CANCELLED");

        return toDTO(leaveRequestRepository.save(request));
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
            a.getNote(),
            a.getDecidedAt()
        ))
        .collect(Collectors.toList());

        return new LeaveRequestDTO(
                request.getId(),
                request.getUser().getFirstName() + " " + request.getUser().getLastName(),
                request.getLeaveType().getName(),
                request.getStartDate(),
                request.getEndDate(),
                request.getStatus(),
                request.getCreatedAt(),
                request.getCurrentLevel(),
                approvals
        );
    }

    private static final int MAX_LEVEL = 3;

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

}
