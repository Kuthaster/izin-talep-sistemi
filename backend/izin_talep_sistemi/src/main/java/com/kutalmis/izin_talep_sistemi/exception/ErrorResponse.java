package com.kutalmis.izin_talep_sistemi.exception;

import java.time.LocalDateTime;

/**
 * ErrorResponse
 */
public record ErrorResponse(
    int status,
    String error,
    String message,
    LocalDateTime timestamp

) {
}