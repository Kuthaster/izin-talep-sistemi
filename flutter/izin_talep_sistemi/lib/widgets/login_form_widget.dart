import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class LoginFormWidget extends ConsumerStatefulWidget {
  const LoginFormWidget({super.key});

  @override
  ConsumerState<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends ConsumerState<LoginFormWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 32.0),
        color: context.colors.inverseSurface,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Giriş yap',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onInverseSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onInverseSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: context.colors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'adsoyad@yourcompany.com',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: context.colors.onSurface,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 0.5),
                      ),
                      filled: true,
                      fillColor: context.colors.surface,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Şifre',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onInverseSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    style: TextStyle(color: context.colors.onSurface),
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Şifrenizi girin',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: context.colors.onSurface,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 0.5),
                      ),
                      filled: true,
                      fillColor: context.colors.surface,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: _obscurePassword
                            ? const Icon(Icons.visibility_off_sharp)
                            : const Icon(Icons.visibility_sharp),
                        tooltip: 'Şifre görünürlüğünü aç/kapa',
                      ),
                    ),
                  ),
                  if (authState.hasError) ...[
                    const SizedBox(height: 12),
                    Text(
                      authState.error.toString(),
                      style: TextStyle(
                        color: context.colors.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              ref
                                  .read(authProvider.notifier)
                                  .login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                            },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      child: authState.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondaryFixedDim,
                              ),
                            )
                          : const Text(
                              'Giriş yap',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showForgotPasswordDialog(context, ref),
                    child: Text('Şifremi Unuttum'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showForgotPasswordDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final controller = TextEditingController();
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Şifremi Unuttum'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'E-posta adresiniz'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Vazgeç'),
        ),
        FilledButton(
          onPressed: () async {
            await ref
                .read(authServiceProvider)
                .forgotPassword(controller.text.trim());
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Talebiniz alındı. Lütfen yöneticinizle iletişime geçin.',
                  ),
                ),
              );
            }
          },
          child: const Text('Gönder'),
        ),
      ],
    ),
  );
}
