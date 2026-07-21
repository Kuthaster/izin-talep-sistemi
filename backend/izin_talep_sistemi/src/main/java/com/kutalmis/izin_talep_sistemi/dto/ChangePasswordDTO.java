package com.kutalmis.izin_talep_sistemi.dto;

public record ChangePasswordDTO(
    String currentPassword,
    String newPassword
){}
