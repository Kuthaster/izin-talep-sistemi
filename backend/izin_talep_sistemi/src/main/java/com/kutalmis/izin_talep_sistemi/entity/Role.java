package com.kutalmis.izin_talep_sistemi.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "roles")
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, unique = false, length = 20)
    private RoleAuthority name;

    @Column(name = "display_name", nullable = true, unique = true)
    private String displayName;

    public Role(RoleAuthority name, String displayName) {
        this.name = name;
        this.displayName = displayName;
    }

    public Role() {

    }

    public Long getId() {
        return id;
    }

    public RoleAuthority getName() {
        return name;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
}