package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotNull;

public record LeaveTypeStatusUpdateDTO(
    @NotNull(message = "Aktiflik durumu belirtilmelidir.")
    Boolean active
) {
}