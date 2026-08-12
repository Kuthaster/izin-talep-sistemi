package com.kutalmis.izin_talep_sistemi.controller;

import com.kutalmis.izin_talep_sistemi.dto.LoginRequestDTO;
import com.kutalmis.izin_talep_sistemi.dto.LoginResponseDTO;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.security.JwtService;
import com.kutalmis.izin_talep_sistemi.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Auth", description = "Giriş uç noktası")
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserService userService;

    public AuthController(AuthenticationManager authenticationManager, JwtService jwtService, UserService userService) {
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
        this.userService = userService;
    }

    @Operation(summary = "Giriş yap")
    @PostMapping("/login")
    public LoginResponseDTO login(@Valid @RequestBody LoginRequestDTO dto) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(dto.email(), dto.password()));
        } catch (BadCredentialsException e) {
            throw new BadCredentialsException("E-posta veya şifre hatalı.");
        } catch (DisabledException e) {
            throw new AccessDeniedException("Hesabınız devre dışı bırakılmış. Lütfen yöneticinizle iletişime geçin.");
        } catch (AuthenticationException e) {
            throw new IllegalStateException(
                    "Beklenmedik bir hata meydana geldi. Lütfen daha sonra tekrar deneyin. Hata devam ederse, admine bildirin..",
                    e);
        }

        User user = userService.getUserEntityByEmail(dto.email());
        String token = jwtService.generateToken(user.getEmail(), user.getRole().getName().name());

        return new LoginResponseDTO(token, "Bearer", user.getId(), user.getEmail(), user.getRole().getDisplayName());
    }
}