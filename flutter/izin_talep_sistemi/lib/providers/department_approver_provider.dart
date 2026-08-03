import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/department_approver.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/repositories/department_approver_repository.dart';

final departmentApproversRepositoryProvider =
    Provider<DepartmentApproverRepository>((ref) {
      final dio = ref.watch(dioProvider);
      return DepartmentApproverRepository(dio);
    });

final departmentApproversProvider =
    FutureProvider.family<List<DepartmentApprover>, int>((
      ref,
      departmentId,
    ) async {
      final repo = ref.watch(departmentApproversRepositoryProvider);
      return repo.fetch(departmentId);
    });
