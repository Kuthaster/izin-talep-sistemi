package com.kutalmis.izin_talep_sistemi.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.kutalmis.izin_talep_sistemi.entity.LeaveRequest;

public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, Long>, JpaSpecificationExecutor<LeaveRequest>{
    boolean existsByUserIdAndStatus(Long userId, String status);
    List<LeaveRequest> findByUser_Id(Long userId);
    List<LeaveRequest> findByUser_Department_Id(Long departmentId);
    List<LeaveRequest> findByUser_Department_IdIn(List<Long> departmentIds);
    long countByStatus(String status);
    long countByStatusAndUser_Department_IdIn(String status, List<Long> departmentIds);
}

