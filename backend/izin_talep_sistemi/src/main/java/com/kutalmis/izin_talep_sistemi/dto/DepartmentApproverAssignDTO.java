package com.kutalmis.izin_talep_sistemi.dto;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

public record DepartmentApproverAssignDTO ( 
    Long departmentId,

    @NotNull(message = "Seviye belirtilmelidir.")
    @Min(value = 1, message = "Seviye en az 1 olmalıdır.")
    @Max(value = 3, message = "Seviye en fazla 3 olabilir.")
    Integer level,

    @NotNull(message = "Onaylayan ID'si belirtilmelidir.")
    Long approverId
)
{}
