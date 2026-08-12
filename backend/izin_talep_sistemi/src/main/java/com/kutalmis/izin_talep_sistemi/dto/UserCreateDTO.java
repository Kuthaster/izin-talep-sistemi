package com.kutalmis.izin_talep_sistemi.dto; // Match your package path

import com.kutalmis.izin_talep_sistemi.entity.Gender;

public record UserCreateDTO(
        String firstName,
        String lastName,
        String email,
        String rawPassword,
        Long departmentId,
        Long roleId,
        Gender gender) {
}