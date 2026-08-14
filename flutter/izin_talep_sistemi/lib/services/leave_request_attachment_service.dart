import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:izin_talep_sistemi/models/leave_request_attachment.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class LeaveRequestAttachmentService {
  final Dio _dio;

  LeaveRequestAttachmentService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<LeaveRequestAttachment> upload(int leaveRequestId, XFile file) async {
    final bytes = await file.readAsBytes();
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: file.name),
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
    final response = await _dio.get(
      '/api/leaveRequests/$leaveRequestId/attachments',
    );
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

  Future<File> downloadToFile(int attachmentId, String savePath) async {
    final url = downloadUrl(attachmentId);

    await _dio.download(
      url,
      savePath,
      options: Options(responseType: ResponseType.bytes),
    );

    return File(savePath);
  }

  Future<List<int>> downloadBytes(int attachmentId) async {
    final response = await _dio.get<List<int>>(
      '/api/leaveRequests/attachments/$attachmentId/download',
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data!;
  }
}
