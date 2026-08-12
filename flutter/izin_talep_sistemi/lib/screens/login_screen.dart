import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/* import 'package:izin_talep_sistemi/widgets/login_banner_widget.dart'; */
import 'package:izin_talep_sistemi/widgets/login_form_widget.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: LoginFormWidget() /* LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;

          if (isMobile) {
            return const Column(
              children: [LoginBannerWidget(), LoginFormWidget()],
            );
          } else {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [LoginBannerWidget(), LoginFormWidget()],
            );
          }
        },
      ), */,
    );
  }
}
