package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotNull;

public record RoleActivityUpdateDTO(
    @NotNull(message = "Aktiflik durumu belirtilmelidir.")
    Boolean active
) {
}