package com.kutalmis.izin_talep_sistemi.controller;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeDTO;
import com.kutalmis.izin_talep_sistemi.service.LeaveTypeService;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeUpdateDTO;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@Tag(name = "Admin - Leave Types", description = "İzin türü yönetimi (Admin)")
@RestController
@RequestMapping("/api/admin/leaveTypes")
@PreAuthorize("hasRole('ADMIN')")
public class AdminLeaveTypeController {

    private final LeaveTypeService leaveTypeService;

    public AdminLeaveTypeController(LeaveTypeService leaveTypeService) {
        this.leaveTypeService = leaveTypeService;
    }

    @Operation(summary = "Bütün izin türlerini listele (pasifler dahil)")
    @GetMapping
    public List<LeaveTypeDTO> getAllLeaveTypes() {
        return leaveTypeService.getAllLeaveTypesForAdmin();
    }

    @Operation(summary = "Izin türünü güncelle")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "İzin türü başarıyla güncellendi."),
        @ApiResponse(responseCode = "400", description = "Geçersiz girdi veya izin türü bulunamadı.")
    })
    @PutMapping("/{id}")
    public LeaveTypeDTO updateLeaveType(@PathVariable Long id, @Valid @RequestBody LeaveTypeUpdateDTO dto) {
        return leaveTypeService.updateLeaveType(id, dto);
    }

    @Operation(summary = "Yeni izin türü oluştur")
    @ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "İzin türü başarıyla oluşturuldu."),
    @ApiResponse(responseCode = "400", description = "İzin türü adı boş olamaz veya gün sayısı geçersiz."),
    @ApiResponse(responseCode = "409", description = "Bu isimli bir izin türü zaten var.")
    })
    @PostMapping
    public LeaveTypeDTO createLeaveType(@Valid @RequestBody LeaveTypeCreateDTO dto) {
        return leaveTypeService.createLeaveType(dto);

    }   
}