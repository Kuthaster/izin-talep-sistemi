import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/approver_gap.dart';
import 'package:izin_talep_sistemi/models/departmentless_user.dart';
import 'package:izin_talep_sistemi/models/leave_balance_audit.dart';
import 'package:izin_talep_sistemi/models/leave_request_count.dart';
import 'api_client.dart';

class AdminReportsService {
  final Dio _dio;

  AdminReportsService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<ApproverGap>> getApproverGaps() async {
    final response = await _dio.get('/api/admin/reports/gaps/departments');
    return (response.data as List)
        .map((item) => ApproverGap.fromJson(item))
        .toList();
  }

  Future<LeaveRequestCount> getLeaveRequestCount() async {
    final response = await _dio.get('/api/reports/dashboard');
    return LeaveRequestCount.fromJson(response.data);
  }

  Future<List<DepartmentlessUser>> getDepartmentlessUsers() async {
    final response = await _dio.get('api/reports/gaps/users');
    return (response.data as List)
        .map((item) => DepartmentlessUser.fromJson(item))
        .toList();
  }

  Future<List<LeaveBalanceAudit>> getBalanceAudits() async {
    final response = await _dio.get('/api/admin/reports/balance-audits');
    return (response.data as List)
        .map((item) => LeaveBalanceAudit.fromJson(item))
        .toList();
  }
}
