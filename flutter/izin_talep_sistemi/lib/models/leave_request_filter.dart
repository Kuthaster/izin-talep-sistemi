class LeaveRequestFilter {
  final String? status;
  final String? reason;
  final int? leaveTypeId;
  final DateTime? startDateFrom;
  final DateTime? startDateTo;
  final int? approverId;
  final int? currentLevel;
  const LeaveRequestFilter({
    this.status,
    this.reason,
    this.leaveTypeId,
    this.startDateFrom,
    this.startDateTo,
    this.approverId,
    this.currentLevel,
  });
  LeaveRequestFilter copyWith({
    String? status,
    String? reason,
    int? leaveTypeId,
    DateTime? startDateFrom,
    DateTime? startDateTo,
    int? approverId,
    int? currentLevel,
    bool clearStatus = false,
    bool clearReason = false,
    bool clearLeaveType = false,
    bool clearStartDateFrom = false,
    bool clearStartDateTo = false,
    bool clearApproverId = false,
    bool clearCurrentLevel = false,
  }) {
    return LeaveRequestFilter(
      status: clearStatus ? null : (status ?? this.status),
      reason: clearReason ? null : (reason ?? this.reason),
      leaveTypeId: clearLeaveType ? null : (leaveTypeId ?? this.leaveTypeId),
      startDateFrom: clearStartDateFrom
          ? null
          : (startDateFrom ?? this.startDateFrom),
      startDateTo: clearStartDateTo ? null : (startDateTo ?? this.startDateTo),
      approverId: clearApproverId ? null : (approverId ?? this.approverId),
      currentLevel: clearCurrentLevel
          ? null
          : (currentLevel ?? this.currentLevel),
    );
  }

  bool get isEmpty =>
      status == null &&
      reason == null &&
      leaveTypeId == null &&
      startDateFrom == null &&
      startDateTo == null &&
      approverId == null &&
      currentLevel == null;

  Map<String, dynamic> toQueryParams() {
    final map = <String, dynamic>{};

    if (status != null) map['status'] = status;
    if (reason != null) map['reason'] = reason;
    if (leaveTypeId != null) map['leaveTypeId'] = leaveTypeId;
    if (startDateFrom != null) {
      map['startDateFrom'] = startDateFrom!.toIso8601String().split('T').first;
    }
    if (startDateTo != null) {
      map['startDateTo'] = startDateTo!.toIso8601String().split('T').first;
    }
    if (approverId != null) map['approverId'] = approverId;
    if (currentLevel != null) map['currentLevel'] = currentLevel;

    return map;
  }
}
