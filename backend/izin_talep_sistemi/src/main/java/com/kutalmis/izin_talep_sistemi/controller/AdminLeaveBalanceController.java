package com.kutalmis.izin_talep_sistemi.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.kutalmis.izin_talep_sistemi.dto.LeaveBalanceDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveBalanceUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.service.LeaveBalanceService;
import com.kutalmis.izin_talep_sistemi.service.UserService;
import java.security.Principal;
import java.util.List;

@Tag(name = "Leave Balance", description = "Admin izin bakiyesi yönetim uç noktası")
@RestController
@RequestMapping("/api/admin/leaveBalances")
@PreAuthorize("hasRole('ADMIN')")
public class AdminLeaveBalanceController {

    private final LeaveBalanceService leaveBalanceService;
    private final UserService userService;

    public AdminLeaveBalanceController(LeaveBalanceService leaveBalanceService, UserService userService) {
        this.leaveBalanceService = leaveBalanceService;
        this.userService = userService;
    }

    @Operation(summary = "kullanıcının balansını al")
    @GetMapping
    public List<LeaveBalanceDTO> getUserBalances(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Long leaveTypeId) {
        return leaveBalanceService.getUserBalances(userId, year, leaveTypeId);
    }

    @Operation(summary = "Bir Kullanıcının izin bakiyesini düzenle")
    @PutMapping("/{balanceId}")
    public LeaveBalanceDTO updateBalance(@PathVariable Long balanceId, @Valid @RequestBody LeaveBalanceUpdateDTO dto,
            Principal principal) {
        User admin = userService.getUserEntityByEmail(principal.getName());
        return leaveBalanceService.updateBalanceAsAdmin(balanceId, dto, admin);
    }

}