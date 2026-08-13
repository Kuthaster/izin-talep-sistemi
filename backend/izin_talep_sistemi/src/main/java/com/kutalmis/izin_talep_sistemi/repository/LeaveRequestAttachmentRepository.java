package com.kutalmis.izin_talep_sistemi.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kutalmis.izin_talep_sistemi.entity.LeaveRequestAttachment;

public interface LeaveRequestAttachmentRepository extends JpaRepository<LeaveRequestAttachment, Long> {
    List<LeaveRequestAttachment> findByLeaveRequest_Id(Long leaveRequestId);
}