package com.kutalmis.izin_talep_sistemi.controller;

import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestAttachmentDTO;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequestAttachment;
import com.kutalmis.izin_talep_sistemi.service.LeaveRequestAttachmentService;

import io.swagger.v3.oas.annotations.Operation;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/leaveRequests")
public class LeaveRequestAttachmentController {

    private final LeaveRequestAttachmentService attachmentService;

    public LeaveRequestAttachmentController(LeaveRequestAttachmentService attachmentService) {
        this.attachmentService = attachmentService;
    }

    @Operation(summary = "Dosya yükle")
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/{id}/attachments")
    public LeaveRequestAttachmentDTO upload(@PathVariable Long id, @RequestParam("file") MultipartFile file) {
        return attachmentService.upload(id, file);
    }

    @Operation(summary = "Dosya listele")
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/{id}/attachments")
    public List<LeaveRequestAttachmentDTO> list(@PathVariable Long id) {
        return attachmentService.getAttachments(id);
    }

    @Operation(summary = "Dosyayı indir (zaman yetmediğinden herkes id tahminiyle dosya indirebiliyor normalde bu requesti yapannın üstündeki maangerlerin görmesi lazım)") // NOTE
                                                                                                                                                                            // z
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/attachments/{attachmentId}/download")
    public ResponseEntity<Resource> download(@PathVariable Long attachmentId) {
        LeaveRequestAttachment attachment = attachmentService.getAttachmentEntity(attachmentId);
        Resource resource = attachmentService.loadAsResource(attachmentId);

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(attachment.getContentType()))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" + attachment.getOriginalFileName() + "\"")
                .body(resource);
    }

    @Operation(summary = "Dosyayı sil")
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/attachments/{attachmentId}")
    public void delete(@PathVariable Long attachmentId) {
        attachmentService.delete(attachmentId);
    }
}