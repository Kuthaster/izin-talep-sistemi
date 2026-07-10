package com.kutalmis.izin_talep_sistemi.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kutalmis.izin_talep_sistemi.entity.Role;

import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;
import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Long>{
    boolean existsByName(RoleAuthority name);
    boolean existsByDisplayName(String displayName);
    Optional<Role> findByName(RoleAuthority name);
    Optional<Role> findByDisplayName(String displayName);
    
}
