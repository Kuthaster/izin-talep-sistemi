package com.kutalmis.izin_talep_sistemi.controller;

import com.kutalmis.izin_talep_sistemi.dto.DepartmentApproverAssignDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentApproverDTO;
import com.kutalmis.izin_talep_sistemi.service.DepartmentApproverService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Admin - Department Approvers", description = "Departman onay zinciri yönetimi (Admin)")
@RestController
@RequestMapping("/api/admin/departmentApprovers")
@PreAuthorize("hasRole('ADMIN')")
public class AdminDepartmentApproverController {

    private final DepartmentApproverService departmentApproverService;

    public AdminDepartmentApproverController(DepartmentApproverService departmentApproverService) {
        this.departmentApproverService = departmentApproverService;
    }

    @Operation(summary = "Bir departmanın onay zincirini listele")
    @GetMapping("/department/{departmentId}")
    public List<DepartmentApproverDTO> getApproversForDepartment(@PathVariable Long departmentId) {
        return departmentApproverService.getApproversForDepartment(departmentId);
    }

    @Operation(summary = "Bir departman/seviye için onaylayıcı ata/değiştir")
    @PostMapping
    public DepartmentApproverDTO assignApprover(@Valid @RequestBody DepartmentApproverAssignDTO dto) {
        return departmentApproverService.assignApprover(dto);
    }

    @Operation(summary = "Bir departman -> seviye için onaylayıcı atamasını kaldır")
    @DeleteMapping("/department/{departmentId}/level/{level}")
    public void removeApprover(@PathVariable Long departmentId, @PathVariable Integer level) {
        departmentApproverService.removeApprover(departmentId, level);
    }
}