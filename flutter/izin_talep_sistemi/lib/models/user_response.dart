import 'package:izin_talep_sistemi/models/Gender.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';

class UserResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String departmentName;
  final String roleDisplayName;
  final RoleAuthority roleAuthority;
  final bool active;
  final Gender gender;
  final bool mustChangePassword;

  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.departmentName,
    required this.roleDisplayName,
    required this.roleAuthority,
    required this.active,
    required this.gender,
    required this.mustChangePassword,
  });
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      departmentName: json['departmentName'],
      roleDisplayName: json['roleDisplayName'],
      roleAuthority: RoleAuthority.values.byName(json['roleAuthority']),
      active: json['active'],
      gender: Gender.values.byName(json['gender']),
      mustChangePassword: json['mustChangePassword'],
    );
  }
}
