package com.kutalmis.izin_talep_sistemi.service;


import com.kutalmis.izin_talep_sistemi.dto.RoleActivityUpdateDTO;
import com.kutalmis.izin_talep_sistemi.dto.RoleCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.RoleDTO;
import com.kutalmis.izin_talep_sistemi.entity.Role;
import com.kutalmis.izin_talep_sistemi.exception.DuplicateResourceException;
import com.kutalmis.izin_talep_sistemi.repository.RoleRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;
import java.util.stream.Collectors;

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
    public RoleCreateDTO createRole(RoleCreateDTO dto) {
        roleRepository.findByDisplayName(dto.displayName()).ifPresent(existing -> {
        if (Boolean.TRUE.equals(existing.getActive())) {
            throw new DuplicateResourceException("Bu isimli aktif bir rol zaten var.");
        }
        throw new DuplicateResourceException(
            "Bu isimli pasif bir rol zaten var. Yeni oluşturmak yerine mevcut rolü tekrar aktifleştirebilirsiniz (ID: " + existing.getId() + ").");
        });

        Role role = new Role(dto.name(), dto.displayName());
        role.setActive(true);   //Zaten initializer de de var, belli olsun diye
        Role saved = roleRepository.save(role);

        return new RoleCreateDTO(saved.getDisplayName(), saved.getName());
    }
    
     @Transactional
    public RoleDTO updateActivity(Long roleId, RoleActivityUpdateDTO dto) {
        Role role = roleRepository.findById(roleId)
            .orElseThrow(() -> new IllegalArgumentException(roleId + " ID'li rol bulunamadı."));

        role.setActive(dto.active());
        return toDTO(roleRepository.save(role));
    }

    @Transactional
    public RoleDTO updateDisplayName(Long roleId, String newDisplayName) {
        if (newDisplayName == null || newDisplayName.trim().isEmpty()) {
            throw new IllegalArgumentException("Rol adı boş olamaz.");
        }

        Role role = roleRepository.findById(roleId)
            .orElseThrow(() -> new IllegalArgumentException(roleId + " ID'li rol bulunamadı."));

        role.setDisplayName(newDisplayName);
        return toDTO(roleRepository.save(role));
    }

    private RoleDTO toDTO(Role role) {
        return new RoleDTO(role.getId(), role.getName(), role.getDisplayName(), role.getActive());
    }
}