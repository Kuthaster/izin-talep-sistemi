package com.kutalmis.izin_talep_sistemi.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.kutalmis.izin_talep_sistemi.entity.LeaveRequest;

public interface LeaveRequestRepository
                extends JpaRepository<LeaveRequest, Long>, JpaSpecificationExecutor<LeaveRequest> {
        @Query("SELECT CASE WHEN COUNT(lr) > 0 THEN true ELSE false END FROM LeaveRequest lr " +
                        "WHERE lr.user.id = :userId AND lr.status IN ('PENDING', 'APPROVED') " +
                        "AND lr.id != :excludeId " +
                        "AND lr.startDate <= :endDate AND lr.endDate >= :startDate")
        boolean existsOverlappingRequest(@Param("userId") Long userId,
                        @Param("startDate") LocalDate startDate,
                        @Param("endDate") LocalDate endDate,
                        @Param("excludeId") Long excludeId);

        List<LeaveRequest> findByUser_Id(Long userId);

        Long countByStatusAndLeaveType_Id(String status, Long leaveTypeId);

        Long countByStatusAndLeaveType_IdAndUser_Department_IdIn(String status, Long leaveTypeId,
                        List<Long> userDepartmentId);

        List<LeaveRequest> findByStatusAndStartDateBefore(String status, LocalDate startDate);

        List<LeaveRequest> findByUser_Department_Id(Long departmentId);

        List<LeaveRequest> findByUser_Department_IdIn(List<Long> departmentIds);

        long countByStatus(String status);

        long countByStatusAndUser_Department_IdIn(String status, List<Long> departmentIds);
}
