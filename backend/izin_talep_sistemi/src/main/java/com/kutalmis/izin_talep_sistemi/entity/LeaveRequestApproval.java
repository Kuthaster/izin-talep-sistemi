package com.kutalmis.izin_talep_sistemi.entity;

import java.time.LocalDateTime;
import jakarta.persistence.*;

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

    @Column(nullable = false)
    private String decision;

    @Column(length = 500)
    private String note;

    @Column(name = "decided_at", nullable = false, updatable = false)
    private LocalDateTime decidedAt = LocalDateTime.now();

    public LeaveRequestApproval() {
    }

    public LeaveRequestApproval(LeaveRequest leaveRequest, Integer level, User approver, String decision, String note) {
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
    public String getDecision(){ 
    return decision; 
    }
    public String getNote(){
        return note;
     }
    public LocalDateTime getDecidedAt(){
    return decidedAt;
     }
}