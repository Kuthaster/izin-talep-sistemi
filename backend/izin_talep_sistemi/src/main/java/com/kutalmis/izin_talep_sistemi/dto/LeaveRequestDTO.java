package com.kutalmis.izin_talep_sistemi.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public record LeaveRequestDTO(
                Long id,
                String userName,
                String leaveTypeName,
                LocalDate startDate,
                LocalDate endDate,
                Integer requestedDays,
                String status,
                String reason,
                LocalDateTime createdAt,
                Integer currentLevel,
                List<LeaveRequestApprovalDTO> approvals) {
}