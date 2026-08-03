import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/department_service.dart';

final departmentServiceProvider = Provider<DepartmentService>((ref) {
  final dio = ref.watch(dioProvider);
  return DepartmentService(dio: ref.watch(dioProvider));
});
