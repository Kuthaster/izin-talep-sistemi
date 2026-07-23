package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotNull;

public record ChangePasswordDTO(
    @NotNull(message = "Şuanki şifre null")
    String currentPassword,
    @NotNull (message = "yeni şifre null")
    String newPassword
){}
