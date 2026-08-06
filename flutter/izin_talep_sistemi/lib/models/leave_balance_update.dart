class LeaveBalanceUpdate {
  final int newTotalDays;
  final String reason;

  LeaveBalanceUpdate({required this.newTotalDays, required this.reason});

  factory LeaveBalanceUpdate.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceUpdate(
      newTotalDays: json['newTotalDays'],
      reason: json["reason"],
    );
  }

  Map<String, dynamic> toJson() {
    return {'newTotalDays': newTotalDays, 'reason': reason};
  }
}
