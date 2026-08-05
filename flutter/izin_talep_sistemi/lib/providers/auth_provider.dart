// 1. Removed the stray Dio variable
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:izin_talep_sistemi/models/user_response.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/auth_interceptor.dart';
import 'package:izin_talep_sistemi/services/auth_service.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(dio: dio);
});

class AuthNotifier extends StateNotifier<AsyncValue<UserResponse?>> {
  final AuthService authService;
  final FlutterSecureStorage storage;
  final Dio dio;

  AuthNotifier({
    required this.authService,
    required this.dio,
    required this.storage,
  }) : super(const AsyncValue.loading()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final token = await storage.read(key: authTokenKey);
    if (token == null) {
      state = const AsyncValue.data(null);
      return;
    }
    try {
      state = AsyncValue.data(await _loadCurrentUser());
    } catch (_) {
      await storage.delete(key: authTokenKey);
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await authService.login(email, password);
      state = AsyncValue.data(await _loadCurrentUser());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<UserResponse> _loadCurrentUser() async {
    final response = await dio.get('/api/users/profile');
    return UserResponse.fromJson(response.data);
  }

  Future<void> logout() async {
    await storage.delete(key: authTokenKey);
    state = const AsyncValue.data(null);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserResponse?>>((ref) {
      final authService = ref.watch(authServiceProvider);
      final dio = ref.watch(dioProvider);
      final storage = ref.watch(secureStorageProvider);

      return AuthNotifier(authService: authService, dio: dio, storage: storage);
    });
