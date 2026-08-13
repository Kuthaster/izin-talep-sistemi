package com.kutalmis.izin_talep_sistemi.dto;

import java.time.LocalDateTime;

public record LeaveRequestAttachmentDTO(Long id, String fileName, String contentType, LocalDateTime uploadedAt) {
}
