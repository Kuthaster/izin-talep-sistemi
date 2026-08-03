import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/models/change_password.dart';
import 'package:izin_talep_sistemi/models/user_create.dart';
import 'package:izin_talep_sistemi/models/user_response.dart';
import 'package:izin_talep_sistemi/models/user_update.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class UserService {
  final Dio _dio;

  UserService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<UserResponse>> getAllUsers() async {
    final response = await _dio.get('/api/admin/users');
    return (response.data as List)
        .map((item) => UserResponse.fromJson(item))
        .toList();
  }

  Future<UserResponse> createUser(UserCreate dto) async {
    final response = await _dio.post('/api/admin/users', data: dto.toJson());

    return UserResponse.fromJson(response.data);
  }

  Future<UserResponse> updateUser(int userId, UserUpdate dto) async {
    final response = await _dio.put(
      '/api/admin/users/$userId',
      data: dto.toJson(),
    );

    return UserResponse.fromJson(response.data);
  }

  Future<void> changePassword(ChangePassword dto) async {
    await _dio.patch('/api/users/profile/password', data: dto.toJson());
  }

  Future<void> deleteUser(int userId) async {
    await _dio.delete('/api/admin/users/$userId');
  }
}
