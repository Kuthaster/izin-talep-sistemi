import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/leave_request_count.dart';
import 'package:izin_talep_sistemi/models/leave_request_create.dart';
import 'package:izin_talep_sistemi/models/leave_request_decision.dart';

import 'api_client.dart';
import '../models/leave_request.dart';

class LeaveRequestService {
  final Dio _dio;

  LeaveRequestService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<LeaveRequest>> getMyLeaveRequests() async {
    final response = await _dio.get('/api/leaveRequests/mine');
    return (response.data as List)
        .map((item) => LeaveRequest.fromJson(item))
        .toList();
  }

  Future<LeaveRequestCount> getLeaveRequestCount() async {
    final response = await _dio.get('/api/leaveRequests/dashboard');
    return LeaveRequestCount.fromJson(response.data);
  }

  Future<List<LeaveRequest>> getLeaveRequestsForApproval() async {
    final response = await _dio.get('/api/leaveRequests/forApproval');

    return (response.data as List)
        .map((item) => LeaveRequest.fromJson(item))
        .toList();
  }

  Future<LeaveRequest> createLeaveRequest(LeaveRequestCreate dto) async {
    final response = await _dio.post('/api/leaveRequests', data: dto.toJson());

    return LeaveRequest.fromJson(response.data);
  }

  Future<LeaveRequest> decide(int requestId, LeaveRequestDecision dto) async {
    final response = await _dio.patch(
      '/api/leaveRequests/forApproval/$requestId',
      data: dto.toJson(),
    );

    return LeaveRequest.fromJson(response.data);
  }

  Future<LeaveRequest> updateLeaveRequest(
    int requestId,
    LeaveRequestCreate dto,
  ) async {
    final response = await _dio.put(
      '/api/leaveRequests/mine/$requestId',
      data: dto.toJson(),
    );

    return LeaveRequest.fromJson(response.data);
  }

  Future<LeaveRequest> cancelLeaveRequest(int requestId) async {
    final response = await _dio.patch('/api/leaveRequests/mine/$requestId');

    return LeaveRequest.fromJson(response.data);
  }

  Future<void> deleteLeaveRequest(int requestId) async {
    await _dio.delete('/api/leaveRequests/$requestId');
  }
}
