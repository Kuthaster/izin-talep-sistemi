class UserCreate {
  final String firstName;
  final String lastName;
  final String email;
  final String rawPassword;
  final int    departmentId;
  final int    roleId;

  UserCreate({required this.firstName, required this.lastName, required this.email, required this.rawPassword, required this.departmentId, required this.roleId});

  Map<String, dynamic> toJson(){
    return {
      'firstName':    firstName,
      'lastName':     lastName,
      'email':        email,
      'rawPassword':  rawPassword,
      'departmentId': departmentId,
      'roleId':       roleId
    };
  }
}