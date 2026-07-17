package com.kutalmis.izin_talep_sistemi.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.LeaveType;
import com.kutalmis.izin_talep_sistemi.exception.DuplicateResourceException;
import com.kutalmis.izin_talep_sistemi.repository.LeaveTypeRepository;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LeaveTypeService {
    private final LeaveTypeRepository leaveTypeRepository;

    public LeaveTypeService(LeaveTypeRepository leaveTypeRepository) {
        this.leaveTypeRepository = leaveTypeRepository;
    }

    public List<LeaveTypeDTO> getActiveLeaveTypes() {
        return leaveTypeRepository.findAllByActiveTrue().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<LeaveTypeDTO> getAllLeaveTypesForAdmin() {
        return leaveTypeRepository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public LeaveTypeDTO updateLeaveType(Long id, LeaveTypeUpdateDTO dto) {
        LeaveType leaveType = leaveTypeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(id + " ID'li izin türü bulunamadı."));

        if (dto.defaultDays() != null){
            leaveType.setDefaultDays(dto.defaultDays());
        }

        if (dto.active() != null){
            leaveType.setActive(dto.active());
        }
        if (dto.requiredLevels() != null){
            leaveType.setRequiredLevels(dto.requiredLevels());
        }

        LeaveType saved = leaveTypeRepository.save(leaveType);
        return toDTO(leaveTypeRepository.save(saved));
    }

    @Transactional
    public LeaveTypeDTO createLeaveType(LeaveTypeCreateDTO dto) {
        if (leaveTypeRepository.existsByName(dto.name())) {
            throw new DuplicateResourceException(dto.name() + " adlı bir izin türü zaten var.");
        }
        
        LeaveType leaveType = new LeaveType();
        leaveType.setName(dto.name());
        leaveType.setDefaultDays(dto.defaultDays());
        leaveType.setActive(true);
        leaveType.setRequiredLevels(dto.requiredLevels() != null ? dto.requiredLevels() : 1);
        
        return toDTO(leaveTypeRepository.save(leaveType));
    }
    
    private LeaveTypeDTO toDTO(LeaveType leaveType) {
        return new LeaveTypeDTO(
                leaveType.getId(),
                leaveType.getName(),
                leaveType.getDefaultDays(),
                leaveType.getActive(),
                leaveType.getRequiredLevels() 
        );
    }
    
}