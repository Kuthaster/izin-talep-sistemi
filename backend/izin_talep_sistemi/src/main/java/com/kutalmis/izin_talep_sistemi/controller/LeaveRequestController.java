package com.kutalmis.izin_talep_sistemi.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestCountDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestDecisionDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestFilterDTO;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.service.LeaveRequestService;
import com.kutalmis.izin_talep_sistemi.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@Tag(name = "Leave Request", description = "Çalışan izin yönetim uç noktası")
@RestController
@RequestMapping("/api/leaveRequests")
public class LeaveRequestController {

    private final LeaveRequestService leaveRequestService;
    private final UserService userService;

    public LeaveRequestController(LeaveRequestService leaveRequestService, UserService userService) {
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

    @Operation(summary = "Kendi izin taleplerimi listele")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/mine")
    public List<LeaveRequestDTO> getMyLeaveRequests(
            Principal principal,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String reason,
            @RequestParam(required = false) Long leaveTypeId,
            @RequestParam(required = false) LocalDate startDateFrom,
            @RequestParam(required = false) LocalDate startDateTo) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        return leaveRequestService.getMyLeaveRequests(caller, status, reason, leaveTypeId, startDateFrom, startDateTo);
    }

    @Operation(summary = "Onaylayıcısı olduğum departmanların taleplerini listele", description = "Admin tüm talepleri, yönetici ise onaylayıcı olarak atandığı departman(lar)ın tüm taleplerini görür.")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER_LEVEL_1','MANAGER_LEVEL_2','MANAGER_LEVEL_3')")
    @GetMapping("/forApproval")
    public List<LeaveRequestDTO> getRequestsForApproval(
            Principal principal,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String reason,
            @RequestParam(required = false) Long leaveTypeId,
            @RequestParam(required = false) LocalDate startDateFrom,
            @RequestParam(required = false) LocalDate startDateTo,
            @RequestParam(required = false) Long approverId,
            @RequestParam(required = false) Integer currentLevel) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        LeaveRequestFilterDTO filter = new LeaveRequestFilterDTO(status, reason, leaveTypeId, startDateFrom,
                startDateTo,
                approverId, currentLevel);
        return leaveRequestService.getRequestsForApproval(caller, filter);
    }

    @Operation(summary = "Yeni bir izin talebi oluştur", description = "Giriş yapmış kullanıcı adına yeni izin talebi oluşturur, default status PENDING")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "İzin talebi başarıyla oluşturuldu."),
            @ApiResponse(responseCode = "400", description = "Geçersiz tarih veya eksik veri."),
            @ApiResponse(responseCode = "409", description = "Kullanıcı zaten bekleyen bir talebe sahip.")
    })
    @PreAuthorize("isAuthenticated()")
    @PostMapping
    public LeaveRequestDTO createLeaveRequest(@Valid @RequestBody LeaveRequestCreateDTO dto, Principal principal) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        return leaveRequestService.createLeaveRequest(dto, caller);
    }

    @Operation(summary = "İzin talebini onayla/reddet")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "İşlem başarılı."),
            @ApiResponse(responseCode = "403", description = "Bu talebi onaylama/reddetme yetkiniz yok."),
            @ApiResponse(responseCode = "409", description = "Talep zaten sonuçlandırılmış.")
    })
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER_LEVEL_1', 'MANAGER_LEVEL_2','MANAGER_LEVEL_3')")
    @PatchMapping("/forApproval/{id}")
    public LeaveRequestDTO decide(@Valid @PathVariable Long id, Principal principal,
            @Valid @RequestBody LeaveRequestDecisionDTO dto) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        return leaveRequestService.decide(id, caller, dto);
    }

    @Operation(summary = "İzin talebini güncelle", description = "Yalnızca henüz onay sürecine girmemiş (PENDING, seviye 1) kendi talebiniz güncellenebilir.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Talep güncellendi."),
            @ApiResponse(responseCode = "400", description = "Geçersiz tarih veya izin türü."),
            @ApiResponse(responseCode = "403", description = "Bu talebi düzenleme yetkiniz yok."),
            @ApiResponse(responseCode = "409", description = "Talep zaten sonuçlandırılmış veya onay sürecinde.")
    })
    @PreAuthorize("isAuthenticated()")
    @PutMapping("/mine/{id}")
    public LeaveRequestDTO updateLeaveRequest(@Valid @PathVariable Long id, @RequestBody LeaveRequestCreateDTO dto,
            Principal principal) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        return leaveRequestService.updateLeaveRequest(id, dto, caller);
    }

    @Operation(summary = "İzin talebini iptal et", description = "Bekleyen (PENDING) bir talep iptal edilebilir.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Talep başarıyla iptal edildi."),
            @ApiResponse(responseCode = "403", description = "Bu talebi iptal etme yetkiniz yok."),
            @ApiResponse(responseCode = "409", description = "Talep zaten sonuçlandırılmış.")
    })
    @PreAuthorize("isAuthenticated()")
    @PatchMapping("/mine/{id}")
    public LeaveRequestDTO cancelLeaveRequest(@PathVariable Long id, Principal principal) {
        User caller = userService.getUserEntityByEmail(principal.getName());
        return leaveRequestService.cancelLeaveRequest(id, caller);
    }

    @Operation(summary = "İzin Talebini Sil (ADMİN)", description = "Bunun yerine deaktivasyon yapmak önerilir")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Talep başarıyla silindi."),
            @ApiResponse(responseCode = "403", description = "Bu talebi silme yetkiniz yok."),
            @ApiResponse(responseCode = "400", description = "Geçersiz girdi: Talep bulunamadı.")
    })
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteLeaveRequest(@PathVariable Long id) {
        leaveRequestService.deleteLeaveRequest(id);
    }
}
