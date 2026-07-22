class ChangePassword {
  final String currentPassword;
  final String newPassword;

  ChangePassword({required this.currentPassword, required this.newPassword,});

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}