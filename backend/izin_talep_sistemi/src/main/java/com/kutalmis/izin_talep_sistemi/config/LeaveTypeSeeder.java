package com.kutalmis.izin_talep_sistemi.config;

import com.kutalmis.izin_talep_sistemi.entity.LeaveType;
import com.kutalmis.izin_talep_sistemi.repository.LeaveTypeRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(3)
public class LeaveTypeSeeder implements CommandLineRunner {

    private final LeaveTypeRepository leaveTypeRepository;

    public LeaveTypeSeeder(LeaveTypeRepository leaveTypeRepository) {
        this.leaveTypeRepository = leaveTypeRepository;
    }

    @Override
    public void run(String... args) {
        seedIfMissing("Yıllık İzin", 14);
        seedIfMissing("Mazeret İzni", 5);
        seedIfMissing("Hastalık İzni", 10);
    }

    private void seedIfMissing(String name, int defaultDays) {
        if (!leaveTypeRepository.existsByName(name)) {
            LeaveType leaveType = new LeaveType();
            leaveType.setName(name);
            leaveType.setDefaultDays(defaultDays);
            leaveType.setActive(true);
            leaveType.setGenderRestriction(null);
            leaveTypeRepository.save(leaveType);
        }
    }
}