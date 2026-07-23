import 'package:izin_talep_sistemi/models/department.dart';
import 'package:izin_talep_sistemi/models/department_update.dart';
import 'api_client.dart';

class DepartmentService {

  Future<List<Department>> getAllDepartments() async {
        final response = await DioClient().dio.get('/api/departments');
        
        return (response.data as List)
          .map((item) => Department.fromJson(item))
          .toList();
  }

  Future<List<Department>> getAllDepartmentsForAdmin() async {
        final response = await DioClient().dio.get('/api/admin/departments');
        
        return (response.data as List)
          .map((item) => Department.fromJson(item))
          .toList();
  }

  Future <Department> createDepartment(Department dto) async {
        final response = await DioClient().dio.post('/api/admin/departments', data:dto.toJson());
        
        return Department.fromJson(response.data);
  }

  Future <Department> updateDepartment(int id, DepartmentUpdate dto) async {
        final response = await DioClient().dio.put('/api/admin/departments/$id', data: dto.toJson());
        
        return Department.fromJson(response.data);
  }


}