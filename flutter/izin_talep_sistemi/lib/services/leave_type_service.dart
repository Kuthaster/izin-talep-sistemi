import 'package:izin_talep_sistemi/models/leave_type.dart';
import 'package:izin_talep_sistemi/models/leave_type_create.dart';
import 'package:izin_talep_sistemi/models/leave_type_update.dart';

import 'api_client.dart';

class LeaveTypesService {
  Future<List<LeaveType>> getActiveLeaveTypes() async {
        final response = await DioClient().dio.get('/api/leaveTypes');
        
        return (response.data as List)
          .map((item) => LeaveType.fromJson(item))
          .toList();
  }

   Future<List<LeaveType>> getAllLeaveTypesForAdmin() async {
        final response = await DioClient().dio.get('/api/admin/leaveTypes');
        
        return (response.data as List)
          .map((item) => LeaveType.fromJson(item))
          .toList();
  }

  Future <LeaveType> updateLeaveType(int id, LeaveTypeUpdate dto) async {
        final response = await DioClient().dio.put('/api/admin/leaveTypes/$id', data: dto.toJson());
        
        return LeaveType.fromJson(response.data);
  }

  Future <LeaveType> createLeaveType(LeaveTypeCreate dto) async {
        final response = await DioClient().dio.post('/api/admin/leaveTypes', data:dto.toJson());
        
        return LeaveType.fromJson(response.data);
  }
}