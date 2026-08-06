package com.kutalmis.izin_talep_sistemi.dto;

public record LeaveRequestCountDTO(Long pending, Long approved, Long rejected, Long cancelled, Long expired,
        Long total) {

}
