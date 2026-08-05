package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotNull;

public record LeaveBalanceUpdateDTO(
        @NotNull(message = "Yeni toplam gün sayısı boş olamaz") Integer newTotalDays,
        @NotNull(message = "Değişiklik sebebi boş olamaz") String reason) {
}