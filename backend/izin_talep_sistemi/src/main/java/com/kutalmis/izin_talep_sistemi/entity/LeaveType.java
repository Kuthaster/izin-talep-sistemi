package com.kutalmis.izin_talep_sistemi.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "leave_types")
public class LeaveType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(name = "default_days", nullable = false)
    private Integer defaultDays;

    @Column(nullable = false)
    private Boolean active = true;
    
    @Column(name = "required_levels", nullable = false)
    private Integer requiredLevels = 1;

    public Integer getRequiredLevels() {
        return requiredLevels;
    }

    public void setRequiredLevels(Integer requiredLevels) {
        this.requiredLevels = requiredLevels;
    }
    public LeaveType() {
    }
    

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getDefaultDays() {
        return defaultDays;
    }

    public void setDefaultDays(Integer defaultDays) {
        this.defaultDays = defaultDays;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }
}