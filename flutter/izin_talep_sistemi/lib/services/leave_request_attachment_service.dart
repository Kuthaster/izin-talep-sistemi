import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/leave_request_attachment.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class LeaveRequestAttachmentService {
  final Dio _dio;

  LeaveRequestAttachmentService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<LeaveRequestAttachment> upload(
    int leaveRequestId,
    String filePath,
    String fileName,
  ) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final response = await _dio.post(
      '/api/leaveRequests/$leaveRequestId/attachments',
      data: formData,
    );
    return LeaveRequestAttachment.fromJson(response.data);
  }

  Future<List<LeaveRequestAttachment>> getAttachments(
    int leaveRequestId,
  ) async {
    final response = await _dio.get('/api/leaveRequests/{id}/attachments');
    return (response.data as List)
        .map((item) => LeaveRequestAttachment.fromJson(item))
        .toList();
  }

  Future<void> delete(int attachmentId) async {
    await _dio.delete('/api/leaveRequests/attachments/$attachmentId');
  }

  String downloadUrl(int attachmentId) {
    return '${_dio.options.baseUrl}/api/leaveRequests/attachments/$attachmentId/download';
  }
}
