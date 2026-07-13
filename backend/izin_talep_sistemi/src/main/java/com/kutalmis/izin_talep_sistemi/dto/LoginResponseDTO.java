package com.kutalmis.izin_talep_sistemi.dto;

public record LoginResponseDTO(
    String token,
    String tokenType,
    Long userId,
    String email,
    String roleDisplayName
) {
}