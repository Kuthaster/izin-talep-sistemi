class LeaveTypeCount {
  final int leaveTypeId;
  final String leaveTypeName;
  final int pending;
  final int approved;
  final int rejected;
  final int cancelled;
  final int total;

  LeaveTypeCount({
    required this.leaveTypeId,
    required this.leaveTypeName,
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.cancelled,
    required this.total,
  });

  factory LeaveTypeCount.fromJson(Map<String, dynamic> json) {
    return LeaveTypeCount(
      leaveTypeId: json['leaveTypeId'],
      leaveTypeName: json['leaveTypeName'],
      pending: json['pending'],
      approved: json["approved"],
      rejected: json['rejected'],
      cancelled: json['cancelled'],
      total: json['total'],
    );
  }
}
