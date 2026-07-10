package com.kutalmis.izin_talep_sistemi.dto;

public record DepartmentApproverDTO(
    Long id,
    Long departmentId,
    String departmentName,
    Integer level,
    Long approverId,
    String approverName
) {
}   