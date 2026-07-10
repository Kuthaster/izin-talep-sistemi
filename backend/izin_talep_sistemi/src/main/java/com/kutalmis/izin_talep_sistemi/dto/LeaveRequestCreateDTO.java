package com.kutalmis.izin_talep_sistemi.dto;
import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDate;

/**
 * LeaveRequestCreateDTO
 */
public record LeaveRequestCreateDTO(
    @Schema (description = "Oluşturulan izin talebinin türünün ID'si")
    Long leaveTypeId,

    @Schema(description = "Başlangıç tarihi")
    LocalDate startDate,

    @Schema(description = "Bitiş tarihi")
    LocalDate endDate,

    @Schema(description = "İzin nedeni (Opsiyonel)")
    String reason
) {
}   