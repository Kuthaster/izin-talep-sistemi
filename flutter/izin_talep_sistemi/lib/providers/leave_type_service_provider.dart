import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/leave_type_service.dart';

final leaveTypeServiceProvider = Provider<LeaveTypeService>((ref) {
  final dio = ref.watch(dioProvider);
  return LeaveTypeService(dio: ref.watch(dioProvider));
});
