package com.kutalmis.izin_talep_sistemi.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.kutalmis.izin_talep_sistemi.entity.LeaveType;
import java.util.List;

public interface LeaveTypeRepository extends JpaRepository<LeaveType, Long> {
    boolean existsByName(String name);
    List<LeaveType> findAllByActiveTrue();
}