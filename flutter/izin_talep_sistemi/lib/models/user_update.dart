class UserUpdate {
 final bool? active;
 final int? departmentId;
 final String? displayName;

 UserUpdate({this.active, this.departmentId, this.displayName});

 Map<String , dynamic> toJson(){
  return {
    'active': active,
    'departmentId': departmentId,
    'displayName': displayName
  };
 } 
}