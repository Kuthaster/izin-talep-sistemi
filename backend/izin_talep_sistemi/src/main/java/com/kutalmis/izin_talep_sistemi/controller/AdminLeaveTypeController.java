package com.kutalmis.izin_talep_sistemi.controller;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeDefaultDaysUpdateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeStatusUpdateDTO;
import com.kutalmis.izin_talep_sistemi.service.LeaveTypeService;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeRequiredLevelsUpdateDTO;

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

    @Operation(summary = "Varsayılan gün sayısını güncelle")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Gün sayısı güncellendi."),
        @ApiResponse(responseCode = "400", description = "Geçersiz gün sayısı veya izin türü bulunamadı.")
    })
    @PutMapping("/{id}/defaultDays")
    public LeaveTypeDTO updateDefaultDays(@PathVariable Long id, @Valid @RequestBody LeaveTypeDefaultDaysUpdateDTO dto) {
        return leaveTypeService.updateDefaultDays(id, dto);
    }

    @Operation(summary = "İzin türünü aktif/pasif yap")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Durum güncellendi."),
        @ApiResponse(responseCode = "400", description = "İzin türü bulunamadı.")
    })
    @PatchMapping("/{id}/status")
    public LeaveTypeDTO updateStatus(@PathVariable Long id, @Valid @RequestBody LeaveTypeStatusUpdateDTO dto) {
        return leaveTypeService.updateStatus(id, dto);
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
    @Operation(summary = "Gerekli onay seviyesini güncelle")
    @PutMapping("/{id}/requiredLevels")
    public LeaveTypeDTO updateRequiredLevels(@PathVariable Long id, @Valid @RequestBody LeaveTypeRequiredLevelsUpdateDTO dto) {
    return leaveTypeService.updateRequiredLevels(id, dto);
    }
}