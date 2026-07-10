package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record LeaveTypeRequiredLevelsUpdateDTO(
    @NotNull(message = "Onay seviyesi belirtilmelidir.")
    @Min(value = 1, message = "Onay seviyesi en az 1 olmalıdır.")
    @Max(value = 3, message = "Onay seviyesi en fazla 3 olabilir.")
    Integer requiredLevels
) {
}