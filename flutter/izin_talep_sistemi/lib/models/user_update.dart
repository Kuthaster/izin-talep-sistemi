class UserUpdate {
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? departmentId;
  final int? roleId;
  final bool? active;

  UserUpdate({
    this.firstName,
    this.lastName,
    this.email,
    this.departmentId,
    this.roleId,
    this.active,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'departmentId': departmentId,
      'roleId': roleId,
      'active': active,
    };
  }
}
