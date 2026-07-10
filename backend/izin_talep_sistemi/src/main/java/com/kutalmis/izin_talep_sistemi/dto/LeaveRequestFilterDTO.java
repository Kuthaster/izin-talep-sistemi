package com.kutalmis.izin_talep_sistemi.dto;

import java.time.LocalDate;

public record LeaveRequestFilterDTO(
    String status,
    Long leaveTypeId,
    LocalDate startDateFrom,
    LocalDate startDateTo,
    Long approverId,
    Integer currentLevel
) {
}