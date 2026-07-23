import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/screens/admin_shell_screen.dart';
import 'package:izin_talep_sistemi/screens/login_screen.dart';
import 'package:izin_talep_sistemi/screens/main_screen.dart';

class AuthGate extends ConsumerWidget{
  const AuthGate({super.key});

  @override

  Widget build (BuildContext context, WidgetRef ref){

    final authState = ref.watch(authProvider);

     return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const LoginScreen(),
      data: (user) {
        if (user == null) return const LoginScreen();
        if (user.roleAuthority == RoleAuthority.ADMIN) return const AdminScreen();
        return const MainScreen();
},    );
  }
} 
