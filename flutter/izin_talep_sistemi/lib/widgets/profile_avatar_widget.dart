import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';

class ProfileAvatarWidget extends ConsumerWidget {
  const ProfileAvatarWidget({super.key});

  Color _authorityColor(String authority) {
    switch (authority) {
      case 'ADMIN':
        return const Color.fromARGB(255, 120, 8, 218);
      case 'MANAGER_LEVEL_3':
        return const Color.fromARGB(255, 255, 104, 11);
      case 'MANAGER_LEVEL_2':
        return const Color.fromARGB(255, 13, 235, 209);
      case 'MANAGER_LEVEL_1':
        return const Color.fromARGB(255, 15, 86, 228);
      default:
        return const Color.fromARGB(255, 27, 27, 27);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).value;
    final firstName = user!.firstName;
    final lastName = user.lastName;

    return CircleAvatar(
      radius: 25,
      backgroundColor: _authorityColor(user.roleAuthority.name),
      child: Text(
        _getInitials(firstName, lastName),
        style: const TextStyle(
          color: Color.fromARGB(255, 247, 247, 247),
          fontSize: 20,
        ),
      ),
    );
  }
}

String _getInitials(String? first, String? last) {
  final f = (first != null && first.isNotEmpty) ? first[0] : '';
  final l = (last != null && last.isNotEmpty) ? last[0] : '';
  return (f + l).toUpperCase();
}
