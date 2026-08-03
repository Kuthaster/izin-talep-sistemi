import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/department.dart';
import 'package:izin_talep_sistemi/providers/department_service_provider.dart';

final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  final departmentService = ref.watch(departmentServiceProvider);

  return departmentService.getAllDepartments();
});
