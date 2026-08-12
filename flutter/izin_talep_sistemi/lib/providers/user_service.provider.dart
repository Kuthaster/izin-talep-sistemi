import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  ref.watch(dioProvider);
  return UserService(dio: ref.watch(dioProvider));
});
