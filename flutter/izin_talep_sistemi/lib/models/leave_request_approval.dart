import 'leave_decision.dart';

class LeaveRequestApproval {
  final int level;
  final String approverName;
  final LeaveDecision decision;
  String? note;
  final DateTime decidedAt;
  
  LeaveRequestApproval({required this.level, required this.approverName, required this.decision, this.note,required this.decidedAt});

  factory LeaveRequestApproval.fromJson(Map<String, dynamic> json){
    return LeaveRequestApproval(
        level: json['level'],
        approverName: json["approverName"],
        decision: LeaveDecision.values.byName(json['decision']),
        note: json['note'],
        decidedAt: DateTime.parse(json['decidedAt']),
      );
  }
}