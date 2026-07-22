class LeaveTypeUpdate {
  final int? defaultDays;
  final bool? active;
  final int? requiredLevels;
  
  LeaveTypeUpdate({required this.defaultDays,required this.active, required this.requiredLevels});
  
  factory LeaveTypeUpdate.fromJson(Map<String, dynamic> json){
    return LeaveTypeUpdate(
        defaultDays: json['defaultDays'],
        active: json['active'],
        requiredLevels: json['requiredLevels']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultDays': defaultDays,
      'active': active,
      'requiredLevels': requiredLevels,
    };
  }
}