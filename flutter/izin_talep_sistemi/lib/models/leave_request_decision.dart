import 'leave_decision.dart';

class LeaveRequestDecision {
  final String? managerNote;
  final LeaveDecision decision;

  LeaveRequestDecision({this.managerNote, required this.decision});

  factory LeaveRequestDecision.fromJson(Map<String, dynamic> json){
    return LeaveRequestDecision(
        decision: LeaveDecision.values.byName(json['decision']),
        managerNote: json["managerNote"],
    );
  }
    Map<String, dynamic> toJson(){
    return {
      'decision': decision.name,
      'managerNote': managerNote
    };
  }
}