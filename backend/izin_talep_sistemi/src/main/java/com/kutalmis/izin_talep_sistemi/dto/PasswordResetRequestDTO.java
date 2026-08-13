package com.kutalmis.izin_talep_sistemi.dto;

import java.time.LocalDateTime;

public record PasswordResetRequestDTO(
        Long id, Long userId, String userName, String email, LocalDateTime requestedAt) {
}