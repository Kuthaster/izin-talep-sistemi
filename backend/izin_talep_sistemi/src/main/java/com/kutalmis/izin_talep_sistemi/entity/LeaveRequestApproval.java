package com.kutalmis.izin_talep_sistemi.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "leave_request_approvals")
public class LeaveRequestApproval {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "leave_request_id", nullable = false)
    private LeaveRequest leaveRequest;

    @Column(nullable = false)
    private Integer level;

    @ManyToOne
    @JoinColumn(name = "approver_id", nullable = false)
    private User approver;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LeaveDecision decision;

    @Column(length = 500)
    private String note;

    @Column(name = "decided_at", nullable = false, updatable = false)
    private LocalDateTime decidedAt = LocalDateTime.now();

    public LeaveRequestApproval() {
    }

    public LeaveRequestApproval(LeaveRequest leaveRequest, Integer level, User approver, LeaveDecision decision, String note) {
        this.leaveRequest = leaveRequest;
        this.level = level;
        this.approver = approver;
        this.decision = decision;
        this.note = note;
    }

    public Long getId() { 
    return id; 
    }
    public LeaveRequest getLeaveRequest(){ return leaveRequest; }
    public Integer getLevel(){ 
    return level;
    }
    public User getApprover(){ 
    return approver;
    }
    public LeaveDecision getDecision(){ 
    return decision; 
    }
    public String getNote(){
        return note;
     }
    public LocalDateTime getDecidedAt(){
    return decidedAt;
     }
}