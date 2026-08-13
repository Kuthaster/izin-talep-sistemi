class PasswordResetRequest {
  final int id;
  final int userId;
  final String userName;
  final String email;
  final DateTime requestedAt;

  PasswordResetRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.email,
    required this.requestedAt,
  });

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) {
    return PasswordResetRequest(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      requestedAt: DateTime.parse(json['requestedAt']),
    );
  }
}
