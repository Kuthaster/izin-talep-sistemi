package com.kutalmis.izin_talep_sistemi.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByRole_Name(RoleAuthority name);
    boolean existsByRole_NameAndDepartment_Id(RoleAuthority roleName, Long departmentId);
    Optional<User> findByRole_NameAndDepartment_Id(RoleAuthority roleName, Long departmentId);
}   