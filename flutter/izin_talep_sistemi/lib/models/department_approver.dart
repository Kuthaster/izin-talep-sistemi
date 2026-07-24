class DepartmentApprover {
  final int id;
  final int departmentId;
  final String departmentName;
  final int level;
  final int approverId;
  final String approverName;

  DepartmentApprover({
    required this.id,
    required this.departmentId,
    required this.departmentName,
    required this.level,
    required this.approverId,
    required this.approverName,
  });

  factory DepartmentApprover.fromJson(Map<String, dynamic> json) {
    return DepartmentApprover(
      id: json['id'],
      departmentId: json['departmentId'],
      departmentName: json['departmentName'],
      level: json['level'],
      approverId: json['approverId'],
      approverName: json['approverName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'level': level,
      'approverId': approverId,
      'approverName': approverName,
    };
  }
}
