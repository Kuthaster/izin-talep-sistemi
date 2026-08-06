import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
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
    final scheme = Theme.of(context).colorScheme;

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
              child: Column(
                children: [
                  ProfileAvatarWidget(),

                  Text(
                    '${firstName ?? 'AD'} ${lastName ?? 'SOYAD'}',
                    style: TextStyle(color: scheme.onPrimary),
                  ),
                  Text(
                    roleDisplayName ?? 'ROL',
                    style: TextStyle(color: scheme.onPrimary),
                  ),
                  Text(
                    departmentName ?? 'DEPARTMAN',
                    style: TextStyle(color: scheme.onPrimary),
                  ),

                  Icon(Icons.email, size: 16, color: scheme.primaryFixed),
                  SizedBox(width: 8, height: 1),
                  Text(
                    email ?? 'BULUNAMADI',
                    style: TextStyle(color: scheme.primaryFixed),
                  ),
                ],
              ),
            ),

            Expanded(child: ListView()),

            //button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: scheme.onPrimary)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: OutlinedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          scheme.tertiary,
                        ),
                        overlayColor: WidgetStateProperty.all(scheme.secondary),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          isDismissible: true,
                          enableDrag: true,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const ChangePasswordForm(),
                        );
                      },
                      icon: Icon(Icons.key, color: scheme.onPrimary),
                      label: Text(
                        'Şifre Değiştir',
                        style: TextStyle(color: scheme.onPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: double.infinity, height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          scheme.tertiary,
                        ),
                        overlayColor: WidgetStateProperty.all(scheme.secondary),
                      ),
                      onPressed: () => logout(context, ref),
                      icon: Icon(Icons.logout, color: scheme.onPrimary),
                      label: Text(
                        'Çıkış Yap',
                        style: TextStyle(color: scheme.onPrimary),
                      ),
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
