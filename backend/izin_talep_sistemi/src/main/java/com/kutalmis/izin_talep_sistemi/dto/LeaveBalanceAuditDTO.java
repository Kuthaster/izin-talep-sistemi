package com.kutalmis.izin_talep_sistemi.dto;

import java.time.LocalDateTime;

public record LeaveBalanceAuditDTO(
        Long id,
        Long balanceId,
        String leaveTypeName,
        String userName,
        String adminName,
        Integer oldTotalDays,
        Integer newTotalDays,
        String reason,
        LocalDateTime changedAt) {
}