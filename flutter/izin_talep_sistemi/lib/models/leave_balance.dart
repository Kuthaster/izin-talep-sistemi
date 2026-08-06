class LeaveBalance {
  final int id;
  final int userId;
  final String userName;
  final String leaveTypeName;
  final int year;
  final int totalDays;
  final int usedDays;
  final int reservedDays;
  final int availableDays;

  LeaveBalance({
    required this.id,
    required this.userId,
    required this.userName,
    required this.leaveTypeName,
    required this.year,
    required this.totalDays,
    required this.usedDays,
    required this.reservedDays,
    required this.availableDays,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      leaveTypeName: json["leaveTypeName"],
      year: json['year'],
      totalDays: json['totalDays'],
      usedDays: json['usedDays'],
      reservedDays: json['reservedDays'],
      availableDays: json['availableDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'leaveTypeName': leaveTypeName,
      'year': year,
      'totalDays': totalDays,
      'usedDays': usedDays,
      'reservedDays': reservedDays,
      'availableDays': availableDays,
    };
  }
}
