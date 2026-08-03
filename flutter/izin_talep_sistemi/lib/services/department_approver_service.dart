import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/department_approver.dart';
import 'package:izin_talep_sistemi/models/department_approver_assign.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class DepartmentApproverService {
  final Dio _dio;

  DepartmentApproverService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<DepartmentApprover>> getApproversForDepartment(
    int departmentId,
  ) async {
    final response = await _dio.get(
      '/api/admin/departmentApprovers/department/$departmentId',
    );

    return (response.data as List)
        .map((item) => DepartmentApprover.fromJson(item))
        .toList();
  }

  Future<DepartmentApprover> assignApprover(
    DepartmentApproverAssign dto,
  ) async {
    final response = await _dio.post(
      '/api/admin/departmentApprovers',
      data: dto.toJson(),
    );

    return DepartmentApprover.fromJson(response.data);
  }

  Future<void> removeApprover(int departmentId, int level) async {
    await _dio.delete(
      '/api/admin/departmentApprovers/department/$departmentId/level/$level',
    );
  }
}
