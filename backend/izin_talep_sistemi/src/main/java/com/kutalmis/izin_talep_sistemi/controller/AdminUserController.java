package com.kutalmis.izin_talep_sistemi.controller;

import com.kutalmis.izin_talep_sistemi.service.PasswordResetService;
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

import com.kutalmis.izin_talep_sistemi.dto.TempPasswordDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserResponseDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserUpdateDTO;
import com.kutalmis.izin_talep_sistemi.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@Tag(name = "Admin - Users", description = "Kullanıcı yönetimi (Admin)")
@RestController
@RequestMapping("/api/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final PasswordResetService passwordResetService;
    private final UserService userService;

    public AdminUserController(UserService userService, PasswordResetService passwordResetService) {
        this.userService = userService;
        this.passwordResetService = passwordResetService;
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

    @Operation(summary = "Kullanıcını bilgilerini güncelle")
    @PutMapping("/{id}")
    public UserResponseDTO updateUser(@PathVariable Long id, @Valid @RequestBody UserUpdateDTO dto) {
        return userService.updateUser(id, dto);
    }

    @Operation(summary = "Kullanıcıyı Sil (ADMİN)", description = "Bunun yerine deaktivasyon yapmak önerilir")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Kullanıcı başarıyla silindi."),
            @ApiResponse(responseCode = "403", description = "Bu kullanıcıyı silme yetkiniz yok."),
            @ApiResponse(responseCode = "400", description = "Geçersiz girdi: Kullanıcı bulunamadı.")
    })
    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
    }

    @Operation(summary = "Kullanıcı için geçici şifre oluştur")
    @PostMapping("/{userId}/issue-temp-password")
    public TempPasswordDTO issueTempPassword(@PathVariable Long userId) {
        return passwordResetService.issueTempPassword(userId);
    }
}