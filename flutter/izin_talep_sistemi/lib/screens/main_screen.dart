import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';
import 'package:izin_talep_sistemi/screens/my_requests_screen.dart';
import 'package:izin_talep_sistemi/screens/profile_screen.dart';
import 'package:izin_talep_sistemi/widgets/create_request_form.dart';

import '../providers/auth_provider.dart';


class MainScreen extends ConsumerWidget{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(authProvider).value;
  final firstName = user?.firstName;
  final role = user?.roleDisplayName;
  final roleAuthority = user?.roleAuthority;

  return Scaffold(
    appBar: AppBar(title: const Text('Ana Sayfa')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.deepPurple,
                  child: Text(_getInitials(firstName, user?.lastName), style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(firstName ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text(role ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Card.outlined(
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyRequestsScreen())),
              child: Padding(padding: const EdgeInsets.all(14),
                      child:Text("İzin Talepleri"),
                    ),
              ),
            ),
          if (roleAuthority == RoleAuthority.MANAGER_LEVEL_1 || roleAuthority == RoleAuthority.MANAGER_LEVEL_2 || roleAuthority == RoleAuthority.MANAGER_LEVEL_3)
          Card.outlined(
            child: InkWell(
              /* onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyRequestsForApprovalScreen())),*/ /* %TODO% burayı yapınca yorumu sil */
              child: Padding(padding: const EdgeInsets.all(14),
                      child:Text("Onaylamalar"),
                    ),
              ),
            ),
            ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const CreateRequestForm(),
              );
  },
  child: const Text('Yeni Talep Oluştur'),
)
        ],
      ),
    ),
  );
}

String _getInitials(String? first, String? last) {
  final f = (first != null && first.isNotEmpty) ? first[0] : '';
  final l = (last != null && last.isNotEmpty) ? last[0] : '';
  return (f + l).toUpperCase();
}

}