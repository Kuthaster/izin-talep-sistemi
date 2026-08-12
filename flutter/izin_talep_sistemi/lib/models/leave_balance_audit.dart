class LeaveBalanceAudit {
  final int id;
  final int balanceId;
  final String leaveTypeName;
  final String userName;
  final String adminName;
  final int oldTotalDays;
  final int newTotalDays;
  final String reason;
  final DateTime changedAt;

  LeaveBalanceAudit({
    required this.id,
    required this.balanceId,
    required this.leaveTypeName,
    required this.userName,
    required this.adminName,
    required this.oldTotalDays,
    required this.newTotalDays,
    required this.reason,
    required this.changedAt,
  });

  factory LeaveBalanceAudit.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceAudit(
      id: json['id'],
      balanceId: json['balanceId'],
      leaveTypeName: json['leaveTypeName'],
      userName: json['userName'],
      adminName: json['adminName'],
      oldTotalDays: json['oldTotalDays'],
      newTotalDays: json['newTotalDays'],
      reason: json['reason'],
      changedAt: DateTime.parse(json['changedAt']),
    );
  }
}
