package com.kutalmis.izin_talep_sistemi.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.kutalmis.izin_talep_sistemi.dto.AdminDepartmentDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentDTO;
import com.kutalmis.izin_talep_sistemi.entity.Department;
import com.kutalmis.izin_talep_sistemi.exception.DuplicateResourceException;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentRepository;

import jakarta.transaction.Transactional;

@Service
public class DepartmentService {
    private final DepartmentRepository departmentRepository;

    public DepartmentService(DepartmentRepository departmentRepository) {
        this.departmentRepository = departmentRepository;
    }

    public List<DepartmentDTO> getAllDepartments() {
        return departmentRepository.findAll().stream()
            .map(dept -> new DepartmentDTO(dept.getId(), dept.getName()))
            .collect(Collectors.toList());
    }

    public List<AdminDepartmentDTO> getAllDepartmentsForAdmin() {
        return departmentRepository.findAll().stream()
            .map(dept -> new AdminDepartmentDTO(dept.getId(), dept.getName()))
            .collect(Collectors.toList());
    }

    @Transactional
    public Department createDepartment(Department department) {
        if (department.getName() == null || department.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Departman ismi boş olamaz.");
        }

        if (departmentRepository.existsByName(department.getName())){
            throw new DuplicateResourceException(department.getName() + " isimli bir departman zaten var.");
        }
        return departmentRepository.save(department);
    }
    @Transactional
    public DepartmentDTO updateDepartmentName(Long id, String newDepartmentName){
        if (newDepartmentName == null || newDepartmentName.trim().isEmpty()) {
            throw new IllegalArgumentException("Departman ismi boş olamaz.");
        }

        if (departmentRepository.existsByName(newDepartmentName)){
            throw new DuplicateResourceException(newDepartmentName + " isimli bir departman zaten var.");
        }

        Department department = departmentRepository.findById(id)
         .orElseThrow(() -> new IllegalArgumentException(newDepartmentName + " ID'li departman bulunamadı."));

        department.setName(newDepartmentName);

        Department saved = departmentRepository.save(department);

        return new DepartmentDTO(saved.getId(), newDepartmentName);
    }
}