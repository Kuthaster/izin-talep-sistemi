import 'package:intl/intl.dart';

class LeaveRequestCreate {
  final int leaveTypeId;
  final DateTime startDate;
  final DateTime endDate;
  String? reason;

  LeaveRequestCreate({
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    this.reason,
  });

  factory LeaveRequestCreate.fromJson(Map<String, dynamic> json) {
    return LeaveRequestCreate(
      leaveTypeId: json['leaveTypeId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: (json['decision']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveTypeId': leaveTypeId,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'reason': reason,
    };
  }
}
