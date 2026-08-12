import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/leave_balance.dart';
import 'package:izin_talep_sistemi/models/leave_balance_update.dart';
import 'api_client.dart';

class LeaveBalanceService {
  final Dio _dio;

  LeaveBalanceService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<LeaveBalance>> getMyBalances() async {
    final response = await _dio.get('/api/leaveBalances/mine');
    return (response.data as List)
        .map((item) => LeaveBalance.fromJson(item))
        .toList();
  }

  Future<List<LeaveBalance>> getUserBalances({
    int? userId,
    int? year,
    int? leaveTypeId,
  }) async {
    final response = await _dio.get(
      '/api/admin/leaveBalances',
      queryParameters: {
        'userId': ?userId,
        'year': ?year,
        'leaveTypeId': ?leaveTypeId,
      },
    );
    return (response.data as List)
        .map((item) => LeaveBalance.fromJson(item))
        .toList();
  }

  Future<LeaveBalance> updateBalance(
    int balanceId,
    LeaveBalanceUpdate dto,
  ) async {
    final response = await _dio.put(
      '/api/admin/leaveBalances/$balanceId',
      data: dto.toJson(),
    );
    return LeaveBalance.fromJson(response.data);
  }
}
