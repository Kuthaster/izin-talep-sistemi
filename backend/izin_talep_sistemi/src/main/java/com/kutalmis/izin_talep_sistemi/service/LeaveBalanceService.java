
package com.kutalmis.izin_talep_sistemi.service;

import com.kutalmis.izin_talep_sistemi.entity.LeaveBalance;
import com.kutalmis.izin_talep_sistemi.entity.LeaveType;
import com.kutalmis.izin_talep_sistemi.entity.User;
import com.kutalmis.izin_talep_sistemi.repository.LeaveBalanceRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;

@Service
public class LeaveBalanceService {

    private final LeaveBalanceRepository leaveBalanceRepository;

    public LeaveBalanceService(LeaveBalanceRepository leaveBalanceRepository) {
        this.leaveBalanceRepository = leaveBalanceRepository;
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
    public void releaseReservation(User user, LeaveType leaveType, int year, int days) {
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
            // requesting more days — validate the extra
            if (delta > balance.getAvailableDays()) {
                throw new IllegalArgumentException(
                        "Yetersiz izin bakiyesi. Kullanılabilir: " + balance.getAvailableDays()
                                + " gün, ek talep edilen: " + delta + " gün.");
            }
        }
        balance.setReservedDays(Math.max(0, balance.getReservedDays() + delta));
        leaveBalanceRepository.save(balance);
    }
}
