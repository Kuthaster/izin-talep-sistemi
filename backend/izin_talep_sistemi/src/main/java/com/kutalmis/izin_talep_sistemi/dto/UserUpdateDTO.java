package com.kutalmis.izin_talep_sistemi.dto;

import com.kutalmis.izin_talep_sistemi.entity.Gender;

public record UserUpdateDTO(
                String firstName,
                String lastName,
                String email,
                Long departmentId,
                Long roleId,
                Boolean active,
                Gender gender) {
}
