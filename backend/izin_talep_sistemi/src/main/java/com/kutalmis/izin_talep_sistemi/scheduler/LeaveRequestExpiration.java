package com.kutalmis.izin_talep_sistemi.scheduler;

import java.time.LocalDate;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.kutalmis.izin_talep_sistemi.entity.LeaveRequest;
import com.kutalmis.izin_talep_sistemi.repository.LeaveRequestRepository;
import com.kutalmis.izin_talep_sistemi.service.LeaveBalanceService;

import jakarta.transaction.Transactional;

@Component
public class LeaveRequestExpiration {

    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveBalanceService leaveBalanceService;

    public LeaveRequestExpiration(LeaveRequestRepository leaveRequestRepository,
            LeaveBalanceService leaveBalanceService) {
        this.leaveRequestRepository = leaveRequestRepository;
        this.leaveBalanceService = leaveBalanceService;
    }

    @Scheduled(cron = "0 0 1 * * *")
    @Transactional
    public void expireStalePendingRequests() {
        List<LeaveRequest> stale = leaveRequestRepository
                .findByStatusAndStartDateBefore("PENDING", LocalDate.now());

        for (LeaveRequest request : stale) {
            leaveBalanceService.releaseReservedDays(
                    request.getUser(),
                    request.getLeaveType(),
                    request.getStartDate().getYear(),
                    request.getRequestedDays());
            request.setStatus("EXPIRED");
            leaveRequestRepository.save(request);
        }
    }
}