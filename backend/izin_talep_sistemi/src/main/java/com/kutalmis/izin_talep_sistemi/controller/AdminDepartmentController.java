package com.kutalmis.izin_talep_sistemi.controller;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.DepartmentDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.Department;
import com.kutalmis.izin_talep_sistemi.service.DepartmentService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@Tag(name = "Admin - Departments", description = "Departman yönetimi (Admin)")
@RestController
@RequestMapping("/api/admin/departments")
@PreAuthorize("hasRole('ADMIN')")


public class AdminDepartmentController {
    private final DepartmentService departmentService;

    public AdminDepartmentController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    @Operation(summary = "Bütün departmanları yönetici bilgisiyle birlikte listele")
    @GetMapping
    public List<DepartmentDTO> getAllDepartments() {
        return departmentService.getAllDepartmentsForAdmin();
    }


    @Operation(summary = "Departman oluştur")
        @ApiResponses(value = {
        @ApiResponse(responseCode = "409", description = "Bu isimli bir departman zaten var.")
    })
    @PostMapping
    public Department createDepartment(@Valid @RequestBody Department department) {
        return departmentService.createDepartment(department);
    }

    @Operation(summary = "Departman adını güncelle")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Departman adı güncellendi."),
        @ApiResponse(responseCode = "400", description = "Departman adı boş olamaz veya rol bulunamadı.")
    })
    @PutMapping("/{id}")
    public DepartmentDTO updateDepartment(@PathVariable Long id, @Valid @RequestBody DepartmentUpdateDTO dto) {
        return departmentService.updateDepartment(id, dto);
    }

}
