import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/screens/login_screen.dart';
import 'package:izin_talep_sistemi/screens/my_requests_screen.dart';

class AuthGate extends ConsumerWidget{
  const AuthGate({super.key});

  @override

  Widget build (BuildContext context, WidgetRef ref){

    final authState = ref.watch(authProvider);

     return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const LoginScreen(),
      data: (user) => user == null ? const LoginScreen() : const MyRequestsScreen(),
    );
  }
} 
