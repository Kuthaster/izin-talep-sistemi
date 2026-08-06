package com.kutalmis.izin_talep_sistemi.service;

import com.kutalmis.izin_talep_sistemi.dto.LeaveBalanceDTO;
import com.kutalmis.izin_talep_sistemi.dto.LeaveBalanceUpdateDTO;
import com.kutalmis.izin_talep_sistemi.entity.LeaveBalance;
import com.kutalmis.izin_talep_sistemi.entity.LeaveBalanceAudit;
import com.kutalmis.izin_talep_sistemi.entity.LeaveBalanceSpecifications;
import com.kutalmis.izin_talep_sistemi.entity.LeaveType;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.repository.LeaveBalanceAuditRepository;
import com.kutalmis.izin_talep_sistemi.repository.LeaveBalanceRepository;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class LeaveBalanceService {

    private final LeaveBalanceRepository leaveBalanceRepository;
    private final LeaveBalanceAuditRepository leaveBalanceAuditRepository;

    public LeaveBalanceService(LeaveBalanceRepository leaveBalanceRepository,
            LeaveBalanceAuditRepository leaveBalanceAuditRepository) {
        this.leaveBalanceRepository = leaveBalanceRepository;
        this.leaveBalanceAuditRepository = leaveBalanceAuditRepository;
    }

    public int countBusinessDays(LocalDate start, LocalDate end) {
        int count = 0;
        LocalDate current = start;
        while (!current.isAfter(end)) {
            DayOfWeek day = current.getDayOfWeek();
            if (day != DayOfWeek.SATURDAY && day != DayOfWeek.SUNDAY) {
                count++;
            }
            current = current.plusDays(1);
        }
        return count;
    }

    @Transactional
    public LeaveBalance getOrCreateBalance(User user, LeaveType leaveType, int year) {
        return leaveBalanceRepository
                .findByUser_IdAndLeaveType_IdAndYear(user.getId(), leaveType.getId(), year)
                .orElseGet(() -> {
                    LeaveBalance balance = new LeaveBalance();
                    balance.setUser(user);
                    balance.setLeaveType(leaveType);
                    balance.setYear(year);
                    balance.setTotalDays(leaveType.getDefaultDays());
                    balance.setUsedDays(0);
                    balance.setReservedDays(0);
                    return leaveBalanceRepository.save(balance);
                });
    }

    public void validateAvailability(LeaveBalance balance, int requestedDays) {
        if (requestedDays > balance.getAvailableDays()) {
            throw new IllegalArgumentException(
                    "Yetersiz izin bakiyesi. Kullanılabilir: " + balance.getAvailableDays()
                            + " gün, talep edilen: " + requestedDays + " gün.");
        }
    }

    @Transactional
    public void reserve(User user, LeaveType leaveType, int year, int days) {
        LeaveBalance balance = getOrCreateBalance(user, leaveType, year);
        validateAvailability(balance, days);
        balance.setReservedDays(balance.getReservedDays() + days);
        leaveBalanceRepository.save(balance);
    }

    @Transactional
    public void releaseReservedDays(User user, LeaveType leaveType, int year, int days) {
        leaveBalanceRepository
                .findByUser_IdAndLeaveType_IdAndYear(user.getId(), leaveType.getId(), year)
                .ifPresent(balance -> {
                    balance.setReservedDays(Math.max(0, balance.getReservedDays() - days));
                    leaveBalanceRepository.save(balance);
                });
    }

    @Transactional
    public void consume(User user, LeaveType leaveType, int year, int days) {
        leaveBalanceRepository
                .findByUser_IdAndLeaveType_IdAndYear(user.getId(), leaveType.getId(), year)
                .ifPresent(balance -> {
                    balance.setReservedDays(Math.max(0, balance.getReservedDays() - days));
                    balance.setUsedDays(balance.getUsedDays() + days);
                    leaveBalanceRepository.save(balance);
                });
    }

    @Transactional
    public void updateReservation(User user, LeaveType leaveType, int year,
            int oldDays, int newDays) {
        LeaveBalance balance = getOrCreateBalance(user, leaveType, year);
        int delta = newDays - oldDays;
        if (delta > 0) {
            if (delta > balance.getAvailableDays()) {
                throw new IllegalArgumentException(
                        "Yetersiz izin bakiyesi. Kullanılabilir: " + balance.getAvailableDays()
                                + " gün, ek talep edilen: " + delta + " gün.");
            }
        }
        balance.setReservedDays(Math.max(0, balance.getReservedDays() + delta));
        leaveBalanceRepository.save(balance);
    }

    public List<LeaveBalanceDTO> getUserBalances(Long userId, Integer year, Long leaveTypeId) {
        Specification<LeaveBalance> spec = Specification
                .where(LeaveBalanceSpecifications.belongsToUser(userId))
                .and(LeaveBalanceSpecifications.hasYear(year))
                .and(LeaveBalanceSpecifications.hasLeaveType(leaveTypeId));

        return leaveBalanceRepository.findAll(spec).stream()
                .map(b -> new LeaveBalanceDTO(
                        b.getId(),
                        b.getUser().getId(),
                        b.getUser().getFirstName() + " " + b.getUser().getLastName(),
                        b.getLeaveType().getName(), b.getYear(),
                        b.getTotalDays(), b.getUsedDays(), b.getReservedDays(), b.getAvailableDays()))
                .collect(Collectors.toList());
    }

    @Transactional

    public LeaveBalanceDTO updateBalanceAsAdmin(Long balanceId, LeaveBalanceUpdateDTO dto, User admin) {
        LeaveBalance balance = leaveBalanceRepository.findById(balanceId)
                .orElseThrow(() -> new IllegalArgumentException("Bakiye bulunamadı."));

        Integer oldTotal = balance.getTotalDays();
        balance.setTotalDays(dto.newTotalDays());

        leaveBalanceAuditRepository
                .save(new LeaveBalanceAudit(balance, admin, oldTotal, dto.newTotalDays(), dto.reason()));
        LeaveBalance saved = leaveBalanceRepository.save(balance);

        return new LeaveBalanceDTO(
                saved.getId(),
                saved.getUser().getId(),
                saved.getUser().getFirstName() + " " + saved.getUser().getLastName(),
                saved.getLeaveType().getName(), saved.getYear(),
                saved.getTotalDays(), saved.getUsedDays(), saved.getReservedDays(), saved.getAvailableDays());
    }
}