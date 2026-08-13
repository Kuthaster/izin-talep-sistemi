package com.kutalmis.izin_talep_sistemi.repository;

import com.kutalmis.izin_talep_sistemi.entity.PasswordResetRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PasswordResetRequestRepository extends JpaRepository<PasswordResetRequest, Long> {
    List<PasswordResetRequest> findByFulfilledFalse();

    List<PasswordResetRequest> findByUser_IdAndFulfilledFalse(Long userId);

}