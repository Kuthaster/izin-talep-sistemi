import 'package:izin_talep_sistemi/models/leave_request_approval.dart';
import 'package:izin_talep_sistemi/models/leave_request_count.dart';
import 'package:izin_talep_sistemi/models/leave_request_create.dart';
import 'package:izin_talep_sistemi/models/leave_request_decision.dart';

import 'api_client.dart';
import '../models/leave_request.dart';

class LeaveRequestService {
  Future<List<LeaveRequest>> getMyRequests() async {
    final response = await DioClient().dio.get('/api/leaveRequests/mine');
    return (response.data as List)
        .map((item) => LeaveRequest.fromJson(item))
        .toList();
  }
  Future<LeaveRequestCount> getLeaveRequestCount() async {
    final response = await DioClient().dio.get('/api/dashboard');
    return LeaveRequestCount.fromJson(response.data);
    }

  Future<List<LeaveRequest>> getLeaveRequestsForApproval() async {
    final response = await DioClient().dio.get('/api/leaveRequests/forApproval');
    
    return (response.data as List)
        .map((item) => LeaveRequest.fromJson(item))
        .toList();  
   }

   Future<LeaveRequest> createLeaveRequest(LeaveRequestCreate dto) async {
    final response = await DioClient().dio.post('/api/leaveRequests', data:dto.toJson());
    
    return LeaveRequest.fromJson(response.data);
   }

   Future<LeaveRequest> decide(int requestId, LeaveRequestDecision dto) async {
  final response = await DioClient().dio.patch(
    '/api/leaveRequests/forApproval/$requestId',
    data: dto.toJson(),
  );
  return LeaveRequest.fromJson(response.data);
}


}