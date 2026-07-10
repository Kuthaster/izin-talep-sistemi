package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotBlank;

public record RoleUpdateDTO(
    @NotBlank(message = "Rol adı boş olamaz.")
    String displayName
) {
}