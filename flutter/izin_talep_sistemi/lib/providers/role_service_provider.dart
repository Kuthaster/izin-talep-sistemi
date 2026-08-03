import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/role_service.dart';

final roleServiceProvider = Provider<RoleService>((ref) {
  final dio = ref.watch(dioProvider);
  return RoleService(dio: ref.watch(dioProvider));
});
