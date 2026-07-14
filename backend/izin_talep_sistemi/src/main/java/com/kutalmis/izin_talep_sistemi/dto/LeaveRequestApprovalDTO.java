package com.kutalmis.izin_talep_sistemi.dto;

import com.kutalmis.izin_talep_sistemi.entity.LeaveDecision;
import java.time.LocalDateTime;

public record LeaveRequestApprovalDTO(
    Integer level,
    String approverName,
    LeaveDecision decision,
    String note,
    LocalDateTime decidedAt
) {
}