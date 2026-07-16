class LeaveRequestFilter {
  final String   status;
  final int      leaveTypeId;
  final DateTime startDateFrom;
  final DateTime startDateTo;
  final int      approverId;
  final String   currentLevel;
/*   buraya leaverequestapprovaldto ekle */  
  LeaveRequestFilter({required this.status, required this.leaveTypeId, required this.startDateFrom, required this.startDateTo, required this.approverId, required this.currentLevel});

  factory LeaveRequestFilter.fromJson(Map<String, dynamic> json){
    return LeaveRequestFilter(
        status: json['status'],
        leaveTypeId: json['leaveTypeId'],
        startDateFrom: json['startDateFrom'],
        startDateTo: json['startDateTo'],
        approverId: json["approverId"],
        currentLevel: json['currentLevel'],
    );
  }
}