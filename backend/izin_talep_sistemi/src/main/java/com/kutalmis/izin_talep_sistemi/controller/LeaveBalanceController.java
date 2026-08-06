package com.kutalmis.izin_talep_sistemi.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.kutalmis.izin_talep_sistemi.dto.LeaveBalanceDTO;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.service.LeaveBalanceService;
import com.kutalmis.izin_talep_sistemi.service.UserService;
import java.security.Principal;
import java.util.List;

@Tag(name = "Leave Balance", description = "izin bakiyesi uç noktası")
@RestController
@RequestMapping("/api/leaveBalances")
public class LeaveBalanceController {

    private final LeaveBalanceService leaveBalanceService;
    private final UserService userService;

    public LeaveBalanceController(LeaveBalanceService leaveBalanceService, UserService userService) {
        this.leaveBalanceService = leaveBalanceService;
        this.userService = userService;
    }

    @Operation(summary = "Kendi izin bakiyelerimi listele")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/mine")
    public List<LeaveBalanceDTO> getMyBalances(Principal principal) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        return leaveBalanceService.getUserBalances(caller.getId(), null, null);
    }

}