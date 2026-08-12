import 'role_authority.dart';

class Role {
  final int id;
  final RoleAuthority name;
  final String displayName;

  Role({required this.id, required this.name, required this.displayName});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: RoleAuthority.values.byName(json['name']),
      displayName: json['displayName'],
    );
  }
}
