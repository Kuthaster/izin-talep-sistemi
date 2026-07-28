import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/palet/palet_gecici.dart';

import '../theme/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: const PaletGecici(),
    );
  }
}
