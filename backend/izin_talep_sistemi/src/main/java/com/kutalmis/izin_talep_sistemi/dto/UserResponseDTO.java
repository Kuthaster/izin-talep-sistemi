package com.kutalmis.izin_talep_sistemi.dto;

public record UserResponseDTO(
    Long id, 
    String firstName, 
    String lastName, 
    String email, 
    String departmentName, 
    String roleDisplayName 
) {
}