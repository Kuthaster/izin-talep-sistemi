import 'package:dio/dio.dart';
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import 'package:izin_talep_sistemi/exceptions/api_exception.dart';
import 'package:izin_talep_sistemi/models/login_response.dart';

import 'api_client.dart';
import 'auth_interceptor.dart';

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio}) : _dio = dio ?? dioClient;

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      await _storage.write(key: authTokenKey, value: loginResponse.token);
      return loginResponse;
    } on DioException catch (e) {
      throw ApiException('E-posta veya şifre hatalı', e.response?.statusCode);
    }
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post('/api/auth/forgot-password', data: {'email': email});
  }
}
