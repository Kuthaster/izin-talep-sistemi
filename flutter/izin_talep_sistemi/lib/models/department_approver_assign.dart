class DepartmentApproverAssign {
  final int departmentId;
  final int level;
  final int approverId;

  DepartmentApproverAssign({
    required this.departmentId,
    required this.level,
    required this.approverId,
  });

  Map<String, dynamic> toJson() {
    return {
      'departmentId': departmentId,
      'level': level,
      'approverId': approverId,
    };
  }
}
