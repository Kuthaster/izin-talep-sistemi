import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/department.dart';
import 'package:izin_talep_sistemi/services/department_service.dart';

final adminDepartmentsProvider = FutureProvider<List<Department>>((ref) async {
  return DepartmentService().getAllDepartmentsForAdmin();
});