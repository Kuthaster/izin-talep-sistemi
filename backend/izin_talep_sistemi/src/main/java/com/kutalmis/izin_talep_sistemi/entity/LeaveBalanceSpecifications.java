package com.kutalmis.izin_talep_sistemi.entity;

import org.springframework.data.jpa.domain.Specification;

public class LeaveBalanceSpecifications {
    public static Specification<LeaveBalance> belongsToUser(Long userId) {
        return (root, query, cb) -> userId == null ? null : cb.equal(root.get("user").get("id"), userId);
    }

    public static Specification<LeaveBalance> hasYear(Integer year) {
        return (root, query, cb) -> year == null ? null : cb.equal(root.get("year"), year);
    }

    public static Specification<LeaveBalance> hasLeaveType(Long leaveTypeId) {
        return (root, query, cb) -> leaveTypeId == null ? null : cb.equal(root.get("leaveType").get("id"), leaveTypeId);
    }
}