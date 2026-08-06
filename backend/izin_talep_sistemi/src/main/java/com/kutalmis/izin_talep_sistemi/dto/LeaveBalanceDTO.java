package com.kutalmis.izin_talep_sistemi.dto;

public record LeaveBalanceDTO(
                Long id,
                Long userId,
                String userName,
                String leaveTypeName,
                Integer year,
                Integer totalDays,
                Integer usedDays,
                Integer reservedDays,
                Integer availableDays) {
}