package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotBlank;

public record DepartmentUpdateDTO(
    @NotBlank(message = "Departman adı boş olamaz.")
    String departmentName
){}
