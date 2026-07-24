import 'package:izin_talep_sistemi/models/department_approver.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class DepartmentApproverRepository {
  final DioClient dioClient;
  DepartmentApproverRepository(this.dioClient);

  Future<List<DepartmentApprover>> fetch(int departmentId) async {
    final response = await dioClient.dio.get(
      '/api/admin/departmentApprovers/department/$departmentId',
    );

    final data = response.data as List;
    return data
        .map((e) => DepartmentApprover.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
