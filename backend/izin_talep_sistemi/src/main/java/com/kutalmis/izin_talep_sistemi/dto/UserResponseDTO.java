package com.kutalmis.izin_talep_sistemi.dto;
import  com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;

public record UserResponseDTO(
    Long id, 
    String firstName, 
    String lastName, 
    String email, 
    String departmentName, 
    String roleDisplayName, 
    RoleAuthority roleAuthority
) {
}