package com.kutalmis.izin_talep_sistemi.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kutalmis.izin_talep_sistemi.entity.Department;


public interface DepartmentRepository extends JpaRepository<Department, Long> {
    boolean existsByName(String name);
    boolean existsById(Long id);
    Optional<Department> findByName(String name);
}