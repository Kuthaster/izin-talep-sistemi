package com.kutalmis.izin_talep_sistemi.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.kutalmis.izin_talep_sistemi.entity.DepartmentApprover;
import java.util.Optional;
import java.util.List;

public interface DepartmentApproverRepository extends JpaRepository<DepartmentApprover, Long> {
    Optional<DepartmentApprover> findByDepartment_IdAndLevel(Long departmentId, Integer level);
    List<DepartmentApprover> findByDepartment_Id(Long departmentId);        
    List<DepartmentApprover> findByApprover_Id(Long approverId);
    void deleteByDepartment_IdAndLevel(Long departmentId, Integer level);
}