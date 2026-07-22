import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/services/leave_request_service.dart';
import '/models/leave_request.dart';

final leaveRequestsProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  return LeaveRequestService().getMyLeaveRequests();
});