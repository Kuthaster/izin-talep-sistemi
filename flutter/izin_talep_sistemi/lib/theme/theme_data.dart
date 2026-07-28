import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.kameronTextTheme(),

  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF3C3489),
    brightness: Brightness.light,
    primary: const Color.fromARGB(255, 60, 52, 137),
    secondary: const Color.fromARGB(255, 127, 119, 221),
    surface: const Color.fromARGB(255, 253, 251, 243),
    error: const Color.fromARGB(255, 229, 57, 53),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFDF5),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 104, 11),
    brightness: Brightness.dark,
    primary: const Color.fromARGB(255, 255, 104, 11),
    secondary: const Color(0xFFCC8A5C),
    surface: const Color(0xFF2A2A2E),
    error: const Color(0xFFFF5252),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.black,
  ),
  scaffoldBackgroundColor: const Color(0xFF0D0D14),
);
