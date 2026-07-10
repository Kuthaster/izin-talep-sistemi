package com.kutalmis.izin_talep_sistemi.service;

import com.kutalmis.izin_talep_sistemi.dto.DepartmentApproverAssignDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentApproverDTO;
import com.kutalmis.izin_talep_sistemi.entity.Department;
import com.kutalmis.izin_talep_sistemi.entity.DepartmentApprover;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentApproverRepository;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentRepository;
import com.kutalmis.izin_talep_sistemi.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class DepartmentApproverService {
    private final DepartmentApproverRepository departmentApproverRepository;
    private final DepartmentRepository departmentRepository;
    private final UserRepository userRepository;

    public DepartmentApproverService(DepartmentApproverRepository departmentApproverRepository,
                                      DepartmentRepository departmentRepository,
                                      UserRepository userRepository) {
        this.departmentApproverRepository = departmentApproverRepository;
        this.departmentRepository = departmentRepository;
        this.userRepository = userRepository;
    }

    public List<DepartmentApproverDTO> getApproversForDepartment(Long departmentId) {
        return departmentApproverRepository.findByDepartment_Id(departmentId).stream()
            .map(this::toDTO)
            .collect(Collectors.toList());
    }

    @Transactional
    public DepartmentApproverDTO assignApprover(DepartmentApproverAssignDTO dto) {
        Department department = departmentRepository.findById(dto.departmentId())
            .orElseThrow(() -> new IllegalArgumentException(dto.departmentId() + " ID'li departman bulunamadı."));

        User approver = userRepository.findById(dto.approverId())
            .orElseThrow(() -> new IllegalArgumentException(dto.approverId() + " ID'li kullanıcı bulunamadı."));

        DepartmentApprover existing = departmentApproverRepository
            .findByDepartment_IdAndLevel(dto.departmentId(), dto.level())
            .orElse(null);

        if (existing != null) {
            existing.setApprover(approver);
            return toDTO(departmentApproverRepository.save(existing));
        }

        DepartmentApprover created = new DepartmentApprover(department, dto.level(), approver);
        return toDTO(departmentApproverRepository.save(created));
    }

    @Transactional
    public void removeApprover(Long departmentId, Integer level) {
    if (departmentApproverRepository.findByDepartment_IdAndLevel(departmentId, level).isEmpty()) {
        throw new IllegalArgumentException("Bu departman/seviye için atanmış bir onaylayıcı bulunamadı.");
    }
    departmentApproverRepository.deleteByDepartment_IdAndLevel(departmentId, level);
}

    private DepartmentApproverDTO toDTO(DepartmentApprover da) {
        return new DepartmentApproverDTO(
            da.getId(),
            da.getDepartment().getId(),
            da.getDepartment().getName(),
            da.getLevel(),
            da.getApprover().getId(),
            da.getApprover().getFirstName() + " " + da.getApprover().getLastName()
        );
    }
}