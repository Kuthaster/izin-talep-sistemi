import 'package:izin_talep_sistemi/models/Gender.dart';

class LeaveTypeCreate {
  final String name;
  final int defaultDays;
  final int? requiredLevels;
  final Gender? gender;

  LeaveTypeCreate({
    required this.name,
    required this.defaultDays,
    required this.requiredLevels,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'defaultDays': defaultDays,
      'requiredLevels': requiredLevels,
      'gender': gender,
    };
  }
}
