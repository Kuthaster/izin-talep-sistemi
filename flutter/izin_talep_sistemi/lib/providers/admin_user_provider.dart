import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/user_response.dart';
import 'package:izin_talep_sistemi/providers/user_service.provider.dart';

final adminUsersProvider = FutureProvider<List<UserResponse>>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getAllUsers();
});
