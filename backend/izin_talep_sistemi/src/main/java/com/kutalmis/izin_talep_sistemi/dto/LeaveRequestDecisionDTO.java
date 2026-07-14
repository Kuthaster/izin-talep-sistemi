package com.kutalmis.izin_talep_sistemi.dto;
import com.kutalmis.izin_talep_sistemi.entity.LeaveDecision;

import jakarta.validation.constraints.NotNull;

public record LeaveRequestDecisionDTO(
    String managerNote, @NotNull(message= "Karar boş olamaz")LeaveDecision decision
) {
    
}
