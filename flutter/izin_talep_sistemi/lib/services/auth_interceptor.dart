import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const authTokenKey = 'auth_token';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get the token from secure storage
    final token = await _secureStorage.read(key: authTokenKey);

    // Add the token to headers if it exists
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle responses here if needed
    return handler.next(response);
  }
}
