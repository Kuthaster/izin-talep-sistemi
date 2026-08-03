package com.kutalmis.izin_talep_sistemi.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "leave_balances", uniqueConstraints = @UniqueConstraint(columnNames = { "user_id", "leave_type_id",
        "year" }))
public class LeaveBalance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "leave_type_id", nullable = false)
    private LeaveType leaveType;

    @Column(nullable = false)
    private Integer year;

    @Column(nullable = false)
    private Integer totalDays;

    @Column(nullable = false)
    private Integer usedDays = 0;

@Column(nullable = false)
    private Integer reservedDays = 0;

    @Transient
    public int getAvailableDays() {
        return totalDays - usedDays - reservedDays;
    }
}