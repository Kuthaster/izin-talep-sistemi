
class DepartmentUpdate {
  final String departmentName;
  //NOTE burayı implemente ederken boş olmamasını garantile

  DepartmentUpdate({required this.departmentName});

  Map<String, dynamic> toJson(){
    return {
    'departmentName' : departmentName
    };
  }
}