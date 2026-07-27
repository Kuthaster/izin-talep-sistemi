package com.kutalmis.izin_talep_sistemi.service;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kutalmis.izin_talep_sistemi.dto.ChangePasswordDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserResponseDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.Department;
import com.kutalmis.izin_talep_sistemi.entity.DepartmentApprover;
import com.kutalmis.izin_talep_sistemi.entity.Role;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.exception.DuplicateResourceException;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentApproverRepository;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentRepository;
import com.kutalmis.izin_talep_sistemi.repository.RoleRepository;
import com.kutalmis.izin_talep_sistemi.repository.UserRepository;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final DepartmentRepository departmentRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final DepartmentApproverRepository departmentApproverRepository;

    public UserService(UserRepository userRepository, DepartmentRepository departmentRepository,
            RoleRepository roleRepository, PasswordEncoder passwordEncoder,
            DepartmentApproverRepository departmentApproverRepository) {
        this.userRepository = userRepository;
        this.departmentRepository = departmentRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
        this.departmentApproverRepository = departmentApproverRepository;
    }

    public List<UserResponseDTO> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(this::mapperResponseDTO)
                .toList();
    }

    public UserResponseDTO getUserProfileByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException(email + " E-postasına sahip kullanıcı bulunamadı"));

        return mapperResponseDTO(user);
    }

    public User getUserEntityByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException(email + " E-postasına sahip kullanıcı bulunamadı"));
    }

    @Transactional
    public UserResponseDTO createUser(UserCreateDTO dto) {

        Department department = departmentRepository.findById(dto.departmentId())
                .orElseThrow(() -> new IllegalArgumentException(dto.departmentId() + " ID'li departman bulunamadı."));

        Role role = roleRepository.findById(dto.roleId())
                .orElseThrow(() -> new IllegalArgumentException(dto.roleId() + " ID'li rol bulunamadı"));

        if (dto.firstName() == null || dto.firstName().isBlank()
                || dto.lastName() == null || dto.lastName().isBlank()) {
            throw new IllegalArgumentException("Kullanıcı adı veya soyadı boş olamaz.");
        }

        User user = new User();
        user.setFirstName(dto.firstName());
        user.setLastName(dto.lastName());
        user.setEmail(dto.email());
        user.setPasswordHash(passwordEncoder.encode(dto.rawPassword()));
        user.setDepartment(department);
        user.setRole(role);
        user.setActive(true);

        User savedUser = userRepository.save(user);

        if (dto.assignAsApproverLevel() != null) {
            DepartmentApprover existing = departmentApproverRepository
                    .findByDepartment_IdAndLevel(department.getId(), dto.assignAsApproverLevel())
                    .orElse(null);

            if (existing != null) {
                throw new DuplicateResourceException(
                        department.getName() + " departmanının " + dto.assignAsApproverLevel()
                                + ". seviyesi zaten atanmış.");
            }

            departmentApproverRepository.save(
                    new DepartmentApprover(department, dto.assignAsApproverLevel(), savedUser));
        }
        return mapperResponseDTO(savedUser);
    }

    private UserResponseDTO mapperResponseDTO(User user) {
        return new UserResponseDTO(
                user.getId(),
                user.getFirstName(),
                user.getLastName(),
                user.getEmail(),
                user.getDepartment().getName(),
                user.getRole().getDisplayName(),
                user.getRole().getName(),
                user.getActive());
    }

    @Transactional
    public UserResponseDTO updateUser(Long userId, UserUpdateDTO dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException(userId + " ID'li kullanıcı bulunamadı."));

        Department department = departmentRepository.findById(dto.departmentId())
                .orElseThrow(() -> new IllegalArgumentException(dto.departmentId() + " Id'li departman bulunamadı."));

        Role role = roleRepository.findById(dto.roleId())
                .orElseThrow(() -> new IllegalArgumentException(dto.roleId() + "ID'li rol bulunamadı"));

        if (dto.firstName() != null && !(dto.firstName().isBlank())) {
            user.setFirstName(dto.firstName());
        }
        if (dto.lastName() != null && !(dto.lastName().isBlank())) {
            user.setLastName(dto.lastName());
        }
        if (dto.email() != null && !(dto.email().isBlank())) {
            user.setEmail(dto.email());
        }
        user.setRole(role);
        user.setDepartment(department);
        if (dto.active() != null) {
            user.setActive(dto.active());
        }
        User saved = userRepository.save(user);
        return mapperResponseDTO(saved);
    }

    @Transactional
    public void changePassword(User caller, ChangePasswordDTO dto) {

        if (!passwordEncoder.matches(dto.currentPassword(), caller.getPasswordHash())) {
            throw new IllegalArgumentException("Mevcut şifre yanlış.");
        }

        if (dto.newPassword() == null || dto.newPassword().isBlank()) {
            throw new IllegalArgumentException("Yeni şifre boş olamaz.");
        }

        caller.setPasswordHash(passwordEncoder.encode(dto.newPassword()));
        userRepository.save(caller);
    }
}
