import 'package:izin_talep_sistemi/models/user_create.dart';
import 'package:izin_talep_sistemi/models/user_response.dart';
import 'package:izin_talep_sistemi/models/user_update.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

class UserService {

  Future<List<UserResponse>> getAllUsers() async {
    final response = await DioClient().dio.get('/api/admin/users');
    return (response.data as List)
        .map((item) => UserResponse.fromJson(item))
        .toList();
  }

  Future<UserResponse> createUser(UserCreate dto) async {
    final response = await DioClient().dio.post('/api/admin/users', data:dto.toJson());

    return UserResponse.fromJson(response.data);
   }

   Future<UserResponse> updateUser(int userId, UserUpdate dto) async {
    final response = await DioClient().dio.put('/api/admin/users/$userId', data:dto.toJson());

    return UserResponse.fromJson(response.data);
   }

}