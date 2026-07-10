package com.kutalmis.izin_talep_sistemi.controller;

import com.kutalmis.izin_talep_sistemi.dto.UserCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserDepartmentUpdateDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserResponseDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserRoleUpdateDTO;
import com.kutalmis.izin_talep_sistemi.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PathVariable;



@Tag(name = "Admin - Users", description = "Kullanıcı yönetimi (Admin)")
@RestController
@RequestMapping("/api/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }
    @Operation(summary = "Tüm kullanıcıları listele")
    @GetMapping
    public List<UserResponseDTO> getAllUsers() {
        return userService.getAllUsers();
    }
    @Operation(summary = "Yeni kullanıcı oluştur")
    @ApiResponses(value = {
    @ApiResponse(responseCode = "400", description = "Rol veya Departman bulunamadı. / Kullanıcı ad soyad boş olamaz")
    })
    @PostMapping
    public UserResponseDTO createUser(@RequestBody UserCreateDTO dto) {
        return userService.createUser(dto);
    }
    @Operation(summary = "Kullanıcının departmanını değiştir.")
    @PutMapping("{id}/department")
    public UserResponseDTO UpdateDepartment(@PathVariable Long id,@Valid @RequestBody UserDepartmentUpdateDTO dto) {
        return userService.updateDepartment(id, dto);
    }

    @Operation(summary = "Kullanıcının rolünü değiştir.")
    @PutMapping("{id}/role")
    public UserResponseDTO  updateRole(@PathVariable Long id,@Valid @RequestBody UserRoleUpdateDTO dto) {
        return userService.updateRole(id, dto);
    }

}