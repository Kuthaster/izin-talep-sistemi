import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';
import 'package:izin_talep_sistemi/models/leave_request_filter.dart';

import '/models/leave_request.dart';

final leaveRequestFilterProvider = StateProvider<LeaveRequestFilter>(
  (ref) => const LeaveRequestFilter(),
);

final leaveRequestsProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final leaveRequestService = ref.watch(leaveRequestServiceProvider);
  final filter = ref.watch(leaveRequestFilterProvider);
  return leaveRequestService.getMyLeaveRequests(filter);
});
