import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/ultilities/logout.dart';
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
    final scheme = context.colors;

    return Drawer(
      width: 250,
      child: Container(
        color: scheme.primary,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                color: scheme.tertiary,
                borderRadius: BorderRadiusGeometry.all(Radius.elliptical(1, 6)),
              ),
              child: DefaultTextStyle(
                style: TextStyle(color: scheme.onTertiary),
                child: IconTheme(
                  data: IconThemeData(color: scheme.onTertiary),
                  child: Column(
                    children: [
                      const ProfileAvatarWidget(),
                      Text('${firstName ?? 'AD'} ${lastName ?? 'SOYAD'}'),
                      Text(roleDisplayName ?? 'ROL'),
                      Text(departmentName ?? 'DEPARTMAN'),
                      const Icon(Icons.email, size: 16),
                      const SizedBox(width: 8, height: 1),
                      Text(email ?? 'BULUNAMADI'),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(child: ListView()),

            //button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: scheme.onTertiary)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: FilledButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          enableDrag: true,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const ChangePasswordForm(),
                        );
                      },
                      icon: Icon(Icons.key),
                      label: Text('Şifre Değiştir'),
                    ),
                  ),
                  SizedBox(width: double.infinity, height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => logout(context, ref),
                      icon: Icon(Icons.logout),
                      label: Text('Çıkış Yap'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
