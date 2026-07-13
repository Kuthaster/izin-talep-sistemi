package com.kutalmis.izin_talep_sistemi.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record LeaveRequestDTO(
    Long id,
    String userName,
    String leaveTypeName,
    LocalDate startDate,
    LocalDate endDate,
    String status,
    String managerNote,
    LocalDateTime createdAt,
    Integer currentLevel
) {
}