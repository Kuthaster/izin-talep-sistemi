import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/leave_request_count.dart';
import 'package:izin_talep_sistemi/models/leave_request_create.dart';
import 'package:izin_talep_sistemi/models/leave_request_decision.dart';
import 'package:izin_talep_sistemi/models/leave_request_filter.dart';

import 'api_client.dart';
import '../models/leave_request.dart';

class LeaveRequestService {
  final Dio _dio;

  LeaveRequestService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<LeaveRequest>> getMyLeaveRequests([
    LeaveRequestFilter? filter,
  ]) async {
    final response = await _dio.get(
      '/api/leaveRequests/mine',
      queryParameters: filter?.toQueryParams(),
    );
    return (response.data as List)
        .map((item) => LeaveRequest.fromJson(item))
        .toList();
  }

  Future<LeaveRequestCount> getLeaveRequestCount() async {
    final response = await _dio.get('/api/leaveRequests/dashboard');
    return LeaveRequestCount.fromJson(response.data);
  }

  Future<List<LeaveRequest>> getLeaveRequestsForApproval([
    LeaveRequestFilter? filter,
  ]) async {
    final response = await _dio.get(
      '/api/leaveRequests/forApproval',
      queryParameters: filter?.toQueryParams(),
    );
    return (response.data as List)
        .map((item) => LeaveRequest.fromJson(item))
        .toList();
  }

  Future<List<LeaveRequest>> createLeaveRequest(LeaveRequestCreate dto) async {
    final response = await _dio.post('/api/leaveRequests', data: dto.toJson());

    final List<dynamic> data = response.data;
    return data.map((item) => LeaveRequest.fromJson(item)).toList();
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
