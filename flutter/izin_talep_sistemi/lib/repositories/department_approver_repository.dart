import 'package:izin_talep_sistemi/models/department_approver.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class DepartmentApproverRepository {

  final DioClient dioClient;
  DepartmentApproverRepository(this.dioClient);

Future<DepartmentApprover> fetch(int departmentId) async {
  final response = await dioClient.dio.get('/departments/$departmentId/approver');
  return DepartmentApprover.fromJson(response.data);
}
}