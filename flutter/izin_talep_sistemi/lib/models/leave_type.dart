import 'package:izin_talep_sistemi/models/Gender.dart';

class LeaveType {
  final int id;
  final String name;
  final int defaultDays;
  final bool active;
  final int requiredLevels;
  final Gender? genderRestriction;

  LeaveType({
    required this.id,
    required this.name,
    required this.defaultDays,
    required this.active,
    required this.requiredLevels,
    this.genderRestriction,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'],
      name: json["name"],
      defaultDays: json['defaultDays'],
      active: json['active'],
      requiredLevels: json['requiredLevels'],
      genderRestriction: json['genderRestriction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'defaultDays': defaultDays,
      'active': active,
      'requiredLevels': requiredLevels,
      'genderRestriction': genderRestriction,
    };
  }
}
