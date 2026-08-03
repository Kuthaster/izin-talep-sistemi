package com.kutalmis.izin_talep_sistemi.dto;

import com.kutalmis.izin_talep_sistemi.entity.Gender;

public record LeaveTypeDTO(
                Long id,
                String name,
                Integer defaultDays,
                Boolean active,
                Integer requiredLevels,
                Gender genderRestriction) {
}