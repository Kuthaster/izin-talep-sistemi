package com.kutalmis.izin_talep_sistemi.entity;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "leave_balance_audits")
public class LeaveBalanceAudit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "leave_balance_id", nullable = false)
    private LeaveBalance leaveBalance;

    @ManyToOne
    @JoinColumn(name = "admin_id", nullable = false)
    private User admin;

    @Column(nullable = false)
    private Integer oldTotalDays;

    @Column(nullable = false)
    private Integer newTotalDays;

    @Column(nullable = false, length = 500)
    private String reason;

    @Column(nullable = false, updatable = false)
    private LocalDateTime changedAt = LocalDateTime.now();

    public LeaveBalanceAudit() {
    }

    public LeaveBalanceAudit(LeaveBalance leaveBalance, User admin, Integer oldTotalDays, Integer newTotalDays,
            String reason) {
        this.leaveBalance = leaveBalance;
        this.admin = admin;
        this.oldTotalDays = oldTotalDays;
        this.newTotalDays = newTotalDays;
        this.reason = reason;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LeaveBalance getLeaveBalance() {
        return leaveBalance;
    }

    public void setLeaveBalance(LeaveBalance leaveBalance) {
        this.leaveBalance = leaveBalance;
    }

    public User getAdmin() {
        return admin;
    }

    public void setAdmin(User admin) {
        this.admin = admin;
    }

    public Integer getOldTotalDays() {
        return oldTotalDays;
    }

    public void setOldTotalDays(Integer oldTotalDays) {
        this.oldTotalDays = oldTotalDays;
    }

    public Integer getNewTotalDays() {
        return newTotalDays;
    }

    public void setNewTotalDays(Integer newTotalDays) {
        this.newTotalDays = newTotalDays;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public LocalDate getChangedAt() {
        return getChangedAt();
    }
}