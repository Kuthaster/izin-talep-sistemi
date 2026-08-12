import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/widgets/change_password_form.dart';

class PasswordAlert extends ConsumerWidget {
  final Widget child;
  const PasswordAlert({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    if (user != null && user.mustChangePassword) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Şifrenizi Değiştirin'),
              content: const Text(
                'Hesabınızın güvenliği için mevcut şifrenizi değiştirmeniz gerekiyor.',
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      builder: (context) => const ChangePasswordForm(),
                    );
                  },
                  child: const Text('Şifreyi Değiştir'),
                ),
              ],
            ),
          ),
        );
      });
    }

    return child;
  }
}
