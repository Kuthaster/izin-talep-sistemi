package com.kutalmis.izin_talep_sistemi.service;

import com.kutalmis.izin_talep_sistemi.dto.LeaveRequestAttachmentDTO;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequest;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequestAttachment;
import com.kutalmis.izin_talep_sistemi.repository.LeaveRequestAttachmentRepository;
import com.kutalmis.izin_talep_sistemi.repository.LeaveRequestRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class LeaveRequestAttachmentService {

    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "application/pdf",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB

    private final LeaveRequestAttachmentRepository attachmentRepository;
    private final LeaveRequestRepository leaveRequestRepository;
    private final Path uploadDir;

    public LeaveRequestAttachmentService(
            LeaveRequestAttachmentRepository attachmentRepository,
            LeaveRequestRepository leaveRequestRepository,
            @Value("${app.upload-dir}") String uploadDirProperty) {
        this.attachmentRepository = attachmentRepository;
        this.leaveRequestRepository = leaveRequestRepository;
        this.uploadDir = Paths.get(uploadDirProperty).toAbsolutePath().normalize();
        try {
            Files.createDirectories(this.uploadDir);
        } catch (IOException e) {
            throw new IllegalStateException("Yükleme dizini oluşturulamadı.", e);
        }
    }

    @Transactional
    public LeaveRequestAttachmentDTO upload(Long leaveRequestId, MultipartFile file) {
        LeaveRequest request = leaveRequestRepository.findById(leaveRequestId)
                .orElseThrow(() -> new IllegalArgumentException(leaveRequestId + " ID'li izin talebi bulunamadı."));

        if (file.isEmpty()) {
            throw new IllegalArgumentException("Dosya boş olamaz.");
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("Dosya boyutu 10 MB'ı aşamaz.");
        }
        if (!ALLOWED_CONTENT_TYPES.contains(file.getContentType())) {
            throw new IllegalArgumentException("Yalnızca PDF veya Word belgeleri yüklenebilir.");
        }

        String originalName = file.getOriginalFilename() != null ? file.getOriginalFilename() : "dosya";
        String extension = originalName.contains(".") ? originalName.substring(originalName.lastIndexOf('.')) : "";
        String storedName = UUID.randomUUID() + extension;

        try {
            Path target = uploadDir.resolve(storedName);
            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new IllegalStateException("Dosya kaydedilemedi.", e);
        }

        LeaveRequestAttachment attachment = new LeaveRequestAttachment(
                request, originalName, storedName, file.getContentType());
        LeaveRequestAttachment saved = attachmentRepository.save(attachment);

        return toDTO(saved);
    }

    public List<LeaveRequestAttachmentDTO> getAttachments(Long leaveRequestId) {
        return attachmentRepository.findByLeaveRequest_Id(leaveRequestId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public Resource loadAsResource(Long attachmentId) {
        LeaveRequestAttachment attachment = attachmentRepository.findById(attachmentId)
                .orElseThrow(() -> new IllegalArgumentException(attachmentId + " ID'li dosya bulunamadı."));
        try {
            Path filePath = uploadDir.resolve(attachment.getStoredFileName()).normalize();
            Resource resource = new UrlResource(filePath.toUri());
            if (!resource.exists() || !resource.isReadable()) {
                throw new IllegalStateException("Dosya diskte bulunamadı.");
            }
            return resource;
        } catch (MalformedURLException e) {
            throw new IllegalStateException("Dosya yolu geçersiz.", e);
        }
    }

    public LeaveRequestAttachment getAttachmentEntity(Long attachmentId) {
        return attachmentRepository.findById(attachmentId)
                .orElseThrow(() -> new IllegalArgumentException(attachmentId + " ID'li dosya bulunamadı."));
    }

    @Transactional
    public void delete(Long attachmentId) {
        LeaveRequestAttachment attachment = getAttachmentEntity(attachmentId);
        try {
            Files.deleteIfExists(uploadDir.resolve(attachment.getStoredFileName()));
        } catch (IOException e) {
            throw new IllegalStateException("Dosya silinemedi.", e);
        }
        attachmentRepository.deleteById(attachmentId);
    }

    private LeaveRequestAttachmentDTO toDTO(LeaveRequestAttachment a) {
        return new LeaveRequestAttachmentDTO(a.getId(), a.getOriginalFileName(), a.getContentType(), a.getUploadedAt());
    }
}