package com.kutalmis.izin_talep_sistemi.service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kutalmis.izin_talep_sistemi.dto.ChangePasswordDTO;
import com.kutalmis.izin_talep_sistemi.dto.DepartmentlessUserDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserCreateDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserResponseDTO;
import com.kutalmis.izin_talep_sistemi.dto.UserUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.Department;
import com.kutalmis.izin_talep_sistemi.entity.Role;
import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.exception.DuplicateResourceException;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentRepository;
import com.kutalmis.izin_talep_sistemi.repository.RoleRepository;
import com.kutalmis.izin_talep_sistemi.repository.UserRepository;

@Service
public class UserService {
    private static final Set<RoleAuthority> MANAGER_LEVELS = Set.of(
            RoleAuthority.MANAGER_LEVEL_1, RoleAuthority.MANAGER_LEVEL_2, RoleAuthority.MANAGER_LEVEL_3);

    private final UserRepository userRepository;
    private final DepartmentRepository departmentRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, DepartmentRepository departmentRepository,
            RoleRepository roleRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.departmentRepository = departmentRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public List<UserResponseDTO> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(this::mapperResponseDTO)
                .toList();
    }

    public UserResponseDTO getUserProfileByEmail(String email) {
        User user = getUserEntityByEmail(email);
        return mapperResponseDTO(user);
    }

    public User getUserEntityByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException(email + " E-postasına sahip kullanıcı bulunamadı"));
    }

    private void assertManagerSlotAvailable(Department department, Role role, Long excludingUserId) {
        if (!MANAGER_LEVELS.contains(role.getName())) {
            return;
        }
        userRepository.findByRole_NameAndDepartment_Id(role.getName(), department.getId())
                .filter(existing -> excludingUserId == null || !existing.getId().equals(excludingUserId))
                .ifPresent(existing -> {
                    throw new DuplicateResourceException(
                            department.getName() + " departmanının " + role.getDisplayName()
                                    + " seviyesi zaten " + existing.getFirstName() + " " + existing.getLastName()
                                    + " tarafından dolduruluyor.");
                });
    }

    @Transactional
    public UserResponseDTO createUser(UserCreateDTO dto) {

        Department department = departmentByIdCheck(dto.departmentId());
        Role role = roleByIdCheck(dto.roleId());

        nameFieldValidation(dto.firstName(), dto.lastName());

        assertManagerSlotAvailable(department, role, null);

        User user = new User();
        user.setFirstName(dto.firstName());
        user.setLastName(dto.lastName());
        user.setEmail(dto.email());
        user.setPasswordHash(passwordEncoder.encode(dto.rawPassword()));
        user.setDepartment(department);
        user.setRole(role);
        user.setActive(true);
        user.setGender(dto.gender());

        User savedUser = userRepository.save(user);
        return mapperResponseDTO(savedUser);
    }

    private UserResponseDTO mapperResponseDTO(User user) {
        return new UserResponseDTO(
                user.getId(),
                user.getFirstName(),
                user.getLastName(),
                user.getEmail(),
                user.getDepartment() != null ? user.getDepartment().getName() : null,
                user.getRole().getDisplayName(),
                user.getRole().getName(),
                user.getActive(),
                user.getGender(),
                user.getMustChangePassword());
    }

    @Transactional
    public UserResponseDTO updateUser(Long userId, UserUpdateDTO dto) {
        User user = userByIdCheck(userId);

        Department department = user.getDepartment();
        departmentByIdCheck(dto.departmentId());

        Role role = user.getRole();
        roleByIdCheck(dto.roleId());

        if (dto.firstName() != null && !(dto.firstName().isBlank())) {
            user.setFirstName(dto.firstName());
        }
        if (dto.lastName() != null && !(dto.lastName().isBlank())) {
            user.setLastName(dto.lastName());
        }
        if (dto.email() != null && !(dto.email().isBlank())) {
            user.setEmail(dto.email());
        }

        if (department != null && role != null) {
            assertManagerSlotAvailable(department, role, user.getId());
        }

        user.setRole(role);
        user.setDepartment(department);

        if (dto.active() != null) {
            user.setActive(dto.active());
        }

        if (dto.gender() != null) {
            user.setGender(dto.gender());
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

        if (passwordEncoder.matches(dto.newPassword(), caller.getPasswordHash())) {
            throw new IllegalArgumentException("Yeni şifre mevcut şifreyle aynı olamaz.");
        }

        caller.setPasswordHash(passwordEncoder.encode(dto.newPassword()));
        caller.setMustChangePassword(false);

        userRepository.save(caller);
    }

    public void deleteUser(Long id) {
        User user = userByIdCheck(id);

        userRepository.deleteById(user.getId());
    }

    private User userByIdCheck(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException(
                        userId + " ID'li kullanıcı bulunamadı."));
    }

    private Department departmentByIdCheck(Long departmentId) {
        return departmentRepository.findById(departmentId)
                .orElseThrow(() -> new IllegalArgumentException(
                        departmentId + " Id'li departman bulunamadı."));
    }

    private Role roleByIdCheck(Long roleId) {
        return roleRepository.findById(roleId)
                .orElseThrow(() -> new IllegalArgumentException(
                        roleId + " ID'li rol bulunamadı"));
    }

    private void nameFieldValidation(String firstName, String lastName) {
        if (firstName == null || firstName.isBlank()
                || lastName == null || lastName.isBlank()) {
            throw new IllegalArgumentException("Kullanıcı adı veya soyadı boş olamaz.");
        }
    }

    public List<DepartmentlessUserDTO> findDepartmentlessUsers() {
        return userRepository.findByDepartmentIsNull().stream()
                .map(u -> new DepartmentlessUserDTO(u.getId(), u.getFirstName() + " " + u.getLastName(), u.getEmail()))
                .collect(Collectors.toList());
    }
}