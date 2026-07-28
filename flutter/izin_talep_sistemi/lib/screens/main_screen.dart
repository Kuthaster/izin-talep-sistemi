import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';
import 'package:izin_talep_sistemi/screens/approvals_screen.dart';
import 'package:izin_talep_sistemi/screens/profile_screen.dart';
import 'package:izin_talep_sistemi/screens/requests_screen.dart';
import 'package:izin_talep_sistemi/widgets/create_request_form.dart';
import 'package:izin_talep_sistemi/widgets/profile_avatar_widget.dart';

import '../providers/auth_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final roleAuthority = user?.roleAuthority;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ), //TODO BURAYI BIR SIDE PANEL DRAWERLA DEĞİŞTİR
            ),
            icon: ProfileAvatarWidget(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card.outlined(
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RequestsScreen()),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text("İzin Talepleri"),
                ),
              ),
            ),
            if (roleAuthority == RoleAuthority.MANAGER_LEVEL_1 ||
                roleAuthority == RoleAuthority.MANAGER_LEVEL_2 ||
                roleAuthority == RoleAuthority.MANAGER_LEVEL_3)
              Card.outlined(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ApprovalsScreen()),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text("Onaylamalar"),
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
            ),
          ],
        ),
      ),
    );
  }
}
