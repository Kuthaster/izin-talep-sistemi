package com.kutalmis.izin_talep_sistemi.dto;
import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;


public record RoleDTO(Long id, RoleAuthority name, String displayName, Boolean active) {
}