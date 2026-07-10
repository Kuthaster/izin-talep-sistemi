package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotNull;

public record UserRoleUpdateDTO(
    @NotNull(message = "Role adı boş olamaz")
    String displayName) {
    
}
