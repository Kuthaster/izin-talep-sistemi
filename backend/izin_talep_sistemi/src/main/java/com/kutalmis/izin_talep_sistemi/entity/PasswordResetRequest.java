package com.kutalmis.izin_talep_sistemi.entity;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "password_reset_requests")
public class PasswordResetRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, updatable = false)
    private LocalDateTime requestedAt = LocalDateTime.now();

    @Column(nullable = false)
    private Boolean fulfilled = false;

    public Long getId() {
        return id;
    }

    public PasswordResetRequest(User user) {
        this.user = user;
    }

    public Boolean getFulfilled() {
        return fulfilled;
    }

    public LocalDateTime getRequestedAt() {
        return requestedAt;
    }

    public User getUser() {
        return user;
    }

    public void setFulfilled(Boolean fulfilled) {
        this.fulfilled = fulfilled;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setRequestedAt(LocalDateTime requestedAt) {
        this.requestedAt = requestedAt;
    }

    public void setUser(User user) {
        this.user = user;
    }
}