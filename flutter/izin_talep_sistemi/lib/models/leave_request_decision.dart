import 'leave_decision.dart';

class LeaveRequestDecision {
  String? name;
  final LeaveDecision decision;

  LeaveRequestDecision({required this.decision, required this.name});

  factory LeaveRequestDecision.fromJson(Map<String, dynamic> json){
    return LeaveRequestDecision(
        decision: json['decision'],
        name: json["name"],
    );
  }
    Map<String, dynamic> toJson(){
    return {
      'decision': decision.name,
      'name': name
    };
  }
}