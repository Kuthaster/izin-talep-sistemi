class RoleUpdate {
  final String? displayName;

  RoleUpdate({required this.displayName});

  factory RoleUpdate.fromJson(Map<String, dynamic> json) {
    return RoleUpdate(displayName: json['displayName']);
  }

  Map<String, dynamic> toJson() {
    return {'displayName': displayName};
  }
}
