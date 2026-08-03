import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/department.dart';
import 'package:izin_talep_sistemi/models/department_update.dart';
import 'api_client.dart';

class DepartmentService {
  final Dio _dio;

  DepartmentService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<Department>> getAllDepartments() async {
    final response = await _dio.get('/api/departments');

    return (response.data as List)
        .map((item) => Department.fromJson(item))
        .toList();
  }

  Future<List<Department>> getAllDepartmentsForAdmin() async {
    final response = await _dio.get('/api/admin/departments');

    return (response.data as List)
        .map((item) => Department.fromJson(item))
        .toList();
  }

  Future<Department> createDepartment(DepartmentUpdate dto) async {
    final response = await _dio.post(
      '/api/admin/departments',
      data: dto.toJson(),
    );

    return Department.fromJson(response.data);
  }

  Future<void> deleteDepartment(int departmentId) async {
    await _dio.delete('/api/admin/departments/$departmentId');
  }

  Future<Department> updateDepartment(int id, DepartmentUpdate dto) async {
    final response = await _dio.put(
      '/api/admin/departments/$id',
      data: dto.toJson(),
    );

    return Department.fromJson(response.data);
  }
}
