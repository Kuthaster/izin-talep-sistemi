package com.kutalmis.izin_talep_sistemi.dto;

import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;

/**
 * RoleCreateDTO
 */
public record RoleCreateDTO(
    String displayName,
    RoleAuthority name
) {
}