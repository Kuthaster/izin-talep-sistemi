package com.kutalmis.izin_talep_sistemi.dto;

public record LeaveTypeDTO(
    Long id,
    String name,
    Integer defaultDays,
    Boolean active,
    Integer requiredLevels
) {
}