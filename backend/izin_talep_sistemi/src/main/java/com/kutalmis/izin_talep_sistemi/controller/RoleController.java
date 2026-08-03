package com.kutalmis.izin_talep_sistemi.controller;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.RoleCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.RoleDTO;
import com.kutalmis.izin_talep_sistemi.dto.RoleUpdateDTO;
import com.kutalmis.izin_talep_sistemi.service.RoleService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@Tag(name = "Roles", description = "Rol yöneticisi")
@RestController
@RequestMapping("/api/roles")
@PreAuthorize("hasRole('ADMIN')")
public class RoleController {

    private final RoleService roleService;

    public RoleController(RoleService roleService) {
        this.roleService = roleService;
    }

    @Operation(summary = "Rol listesini getir. (kullanıcı oluşturma kısmı için)")
    @GetMapping
    public List<RoleDTO> getAllRoles() {
        return roleService.getAllRoles();
    }

    @Operation(summary = "Rolü güncelle")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Rol güncellendi."),
            @ApiResponse(responseCode = "400", description = "Geçersiz girdi veya rol bulunamadı.")
    })
    @PutMapping("/{id}")
    public RoleDTO updateRole(@PathVariable Long id, @Valid @RequestBody RoleUpdateDTO dto) {
        return roleService.updateRole(id, dto);
    }

    @Operation(summary = "Yeni rol oluştur")
    @PostMapping
    public RoleDTO createRole(@RequestBody RoleCreateDTO dto) {
        return roleService.createRole(dto);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteRole(@PathVariable Long id) {
        roleService.deleteRole(id);
    }

}