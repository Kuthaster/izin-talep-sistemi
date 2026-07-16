package com.kutalmis.izin_talep_sistemi.controller;

import java.security.Principal;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.UserResponseDTO;
import com.kutalmis.izin_talep_sistemi.service.UserService;

import io.swagger.v3.oas.annotations.tags.Tag; 
import org.springframework.security.access.prepost.PreAuthorize;

@PreAuthorize("isAuthenticated()")
@Tag(name = "Users", description = "Kullanici uç noktası")
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Returns the safe Response DTO for the currently logged-in user
    @GetMapping("/me")
    public UserResponseDTO getMyProfile(Principal principal) {
        String email = principal.getName();
        return userService.getUserProfileByEmail(email); 
    }
}