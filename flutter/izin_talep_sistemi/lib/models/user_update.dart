import 'package:izin_talep_sistemi/models/Gender.dart';

class UserUpdate {
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? departmentId;
  final int? roleId;
  final bool? active;
  final Gender? gender;

  UserUpdate({
    this.firstName,
    this.lastName,
    this.email,
    this.departmentId,
    this.roleId,
    this.active,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'departmentId': departmentId,
      'roleId': roleId,
      'active': active,
      'gender': gender?.name,
    };
  }
}
