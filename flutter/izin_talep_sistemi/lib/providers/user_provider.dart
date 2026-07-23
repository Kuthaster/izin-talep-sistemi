import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/user_response.dart';
import 'package:izin_talep_sistemi/services/user_service.dart';

final usersProvider = FutureProvider<List<UserResponse>>((ref) async {
  return UserService().getAllUsers();
});