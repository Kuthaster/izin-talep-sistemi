import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_type.dart';
import 'package:izin_talep_sistemi/services/leave_type_service.dart';

final adminLeaveTypesProvider = FutureProvider<List<LeaveType>>((ref) async {
  return LeaveTypesService().getAllLeaveTypesForAdmin();
});