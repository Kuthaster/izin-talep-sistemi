import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/leave_type.dart';
import 'package:izin_talep_sistemi/models/leave_type_create.dart';
import 'package:izin_talep_sistemi/models/leave_type_update.dart';

import 'api_client.dart';

class LeaveTypeService {
  final Dio _dio;

  LeaveTypeService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<LeaveType>> getActiveLeaveTypes() async {
    final response = await _dio.get('/api/leaveTypes');

    return (response.data as List)
        .map((item) => LeaveType.fromJson(item))
        .toList();
  }

  Future<List<LeaveType>> getAllLeaveTypesForAdmin() async {
    final response = await _dio.get('/api/admin/leaveTypes');

    return (response.data as List)
        .map((item) => LeaveType.fromJson(item))
        .toList();
  }

  Future<LeaveType> updateLeaveType(int id, LeaveTypeUpdate dto) async {
    final response = await _dio.put(
      '/api/admin/leaveTypes/$id',
      data: dto.toJson(),
    );

    return LeaveType.fromJson(response.data);
  }

  Future<LeaveType> createLeaveType(LeaveTypeCreate dto) async {
    final response = await _dio.post(
      '/api/admin/leaveTypes',
      data: dto.toJson(),
    );

    return LeaveType.fromJson(response.data);
  }

  Future<void> deleteLeaveType(int typeId) async {
    await _dio.delete('/api/admin/leaveTypes/$typeId');
  }
}
