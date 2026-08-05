package com.kutalmis.izin_talep_sistemi.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.kutalmis.izin_talep_sistemi.entity.LeaveBalanceAudit;

/**
 * LeaveBalanceAuditRepository
 */
public interface LeaveBalanceAuditRepository extends JpaRepository<LeaveBalanceAudit, Long> {

}