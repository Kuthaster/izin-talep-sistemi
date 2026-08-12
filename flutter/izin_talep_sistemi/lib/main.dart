import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/screens/auth_gate.dart';
import 'package:izin_talep_sistemi/theme/theme_data.dart';

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    ProviderScope(child: MyApp()),
  );
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
