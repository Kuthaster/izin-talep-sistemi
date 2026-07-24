import 'role_authority.dart';

class Role {
  final int id;
  final RoleAuthority name;
  final String displayName;
  final bool active;

  Role({
    required this.id,
    required this.name,
    required this.displayName,
    required this.active,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: RoleAuthority.values.byName(json['name']),
      displayName: json['displayName'],
      active: json['active'],
    );
  }
}
