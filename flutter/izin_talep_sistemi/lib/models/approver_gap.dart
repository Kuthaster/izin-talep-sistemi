class ApproverGap {
  final int departmentId;
  final String departmentName;
  final List<int> missingLevels;

  ApproverGap({
    required this.departmentId,
    required this.departmentName,
    required this.missingLevels,
  });

  factory ApproverGap.fromJson(Map<String, dynamic> json) {
    return ApproverGap(
      departmentId: json['departmentId'],
      departmentName: json['departmentName'],
      missingLevels: List<int>.from(json['missingLevels']),
    );
  }
}
