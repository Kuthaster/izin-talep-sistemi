package com.kutalmis.izin_talep_sistemi.entity;

import java.util.List;
import java.time.LocalDate;
import jakarta.persistence.criteria.Root;
import jakarta.persistence.criteria.Subquery;

import org.springframework.data.jpa.domain.Specification;

public class LeaveRequestSpecifications {
    public static Specification<LeaveRequest> hasStatus(String status) {
        return (root, query, cb) -> status == null ? null : cb.equal(root.get("status"), status);
    }

    public static Specification<LeaveRequest> hasReason(String reason) {
        return (root, query, cb) -> {
            if (reason == null || reason.trim().isEmpty()) {
                return null; // no predicate
            }
            return cb.equal(root.get("reason"), reason);
        };
    }

    public static Specification<LeaveRequest> hasLeaveType(Long leaveTypeId) {
        return (root, query, cb) -> leaveTypeId == null ? null : cb.equal(root.get("leaveType").get("id"), leaveTypeId);
    }

    public static Specification<LeaveRequest> startDateFrom(LocalDate from) {
        return (root, query, cb) -> from == null ? null : cb.greaterThanOrEqualTo(root.get("startDate"), from);
    }

    public static Specification<LeaveRequest> startDateTo(LocalDate to) {
        return (root, query, cb) -> to == null ? null : cb.lessThanOrEqualTo(root.get("startDate"), to);
    }

    public static Specification<LeaveRequest> belongsToUser(Long userId) {
        return (root, query, cb) -> cb.equal(root.get("user").get("id"), userId);
    }

    public static Specification<LeaveRequest> hasCurrentLevel(Integer level) {
        return (root, query, cb) -> level == null ? null : cb.equal(root.get("currentLevel"), level);
    }

    public static Specification<LeaveRequest> inDepartments(List<Long> departmentIds) {
        return (root, query, cb) -> root.get("user").get("department").get("id").in(departmentIds);
    }

    public static Specification<LeaveRequest> approvedByApprover(Long approverId) {
        return (root, query, cb) -> {
            if (approverId == null)
                return null;
            Subquery<Long> subquery = query.subquery(Long.class);
            Root<LeaveRequestApproval> approvalRoot = subquery.from(LeaveRequestApproval.class);
            subquery.select(approvalRoot.get("leaveRequest").get("id"))
                    .where(cb.equal(approvalRoot.get("approver").get("id"), approverId));
            return root.get("id").in(subquery);
        };

    }

}
