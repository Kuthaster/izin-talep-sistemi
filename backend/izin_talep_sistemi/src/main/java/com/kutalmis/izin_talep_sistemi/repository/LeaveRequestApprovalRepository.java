package com.kutalmis.izin_talep_sistemi.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequestApproval;
import java.util.List;

public interface LeaveRequestApprovalRepository extends JpaRepository<LeaveRequestApproval, Long> {
    List<LeaveRequestApproval> findByLeaveRequest_IdOrderByLevelAsc(Long leaveRequestId);
    long countByLeaveRequest_Id(Long leaveRequestId);
}