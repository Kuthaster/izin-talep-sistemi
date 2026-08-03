import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/role.dart';
import 'package:izin_talep_sistemi/models/role_create.dart';
import 'package:izin_talep_sistemi/models/role_update.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class RoleService {
  final Dio _dio;

  RoleService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<Role>> getAllRoles() async {
    final response = await _dio.get('/api/roles');
    return (response.data as List).map((item) => Role.fromJson(item)).toList();
  }

  Future<Role> createRole(RoleCreate dto) async {
    final response = await _dio.post('/api/roles', data: dto.toJson());

    return Role.fromJson(response.data);
  }

  Future<Role> updateRole(int roleId, RoleUpdate dto) async {
    final response = await _dio.put('/api/roles/$roleId', data: dto.toJson());

    return Role.fromJson(response.data);
  }

  Future<void> deleteRole(int roleId) async {
    await _dio.delete('/api/admin/roles/$roleId');
  }
}
