package com.kutalmis.izin_talep_sistemi.config;

import com.kutalmis.izin_talep_sistemi.entity.Department;
import com.kutalmis.izin_talep_sistemi.entity.Gender;
import com.kutalmis.izin_talep_sistemi.entity.Role;
import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.repository.DepartmentRepository;
import com.kutalmis.izin_talep_sistemi.repository.RoleRepository;
import com.kutalmis.izin_talep_sistemi.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@Order(2)
public class UserSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(UserSeeder.class);
    private static final String BOOTSTRAP_DEPARTMENT_NAME = "Yönetim";

    private final UserRepository userRepository;
    private final DepartmentRepository departmentRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${app.bootstrap-admin.email:admin@company.local}")
    private String bootstrapAdminEmail;

    @Value("${app.bootstrap-admin.password:ChangeMe123!}")
    private String bootstrapAdminPassword;

    public UserSeeder(UserRepository userRepository,
            DepartmentRepository departmentRepository,
            RoleRepository roleRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.departmentRepository = departmentRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        if (userRepository.existsByRole_Name(RoleAuthority.ADMIN)) {
            return;
        }

        Role adminRole = roleRepository.findByName(RoleAuthority.ADMIN)
                .orElseThrow(() -> new IllegalStateException(
                        "ADMIN rolü bulunamadı. RoleSeeder, UserSeeder'dan önce çalışmalıdır."));

        Department bootstrapDepartment = departmentRepository.findByName(BOOTSTRAP_DEPARTMENT_NAME)
                .orElseGet(() -> {
                    Department dept = new Department();
                    dept.setName(BOOTSTRAP_DEPARTMENT_NAME);
                    return departmentRepository.save(dept);
                });

        User admin = new User();
        admin.setFirstName("Sistem");
        admin.setLastName("Yöneticisi");
        admin.setEmail(bootstrapAdminEmail);
        admin.setPasswordHash(passwordEncoder.encode(bootstrapAdminPassword));
        admin.setDepartment(bootstrapDepartment);
        admin.setRole(adminRole);
        admin.setActive(Boolean.TRUE);
        admin.setGender(Gender.MALE);
        admin.setMustChangePassword(Boolean.TRUE);

        userRepository.save(admin);

        log.warn("Bootstrap ADMIN hesabı oluşturuldu (email: {}). " +
                "Bu hesabın şifresini ilk girişten sonra değiştirin.", bootstrapAdminEmail);
    }
}
