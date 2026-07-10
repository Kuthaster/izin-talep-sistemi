package com.kutalmis.izin_talep_sistemi.dto; // Match your package path

public record UserCreateDTO(
    String firstName,
    String lastName,
    String email,
    String rawPassword,
    Long departmentId,
    Long roleId,
    Integer assignAsApproverLevel
) {
}