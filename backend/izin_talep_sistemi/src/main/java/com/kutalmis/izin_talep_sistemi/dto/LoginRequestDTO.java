package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotBlank;

public record LoginRequestDTO(
    @NotBlank(message = "E-posta boş olamaz.")
    String email,

    @NotBlank(message = "Şifre boş olamaz.")
    String password
) {
}