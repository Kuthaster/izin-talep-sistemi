import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/leave_request_service.dart';

final leaveRequestServiceProvider = Provider<LeaveRequestService>((ref) {
  final dio = ref.watch(dioProvider);
  return LeaveRequestService(dio: ref.watch(dioProvider));
});
