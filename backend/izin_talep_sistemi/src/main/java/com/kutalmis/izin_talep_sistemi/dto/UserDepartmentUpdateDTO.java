package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotNull;

/**
 * UserDepartmentUpdateDTO
 */
public record UserDepartmentUpdateDTO(
    @NotNull(message = "Departman ID boş olamaz.")
    Long departmentId ) {
}