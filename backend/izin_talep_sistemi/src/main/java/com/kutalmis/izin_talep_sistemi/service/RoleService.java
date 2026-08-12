package com.kutalmis.izin_talep_sistemi.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kutalmis.izin_talep_sistemi.dto.RoleDTO;
import com.kutalmis.izin_talep_sistemi.dto.RoleUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.Role;
import com.kutalmis.izin_talep_sistemi.repository.RoleRepository;

@Service
public class RoleService {
    private final RoleRepository roleRepository;

    public RoleService(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    public List<RoleDTO> getAllRoles() {
        return roleRepository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public RoleDTO updateRole(Long roleId, RoleUpdateDTO dto) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new IllegalArgumentException(roleId + " ID'li rol bulunamadı."));

        if (dto.displayName() != null && dto.displayName().isBlank()) {
            role.setDisplayName(dto.displayName());
        }
        return toDTO(roleRepository.save(role));
    }

    private RoleDTO toDTO(Role role) {
        return new RoleDTO(role.getId(), role.getName(), role.getDisplayName());
    }
}