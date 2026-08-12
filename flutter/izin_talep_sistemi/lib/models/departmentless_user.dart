class DepartmentlessUser {
  final int userId;
  final String userName;
  final String email;

  DepartmentlessUser({
    required this.userId,
    required this.userName,
    required this.email,
  });

  factory DepartmentlessUser.fromJson(Map<String, dynamic> json) {
    return DepartmentlessUser(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
    );
  }
}
