import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/role_service.dart';
import '../models/role.dart';

final rolesProvider = FutureProvider<List<Role>>((ref) async {
  return RoleService().getAllRoles();
});