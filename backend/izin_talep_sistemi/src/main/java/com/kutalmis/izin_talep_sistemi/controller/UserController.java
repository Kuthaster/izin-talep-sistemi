package com.kutalmis.izin_talep_sistemi.controller;

import java.security.Principal;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.ChangePasswordDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserResponseDTO;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.service.UserService;

import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@PreAuthorize("isAuthenticated()")
@Tag(name = "Users", description = "Kullanici uç noktası")
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/profile")
    public UserResponseDTO getMyProfile(Principal principal) {
        String email = principal.getName();
        return userService.getUserProfileByEmail(email);
    }

    @PatchMapping("/profile/password")
    public void changePassword(Principal principal, @Valid @RequestBody ChangePasswordDTO dto) {

        User caller = userService.getUserEntityByEmail(principal.getName());

        userService.changePassword(caller, dto);
    }

}