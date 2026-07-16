class UserResponse{
  final int    id;
  final String firstName; 
  final String lastName;
  final String email;
  final String departmentName; 
  final String roleDisplayName; 

  UserResponse({required this.id, required this.firstName, required this.lastName, required this.email, required this.departmentName, required this.roleDisplayName});
  factory UserResponse.fromJson(Map<String, dynamic> json){
    return UserResponse( 
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      departmentName: json['departmentName'],
      roleDisplayName: json['roleDisplayName'],
    );
  }
}