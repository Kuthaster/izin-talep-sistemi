// providers/auth_provider.dart
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/auth_interceptor.dart';
import '../models/user_response.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserResponse?>> {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthNotifier() : super(const AsyncValue.loading()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final token = await _storage.read(key: authTokenKey);
    if (token == null) {
      state = const AsyncValue.data(null);
      return;
    }
    try {
      state = AsyncValue.data(await _loadCurrentUser());
    } catch (_) {
      await _storage.delete(key: authTokenKey);
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authService.login(email, password);
      state = AsyncValue.data(await _loadCurrentUser());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  Future<UserResponse> _loadCurrentUser() async {
    final response = await DioClient().dio.get('/api/users/profile');
    return(UserResponse.fromJson(response.data));

  }
    Future<void> logout() async {
      await _storage.delete(key: authTokenKey);
      state = const AsyncValue.data(null);
    }
}
  final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserResponse?>>(
    (ref) => AuthNotifier(),
);
