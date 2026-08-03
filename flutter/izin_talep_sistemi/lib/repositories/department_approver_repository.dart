import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/department_approver.dart';

class DepartmentApproverRepository {
  final Dio _dio;

  DepartmentApproverRepository(this._dio);

  Future<List<DepartmentApprover>> fetch(int departmentId) async {
    final response = await _dio.get(
      '/api/admin/departmentApprovers/department/$departmentId',
    );

    final data = response.data as List;
    return data
        .map((e) => DepartmentApprover.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
