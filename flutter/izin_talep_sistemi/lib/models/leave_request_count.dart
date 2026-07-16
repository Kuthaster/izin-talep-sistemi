class LeaveRequestCount {
  final int pending;
  final int approved;
  final int rejected;
  final int cancelled;
  final int total;

  LeaveRequestCount({required this.pending, required this.approved,required this.rejected,required this.cancelled,required this.total,});

  factory LeaveRequestCount.fromJson(Map<String, dynamic> json){
    return LeaveRequestCount(
        pending: json['pending'],
        approved: json["approved"],
        rejected: json['rejected'],
        cancelled: json['cancelled'],
        total: json['total'],

    );
  }
}