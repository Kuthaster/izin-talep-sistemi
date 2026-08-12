import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/screens/auth_gate.dart';
import 'package:izin_talep_sistemi/theme/theme_data.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.s
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'İzin Talep Sistemi',
      theme: lightColorTheme,
      darkTheme: darkColorTheme,

      themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}
