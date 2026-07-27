package com.kutalmis.izin_talep_sistemi.dto;

public record UserUpdateDTO(
        String firstName,
        String lastName,
        String email,
        Long departmentId,
        Long roleId,
        Boolean active) {
}
