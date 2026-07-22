import 'package:izin_talep_sistemi/models/role_authority.dart';

class RoleCreate {
  final String displayName;
  final RoleAuthority name;

  RoleCreate({required this.displayName, required this.name});

  factory RoleCreate.fromJson(Map<String, dynamic> json) {
    return RoleCreate( 
      displayName: json['displayName'],
      name: RoleAuthority.values.byName(json['name']),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'displayName': displayName,
      'name': name.name
    };
  }
}