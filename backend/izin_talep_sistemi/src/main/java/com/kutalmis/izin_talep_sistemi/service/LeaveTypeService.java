package com.kutalmis.izin_talep_sistemi.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeDefaultDaysUpdateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeRequiredLevelsUpdateDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveTypeStatusUpdateDTO;
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
    public LeaveTypeDTO updateDefaultDays(Long id, LeaveTypeDefaultDaysUpdateDTO dto) {
        LeaveType leaveType = leaveTypeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(id + " ID'li izin türü bulunamadı."));

        leaveType.setDefaultDays(dto.defaultDays());
        return toDTO(leaveTypeRepository.save(leaveType));
    }
    @Transactional
    public LeaveTypeDTO updateStatus(Long id, LeaveTypeStatusUpdateDTO dto) {
        LeaveType leaveType = leaveTypeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(id + " ID'li izin türü bulunamadı."));

        leaveType.setActive(dto.active());
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

    @Transactional
    public LeaveTypeDTO updateRequiredLevels(Long id, LeaveTypeRequiredLevelsUpdateDTO dto) {
        LeaveType leaveType = leaveTypeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(id + " ID'li izin türü bulunamadı."));

        leaveType.setRequiredLevels(dto.requiredLevels());
        return toDTO(leaveTypeRepository.save(leaveType));
    }
    
}