class LeaveTypeCreate {
  final String name;
  final int defaultDays;
  final int? requiredLevels;
  
  LeaveTypeCreate({required this.name, required this.defaultDays, required this.requiredLevels});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'defaultDays': defaultDays,
      'requiredLevels': requiredLevels,
    };
  }
}