package com.kutalmis.izin_talep_sistemi.controller;

import com.kutalmis.izin_talep_sistemi.service.UserService;
import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.izin_talep_sistemi.dto.ApproverGapDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentlessUserDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveBalanceAuditDTO;
import com.kutalmis.izin_talep_sistemi.service.DepartmentService;
import com.kutalmis.izin_talep_sistemi.service.LeaveBalanceService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@Tag(name = "Admin - Report", description = "Admin rapor uç noktası")
@RestController
@RequestMapping("/api/admin/reports")
@PreAuthorize("hasRole('ADMIN')")
public class AdminReportsController {

    private final UserService userService;
    private final DepartmentService departmentService;
    private final LeaveBalanceService leaveBalanceService;

    public AdminReportsController(DepartmentService departmentService, UserService userService,
            LeaveBalanceService leaveBalanceService) {
        this.departmentService = departmentService;
        this.userService = userService;
        this.leaveBalanceService = leaveBalanceService;
    }

    @Operation(summary = "Departmanların onaylayıcı boşluklarını listele", description = "Hangi departmanların hangi seviyelerde atanmış bir onaylayıcısı (yöneticisi) olmadığını gösterir.")
    @GetMapping("/gaps/departments")
    public List<ApproverGapDTO> getApproverGaps() {
        return departmentService.findApproverGaps();
    }

    @Operation(summary = "Departmansız kullanıcıları listele", description = "Hangi kullanıcıların departmanının olmadığını gösterir.")
    @GetMapping("/gaps/users")
    public List<DepartmentlessUserDTO> getDepartmentlessUsers() {
        return userService.findDepartmentlessUsers();
    }

    @Operation(summary = "İzin bakiyesi değişiklik kayıtlarını listele", description = "Adminlerin izin bakiyelerinde yaptığı tüm değişikliklerin denetim kaydı.")
    @GetMapping("/balance-audits")
    public List<LeaveBalanceAuditDTO> getBalanceAudits() {
        return leaveBalanceService.getAllAudits();
    }
}