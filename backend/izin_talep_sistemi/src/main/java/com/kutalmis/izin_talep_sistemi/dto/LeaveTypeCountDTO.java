package com.kutalmis.izin_talep_sistemi.dto;

public record LeaveTypeCountDTO(
        Long leaveTypeId, String leaveTypeName,
        Long pending, Long approved, Long rejected, Long cancelled, Long expired, Long total) {
}