import 'leave_request_approval.dart';
class LeaveRequest {
  final int id;
  final String userName;
  final String leaveTypeName;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int defaultDays;
  final DateTime createdAt;
  final int currentLevel;
  final List<LeaveRequestApproval> approvals; 
  LeaveRequest({required this.id, required this.userName, required this.leaveTypeName, required this.startDate, required this.endDate, required this.status,required this.defaultDays, required this.createdAt, required this.currentLevel,required this.approvals});

  factory LeaveRequest.fromJson(Map<String, dynamic> json){
    return LeaveRequest(
        id: json['id'],
        userName: json["userName"],
        leaveTypeName: json['leaveTypeName'],
        startDate: json['active'],
        endDate: json['endDate'],
        status: json['status'],
        defaultDays: json['defaultDays'],
        createdAt: json['createdAt'],
        currentLevel: json['currentLevel'],
        approvals: (json['approvals'] as List)
          .map((item) => LeaveRequestApproval.fromJson(item))
          .toList(), 
    );
  }
}