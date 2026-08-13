package com.kutalmis.izin_talep_sistemi.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "leave_request_attachments")
public class LeaveRequestAttachment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "leave_request_id", nullable = false)
    private LeaveRequest leaveRequest;

    @Column(nullable = false)
    private String originalFileName;

    @Column(nullable = false, unique = true)
    private String storedFileName;

    @Column(nullable = false)
    private String contentType;

    @Column(nullable = false, updatable = false)
    private LocalDateTime uploadedAt = LocalDateTime.now();

    public LeaveRequestAttachment() {
    }

    public LeaveRequestAttachment(LeaveRequest leaveRequest, String originalFileName,
            String storedFileName, String contentType) {
        this.leaveRequest = leaveRequest;
        this.originalFileName = originalFileName;
        this.storedFileName = storedFileName;
        this.contentType = contentType;
    }

    public Long getId() {
        return id;
    }

    public LeaveRequest getLeaveRequest() {
        return leaveRequest;
    }

    public String getOriginalFileName() {
        return originalFileName;
    }

    public String getStoredFileName() {
        return storedFileName;
    }

    public String getContentType() {
        return contentType;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }
}