package com.kutalmis.izin_talep_sistemi.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "department_approvers", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"department_id", "level"})
})
public class DepartmentApprover {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @Column(nullable = false)
    private Integer level;

    @ManyToOne
    @JoinColumn(name = "approver_id", nullable = false)
    private User approver;

    public DepartmentApprover() {
    }

    public DepartmentApprover(Department department, Integer level, User approver) {
        this.department = department;
        this.level = level;
        this.approver = approver;
    }

    public Long getId() {
        return id;
    }

    public Department getDepartment() {
        return department;
    }

    public Integer getLevel() {
        return level;
    }

    public User getApprover() {
        return approver;
    }

    public void setApprover(User approver) {
        this.approver = approver;
    }
}