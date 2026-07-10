package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.Positive;

public record LeaveTypeDefaultDaysUpdateDTO(
    @Positive(message = "Varsayılan gün sayısı sıfırdan büyük olmalıdır.")
    Integer defaultDays
) {
}