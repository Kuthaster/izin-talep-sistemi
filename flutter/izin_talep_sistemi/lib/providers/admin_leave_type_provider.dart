import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_type.dart';
import 'package:izin_talep_sistemi/providers/leave_type_service_provider.dart';

final adminLeaveTypesProvider = FutureProvider<List<LeaveType>>((ref) async {
  final leaveTypeService = ref.watch(leaveTypeServiceProvider);
  return leaveTypeService.getAllLeaveTypesForAdmin();
});
