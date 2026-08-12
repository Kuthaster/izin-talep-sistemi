import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/leave_request_count.dart';
import 'package:izin_talep_sistemi/models/leave_type_count.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class ReportsService {
  final Dio _dio;

  ReportsService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<LeaveRequestCount> getLeaveRequestCount() async {
    final response = await _dio.get('/api/reports/dashboard');
    return LeaveRequestCount.fromJson(response.data);
  }

  Future<List<LeaveTypeCount>> getLeaveRequestCountByLeaveType() async {
    final response = await _dio.get('/api/reports/dashboard/leave-types');

    return (response.data as List)
        .map((item) => LeaveTypeCount.fromJson(item))
        .toList();
  }
}
