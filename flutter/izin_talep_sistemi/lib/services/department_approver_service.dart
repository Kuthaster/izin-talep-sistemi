import 'package:izin_talep_sistemi/models/department_approver.dart';
import 'package:izin_talep_sistemi/models/department_approver_assign.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class DepartmentApproverService {

   Future<List<DepartmentApprover>> getApproversForDepartment(int departmentId) async {
        final response = await DioClient().dio.get('/api/admin/departmentApprovers/department/$departmentId');
        
        return (response.data as List)
          .map((item) => DepartmentApprover.fromJson(item))
          .toList();
  }

  Future<DepartmentApprover> assignApprover(DepartmentApproverAssign dto) async {
        final response = await DioClient().dio.post('/api/admin/departmentApprovers', data:dto.toJson());
        
        return (response.data);

  }

  Future<void> removeApprover(int departmentId, int level) async {
    await DioClient().dio.delete('/api/admin/departmentApprovers/department/$departmentId/level/$level');
  }

  
}