import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';

import '/models/leave_request.dart';

final leaveRequestsProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final leaveRequestService = ref.watch(leaveRequestServiceProvider);

  return leaveRequestService.getMyLeaveRequests();
});
