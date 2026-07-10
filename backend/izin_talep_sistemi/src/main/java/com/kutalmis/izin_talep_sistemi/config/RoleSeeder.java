package com.kutalmis.izin_talep_sistemi.config;

import com.kutalmis.izin_talep_sistemi.entity.Role;
import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;
import com.kutalmis.izin_talep_sistemi.repository.RoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(1)
public class RoleSeeder implements CommandLineRunner {

    private final RoleRepository roleRepository;

    public RoleSeeder(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    @Override
    public void run(String... args) {
        seedIfMissing(RoleAuthority.ADMIN, "Admin");
        seedIfMissing(RoleAuthority.MANAGER_LEVEL_3, "Direktör");
        seedIfMissing(RoleAuthority.MANAGER_LEVEL_2, "Departman Başı");
        seedIfMissing(RoleAuthority.MANAGER_LEVEL_1, "Süpervisör");
        seedIfMissing(RoleAuthority.EMPLOYEE, "Çalışan");
    }

    //fix this 
    private void seedIfMissing(RoleAuthority name, String displayName) {
        if (!roleRepository.existsByName(name)) {
            roleRepository.save(new Role(name, displayName));
        }
    }
}