class LeaveRequestAttachment {
  final int id;
  final String fileName;
  final String contentType;
  final DateTime uploadedAt;

  LeaveRequestAttachment({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.uploadedAt,
  });

  factory LeaveRequestAttachment.fromJson(Map<String, dynamic> json) {
    return LeaveRequestAttachment(
      id: json['id'],
      fileName: json["fileName"],
      contentType: json['contentType'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }
}
