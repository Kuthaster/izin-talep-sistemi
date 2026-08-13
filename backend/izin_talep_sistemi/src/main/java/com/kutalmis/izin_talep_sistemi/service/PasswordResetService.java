package com.kutalmis.izin_talep_sistemi.service;

import com.kutalmis.izin_talep_sistemi.dto.PasswordResetRequestDTO;
import com.kutalmis.izin_talep_sistemi.dto.TempPasswordDTO;
import com.kutalmis.izin_talep_sistemi.entity.PasswordResetRequest;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.kutalmis.izin_talep_sistemi.repository.PasswordResetRequestRepository;

import java.security.SecureRandom;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PasswordResetService {

    private final PasswordResetRequestRepository passwordResetRequestRepository;
    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
    private static final int TEMP_PASSWORD_LENGTH = 10;
    private final SecureRandom random = new SecureRandom();

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public PasswordResetService(PasswordResetRequestRepository passwordResetRequestRepository,
            UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.passwordResetRequestRepository = passwordResetRequestRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void createRequest(String email) {
        // Deliberately silent on unknown email — don't leak account existence.
        userRepository.findByEmail(email).ifPresent(user -> {
            List<PasswordResetRequest> existingOpen = passwordResetRequestRepository
                    .findByUser_IdAndFulfilledFalse(user.getId());
            if (existingOpen.isEmpty()) {
                passwordResetRequestRepository.save(new PasswordResetRequest(user));
            }
        });
    }

    public List<PasswordResetRequestDTO> getOpenRequests() {
        return passwordResetRequestRepository.findByFulfilledFalse().stream()
                .map(r -> new PasswordResetRequestDTO(
                        r.getId(),
                        r.getUser().getId(),
                        r.getUser().getFirstName() + " " + r.getUser().getLastName(),
                        r.getUser().getEmail(),
                        r.getRequestedAt()))
                .collect(Collectors.toList());
    }

    @Transactional
    public TempPasswordDTO issueTempPassword(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException(userId + " ID'li kullanıcı bulunamadı."));

        String tempPassword = generateTempPassword();
        user.setPasswordHash(passwordEncoder.encode(tempPassword));
        user.setMustChangePassword(true);
        userRepository.save(user);

        passwordResetRequestRepository.findByUser_IdAndFulfilledFalse(userId)
                .forEach(r -> {
                    r.setFulfilled(true);
                    passwordResetRequestRepository.save(r);
                });

        return new TempPasswordDTO(tempPassword);
    }

    private String generateTempPassword() {
        StringBuilder sb = new StringBuilder(TEMP_PASSWORD_LENGTH);
        for (int i = 0; i < TEMP_PASSWORD_LENGTH; i++) {
            sb.append(CHARS.charAt(random.nextInt(CHARS.length())));
        }
        return sb.toString();
    }
}