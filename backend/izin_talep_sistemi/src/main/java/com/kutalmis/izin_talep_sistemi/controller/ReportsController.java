package com.kutalmis.izin_talep_sistemi.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestCountDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeCountDTO;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.service.LeaveRequestService;
import com.kutalmis.izin_talep_sistemi.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@Tag(name = "Report", description = "Rapor uç noktası")
@RestController
@RequestMapping("/api/reports")
public class ReportsController {

    private final LeaveRequestService leaveRequestService;
    private final UserService userService;

    public ReportsController(LeaveRequestService leaveRequestService, UserService userService) {
        this.leaveRequestService = leaveRequestService;
        this.userService = userService;
    }

    @Operation(summary = "İzin talep adedi listele")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER_LEVEL_1','MANAGER_LEVEL_2','MANAGER_LEVEL_3')")
    @GetMapping("/dashboard")
    public LeaveRequestCountDTO getLeaveRequestCount(Principal principal) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        return leaveRequestService.getLeaveRequestCount(caller);
    }

    @Operation(summary = "İzin talep türleri adedi listele")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER_LEVEL_1','MANAGER_LEVEL_2','MANAGER_LEVEL_3')")
    @GetMapping("/dashboard/leave-types")
    public List<LeaveTypeCountDTO> getLeaveRequestCountByLeaveType(Principal principal) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        return leaveRequestService.getLeaveRequestCountByLeaveType(caller);
    }

}