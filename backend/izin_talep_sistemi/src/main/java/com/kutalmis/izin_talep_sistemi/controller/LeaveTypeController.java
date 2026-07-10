package com.kutalmis.izin_talep_sistemi.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeDTO;
import com.kutalmis.izin_talep_sistemi.service.LeaveTypeService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag; 


@Tag(name = "Leave Types", description = "İzin türleri yönetim uç noktası")
@RestController
@RequestMapping("/api/leaveTypes")
public class LeaveTypeController {

    private final LeaveTypeService leaveTypeService;

    public LeaveTypeController(LeaveTypeService leaveTypeService) {
        this.leaveTypeService = leaveTypeService;
    }

    @Operation(summary = "Aktif izin türlerini listele")
    @GetMapping
    public List<LeaveTypeDTO> getActiveLeaveTypes() {
        
        return leaveTypeService.getActiveLeaveTypes();
    }
    
}

