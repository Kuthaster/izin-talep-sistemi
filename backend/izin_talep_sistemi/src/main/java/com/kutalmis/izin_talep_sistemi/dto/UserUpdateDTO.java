package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotNull;

public record UserUpdateDTO(
    @NotNull 
    Boolean active,
    @NotNull(message = "Departman ID boş olamaz.")
    Long departmentId,
    @NotNull(message = "Rol adı boş olamaz")
    String displayName
){}
