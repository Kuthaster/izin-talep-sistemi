class RoleUpdate {
  final String? displayName;
  final bool? active;

  RoleUpdate({required this.displayName, required this.active});

  factory RoleUpdate.fromJson(Map<String, dynamic> json) {
    return RoleUpdate( 
      displayName: json['displayName'],
      active: json['active'],
    );
  }

  Map<String , dynamic> toJson(){
    return { 
    'displayName': displayName,
    'active': active
    };
  }
}