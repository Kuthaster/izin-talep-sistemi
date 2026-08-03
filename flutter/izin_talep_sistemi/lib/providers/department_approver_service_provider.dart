import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/department_approver_service.dart';

final departmentApproverServiceProvider = Provider<DepartmentApproverService>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return DepartmentApproverService(dio: ref.watch(dioProvider));
});
