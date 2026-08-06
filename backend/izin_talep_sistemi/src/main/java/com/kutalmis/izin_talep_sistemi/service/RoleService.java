package com.kutalmis.izin_talep_sistemi.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kutalmis.izin_talep_sistemi.dto.RoleCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.RoleDTO;
import com.kutalmis.izin_talep_sistemi.dto.RoleUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.Role;
import com.kutalmis.izin_talep_sistemi.exception.DuplicateResourceException;
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
    public RoleDTO createRole(RoleCreateDTO dto) {
        roleRepository.findByDisplayName(dto.displayName()).ifPresent(existing -> {
            if (existing.getActive()) {
                throw new DuplicateResourceException("Bu isimli aktif bir rol zaten var.");
            }
            throw new DuplicateResourceException(
                    "Bu isimli pasif bir rol zaten var. Yeni oluşturmak yerine mevcut rolü tekrar aktifleştirebilirsiniz (ID: "
                            + existing.getId() + ").");
        });

        Role role = new Role(dto.name(), dto.displayName());
        role.setActive(true); // Zaten initializer de de var, belli olsun diye
        Role saved = roleRepository.save(role);

        return toDTO(saved);
    }

    @Transactional
    public RoleDTO updateRole(Long roleId, RoleUpdateDTO dto) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new IllegalArgumentException(roleId + " ID'li rol bulunamadı."));

        if (dto.displayName() != null && dto.displayName().isBlank()) {
            role.setDisplayName(dto.displayName());
        }
        if (dto.active() != null) {
            role.setActive(dto.active());
        }
        return toDTO(roleRepository.save(role));
    }

    private RoleDTO toDTO(Role role) {
        return new RoleDTO(role.getId(), role.getName(), role.getDisplayName(), role.getActive());
    }

    public void deleteRole(Long roleId) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new IllegalArgumentException(roleId + " ID'li rol bulunamadı."));

        roleRepository.deleteById(role.getId());
    }
}