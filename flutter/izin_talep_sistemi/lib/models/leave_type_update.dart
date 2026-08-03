import 'package:izin_talep_sistemi/models/Gender.dart';

class LeaveTypeUpdate {
  final int? defaultDays;
  final bool? active;
  final int? requiredLevels;
  final Gender? gender;

  LeaveTypeUpdate({
    required this.defaultDays,
    required this.active,
    required this.requiredLevels,
    this.gender,
  });

  factory LeaveTypeUpdate.fromJson(Map<String, dynamic> json) {
    return LeaveTypeUpdate(
      defaultDays: json['defaultDays'],
      active: json['active'],
      requiredLevels: json['requiredLevels'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultDays': defaultDays,
      'active': active,
      'requiredLevels': requiredLevels,
      'gender': gender,
    };
  }
}
