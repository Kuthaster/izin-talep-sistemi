package com.kutalmis.izin_talep_sistemi.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kutalmis.izin_talep_sistemi.entity.LeaveBalance;

public interface LeaveBalanceRepository extends JpaRepository<LeaveBalance, Long> {
    Optional<LeaveBalance> findByUser_IdAndLeaveType_IdAndYear(Long userId, Long leaveTypeId, int year);
}