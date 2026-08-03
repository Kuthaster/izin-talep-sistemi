import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/role_service_provider.dart';

import '../models/role.dart';

final rolesProvider = FutureProvider<List<Role>>((ref) async {
  final roleService = ref.watch(roleServiceProvider);

  return roleService.getAllRoles();
});
