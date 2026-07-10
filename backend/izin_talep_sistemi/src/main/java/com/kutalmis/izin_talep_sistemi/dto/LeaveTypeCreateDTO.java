package com.kutalmis.izin_talep_sistemi.dto;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;

public record LeaveTypeCreateDTO(
    @NotBlank(message = "İzin türü adı boş olamaz.")
    String name,

    @Positive(message = "Varsayılan gün sayısı sıfırdan büyük olmalıdır.")
    Integer defaultDays,

    @Min(value = 1, message = "Onay seviyesi en az 1 olmalıdır.")
    @Max(value = 3, message = "Onay seviyesi en fazla 3 olabilir.")
    Integer requiredLevels
) {
}   