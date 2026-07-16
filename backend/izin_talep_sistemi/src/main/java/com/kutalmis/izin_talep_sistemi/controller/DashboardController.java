package com.kutalmis.izin_talep_sistemi.controller;

import java.security.Principal;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestCountDTO;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.service.LeaveRequestService;
import com.kutalmis.izin_talep_sistemi.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;


@Tag(name = "Dashboard", description = "Basit dashboard (talep adetleri) / departman ve role göre scoped")
@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {
    private final LeaveRequestService leaveRequestService;
    private final UserService userService;

    public DashboardController(LeaveRequestService leaveRequestService, UserService userService) {
        this.leaveRequestService = leaveRequestService;
        this.userService = userService;
    }

    @Operation(summary = "Talep adetlerini elde et")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER_LEVEL_1', 'MANAGER_LEVEL_2','MANAGER_LEVEL_3')")
    @GetMapping()
    public LeaveRequestCountDTO getLeaveRequestCount(Principal principal)
    {
        User caller = userService.getUserEntityByEmail(principal.getName());


        return leaveRequestService.getLeaveRequestCount(caller);
    }
}
