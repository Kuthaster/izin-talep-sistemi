package com.kutalmis.izin_talep_sistemi.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.kutalmis.izin_talep_sistemi.dto.ApproverGapDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.Department;
import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;
import com.kutalmis.izin_talep_sistemi.exception.DuplicateResourceException;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentRepository;
import com.kutalmis.izin_talep_sistemi.repository.UserRepository;
import static com.kutalmis.izin_talep_sistemi.utilities.ApprovalLevels.roleForLevel;

import jakarta.transaction.Transactional;

@Service
public class DepartmentService {
    private final DepartmentRepository departmentRepository;
    private final UserRepository userRepository;

    public DepartmentService(DepartmentRepository departmentRepository, UserRepository userRepository) {
        this.departmentRepository = departmentRepository;
        this.userRepository = userRepository;
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
        departmentNameEmptyNullCheck(dto.departmentName());

        departmentDuplicateCheck(dto.departmentName());

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

        departmentNameEmptyNullCheck(newDepartmentName);

        departmentDuplicateCheck(newDepartmentName);

        Department department = getDepartment(id);

        department.setName(newDepartmentName);

        Department saved = departmentRepository.save(department);

        return new DepartmentDTO(saved.getId(), newDepartmentName);
    }

    public void deleteDepartment(Long id) {
        Department department = getDepartment(id);
        if (userRepository.existsByDepartment_Id(id)) {
            throw new IllegalStateException("Departmanı silmeden önce içinde kullanıcı olmadığından emin olun.");
        }

        departmentRepository.deleteById(department.getId());
    }

    public List<ApproverGapDTO> findApproverGaps() {
        List<Department> departments = departmentRepository.findAll();
        List<ApproverGapDTO> gaps = new ArrayList<>();

        for (Department dept : departments) {
            List<Integer> missing = new ArrayList<>();
            for (int level = 1; level <= 3; level++) {
                RoleAuthority role = roleForLevel(level);
                if (!userRepository.existsByRole_NameAndDepartment_Id(role, dept.getId())) {
                    missing.add(level);
                }
            }
            if (!missing.isEmpty()) {
                gaps.add(new ApproverGapDTO(dept.getId(), dept.getName(), missing));
            }
        }
        return gaps;
    }

    private void departmentNameEmptyNullCheck(String departmentName) {
        if (departmentName == null || departmentName.trim().isEmpty()) {
            throw new IllegalArgumentException("Departman ismi boş olamaz.");
        }
    }

    private void departmentDuplicateCheck(String departmentName) {
        if (departmentRepository.existsByName(departmentName)) {
            throw new DuplicateResourceException(departmentName + " isimli bir departman zaten var.");
        }
    }

    private Department getDepartment(Long departmentId) {
        Department department = departmentRepository.findById(departmentId)
                .orElseThrow(() -> new IllegalArgumentException(departmentId + " ID'li departman bulunamadı."));
        return department;
    }
}