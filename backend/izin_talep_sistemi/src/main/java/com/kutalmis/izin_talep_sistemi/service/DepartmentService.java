package com.kutalmis.izin_talep_sistemi.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.kutalmis.izin_talep_sistemi.dto.DepartmentDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentUpdateDTO;
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

    public List<DepartmentDTO> getAllDepartmentsForAdmin() {
        return departmentRepository.findAll().stream()
                .map(dept -> new DepartmentDTO(dept.getId(), dept.getName()))
                .collect(Collectors.toList());
    }

    @Transactional
    public DepartmentDTO createDepartment(DepartmentUpdateDTO dto) {
        if (dto.departmentName() == null || dto.departmentName().trim().isEmpty()) {
            throw new IllegalArgumentException("Departman ismi boş olamaz.");
        }

        if (departmentRepository.existsByName(dto.departmentName())) {
            throw new DuplicateResourceException(dto.departmentName() + " isimli bir departman zaten var.");
        }

        Department department = new Department();
        department.setName(dto.departmentName());

        Department savedDepartment = departmentRepository.save(department);

        return new DepartmentDTO(
                savedDepartment.getId(),
                savedDepartment.getName());

    }

    @Transactional
    public DepartmentDTO updateDepartment(Long id, DepartmentUpdateDTO dto) {
        String newDepartmentName = dto.departmentName();
        if (newDepartmentName == null || newDepartmentName.trim().isEmpty()) {
            throw new IllegalArgumentException("Departman ismi boş olamaz.");
        }

        if (departmentRepository.existsByName(newDepartmentName)) {
            throw new DuplicateResourceException(newDepartmentName + " isimli bir departman zaten var.");
        }

        Department department = departmentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(id + " ID'li departman bulunamadı."));

        department.setName(newDepartmentName);

        Department saved = departmentRepository.save(department);

        return new DepartmentDTO(saved.getId(), newDepartmentName);
    }

    public void deleteDepartment(Long departmentId) {
        Department department = departmentRepository.findById(departmentId)
                .orElseThrow(() -> new IllegalArgumentException(departmentId + " ID' li departman bulunamadı."));

        departmentRepository.deleteById(department.getId());
    }
}