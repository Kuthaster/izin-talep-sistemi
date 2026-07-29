import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme darkCs = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 104, 11),
  brightness: Brightness.dark,
  primary: const Color.fromARGB(255, 255, 104, 11),
  secondary: const Color(0xFFCC8A5C),
  tertiary: const Color.fromARGB(255, 206, 2, 224),
  surface: const Color(0xFF2A2A2E),
  error: const Color(0xFFFF5252),
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  onError: Colors.black,
);

final ColorScheme cs1 = ColorScheme.fromSeed(
  seedColor: const Color(0xFF4C606B),
  brightness: Brightness.dark,
  primary: const Color(0xFF4C606B),
  secondary: const Color(0xffA07178),
  tertiary: const Color(0XffC18C5D),
  onTertiary: const Color.fromARGB(255, 75, 46, 21),
  tertiaryContainer: const Color.fromARGB(255, 184, 109, 43),
  surface: const Color(0XfFFDFFFC),
  inverseSurface: const Color(0XFF1A1C23),
  onInverseSurface: const Color(0XfFF4F4F9),
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Color(0xFFC1CFD6),
  onSurface: Colors.black,
  onError: Colors.black,
);

final ColorScheme lightCs = ColorScheme.fromSeed(
  seedColor: const Color(0xFF3C3489),
  brightness: Brightness.light,
  primary: const Color.fromARGB(255, 60, 52, 137),
  secondary: const Color.fromARGB(255, 7, 212, 202),
  tertiary: const Color.fromARGB(255, 5, 57, 110),
  surface: const Color.fromARGB(255, 253, 251, 243),
  error: const Color.fromARGB(255, 229, 57, 53),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  onError: Colors.white,
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,

  brightness: Brightness.light,
  colorScheme: lightCs,
  scaffoldBackgroundColor: const Color(0xFFFFFDF5),
  textTheme: GoogleFonts.kameronTextTheme().apply(
    bodyColor: lightCs.onSurface,
    displayColor: lightCs.onSurface,
  ),
);

final ThemeData theme1 = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: cs1,
  scaffoldBackgroundColor: Color(0xffF5EFED),
  textTheme: GoogleFonts.kameronTextTheme().apply(
    bodyColor: cs1.onSurface,
    displayColor: cs1.onSurface,
  ),
);
