import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/departmentless_user.dart';
import 'package:izin_talep_sistemi/providers/admin_reports_service_provider.dart';

final departmentlessUsersProvider = FutureProvider<List<DepartmentlessUser>>((
  ref,
) async {
  final service = ref.watch(adminReportsServiceProvider);
  return service.getDepartmentlessUsers();
});
