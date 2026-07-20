class LeaveType {
  final int id;
  final String name;
  final int defaultDays;
  final bool active;
  final int requiredLevels;

  LeaveType({required this.id, required this.name, required this.defaultDays, required this.active, required this.requiredLevels});

  factory LeaveType.fromJson(Map<String, dynamic> json){
    return LeaveType(
        id: json['id'],
        name: json["name"],
        defaultDays: json['defaultDays'],
        active: json['active'],
        requiredLevels: json['requiredLevels'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'defaultDays': defaultDays,
      'active': active,
      'requiredLevels': requiredLevels
    };
  }
}