import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/widgets/change_password_form.dart';
import 'package:izin_talep_sistemi/widgets/profile_avatar_widget.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final firstName = user?.firstName;
    final lastName = user?.lastName;
    final email = user?.email;
    final departmentName = user?.departmentName;
    final roleDisplayName = user?.roleDisplayName;
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      width: 250,
      backgroundColor: scheme.primary,
      child: Column(
        children: [
          Card(
            color: Theme.of(context).colorScheme.primary,
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                ProfileAvatarWidget(),

                Text(
                  '${firstName ?? 'AD'} ${lastName ?? 'SOYAD'}',
                  style: TextStyle(color: scheme.onPrimary),
                ),
                Text(roleDisplayName ?? 'ROL'),
                Text(departmentName ?? 'DEPARTMAN'),

                Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(width: 8),
                Text(
                  email ?? 'BULUNAMADI',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: ListView()),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(160, 40),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const ChangePasswordForm(),
              );
            },
            child: Text("ŞİFREYİ DEĞİŞTİR"), //TODO BURAYI STILIZE ET
          ),

          //button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(scheme.tertiary),
                  overlayColor: WidgetStateProperty.all(scheme.secondary),
                ),
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  'Çıkış Yap',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
