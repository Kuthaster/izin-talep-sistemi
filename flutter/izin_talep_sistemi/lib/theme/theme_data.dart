import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:izin_talep_sistemi/theme/compact_dialog_date_range_picker_theme.dart';

final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: const Color(0xFF4C606B),
  onPrimary: Color.fromARGB(255, 212, 237, 250),
  primaryFixed: const Color(0xFFD7E3E9),
  primaryFixedDim: const Color(0xFFA8C0CA),
  onPrimaryFixed: const Color(0xFF10222A),
  onPrimaryFixedVariant: const Color(0xFF34474F),
  primaryContainer: const Color(0xFFD7E3E9),
  onPrimaryContainer: const Color(0xFF34474F),

  secondary: const Color(0xFF6D435A),
  onSecondary: Color.fromARGB(255, 81, 85, 87),
  secondaryContainer: const Color(0xFFF0DAE5),
  onSecondaryContainer: const Color(0xFF5C3D4C),
  secondaryFixed: const Color(0xFFF0DAE5),
  secondaryFixedDim: const Color(0xFFD3A0B9),
  onSecondaryFixed: const Color(0xFF2B1620),
  onSecondaryFixedVariant: const Color(0xFF5C3D4C),

  tertiary: const Color(0XFFC18C5D),
  onTertiary: const Color.fromARGB(255, 75, 46, 21),
  tertiaryContainer: const Color(0xFFF3DCC4),
  onTertiaryContainer: const Color(0xFF6B4423),
  tertiaryFixed: const Color(0xFFF3DCC4),
  tertiaryFixedDim: const Color(0xFFDBB78D),
  onTertiaryFixed: const Color(0xFF3D2612),
  onTertiaryFixedVariant: const Color(0xFF6B4423),

  surface: const Color(0XFFFDFFFC),
  onSurface: const Color(0XFF1A1C23),
  inverseSurface: const Color(0XFF1A1C23),
  onInverseSurface: const Color(0XfFF4F4F9),

  surfaceDim: const Color(0xFFDBD9DD),
  surfaceBright: const Color(0xFFFDFFFC),

  surfaceContainerLowest: const Color(0xFFFFFFFF),
  surfaceContainerLow: const Color(0xFFF7F6FA),
  surfaceContainer: const Color(0xFFF1F0F4),
  surfaceContainerHigh: const Color(0xFFEBEAEE),
  surfaceContainerHighest: const Color(0xFFE5E4E9),

  onSurfaceVariant: const Color(0xFF44474C),

  outline: const Color(0xFF74777B),
  outlineVariant: const Color(0xFFC4C6CC),

  error: const Color(0xFFFF0000),
  onError: Colors.black,
  errorContainer: const Color(0xFFFFDAD6),
  onErrorContainer: const Color(0xFF410002),

  scrim: Colors.black,
  shadow: Colors.black,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: const Color(0xFFA8C0CA),
  onPrimary: const Color(0xFF10222A),
  primaryContainer: const Color(0xFF34474F),
  onPrimaryContainer: const Color(0xFFD7E3E9),
  primaryFixed: const Color(0xFFD7E3E9),
  primaryFixedDim: const Color(0xFFA8C0CA),
  onPrimaryFixed: const Color(0xFF10222A),
  onPrimaryFixedVariant: const Color(0xFF34474F),

  tertiary: const Color(0xFFDBB78D),
  onTertiary: const Color(0xFF3D2612),
  tertiaryContainer: const Color(0xFF6B4423),
  onTertiaryContainer: const Color(0xFFF3DCC4),
  tertiaryFixed: const Color(0xFFF3DCC4),
  tertiaryFixedDim: const Color(0xFFDBB78D),
  onTertiaryFixed: const Color(0xFF3D2612),
  onTertiaryFixedVariant: const Color(0xFF6B4423),

  secondary: const Color(0xFFD3A0B9),
  onSecondary: const Color(0xFF2B1620),
  secondaryContainer: const Color(0xFF5C3D4C),
  onSecondaryContainer: const Color(0xFFF0DAE5),
  secondaryFixed: const Color(0xFFF0DAE5),
  secondaryFixedDim: const Color(0xFFD3A0B9),
  onSecondaryFixed: const Color(0xFF2B1620),
  onSecondaryFixedVariant: const Color(0xFF5C3D4C),

  surface: const Color(0xFF121316),
  onSurface: const Color(0xFFE2E2E9),

  surfaceDim: const Color(0xFF121316),
  surfaceBright: const Color(0xFF383A40),

  surfaceContainerLowest: const Color(0xFF0C0E13),
  surfaceContainerLow: const Color(0xFF1A1C23),
  surfaceContainer: const Color(0xFF1E2027),
  surfaceContainerHigh: const Color(0xFF292B32),
  surfaceContainerHighest: const Color(0xFF34363D),

  onSurfaceVariant: const Color(0xFFC4C6CC),

  inverseSurface: const Color(0xFFE2E2E9),
  onInverseSurface: const Color(0xFF1A1C23),

  outline: const Color(0xFF8E9199),
  outlineVariant: const Color(0xFF44474C),

  error: const Color(0xFFFFB4AB),
  onError: const Color(0xFF690005),
  errorContainer: const Color(0xFF93000A),
  onErrorContainer: const Color(0xFFFFDAD6),

  scrim: Colors.black,
  shadow: Colors.black,
);

final ThemeData darkColorTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: Color(0xff353535),
  textTheme: GoogleFonts.kameronTextTheme().apply(
    bodyColor: darkColorScheme.onSurface,
    displayColor: darkColorScheme.onSurface,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: darkColorScheme.surface,
  ),
  extensions: [
    CompactDialogDateRangePickerTheme(
      headerTextColor: darkColorScheme.primary,
      monthLabelColor: darkColorScheme.tertiary,
      weekdayLabelColor: darkColorScheme.secondaryFixedDim,
      dayTextColor: darkColorScheme.tertiary,
      disabledDayTextColor: darkColorScheme.tertiaryFixedDim,
      selectedDayBackground: darkColorScheme.secondary,
      selectedDayTextColor: darkColorScheme.onPrimary,
      inRangeBackground: darkColorScheme.primaryFixed.withValues(alpha: 0.5),
      dialogBackground: darkColorScheme.surface,
    ),
  ],
);

final ThemeData lightColorTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: Color(0xffF5EFED),
  textTheme: GoogleFonts.kameronTextTheme().apply(
    bodyColor: lightColorScheme.onSurface,
    displayColor: lightColorScheme.onSurface,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: lightColorScheme.surface,
  ),
  extensions: [
    CompactDialogDateRangePickerTheme(
      headerTextColor: lightColorScheme.primary,
      monthLabelColor: lightColorScheme.tertiary,
      weekdayLabelColor: lightColorScheme.secondaryFixedDim,
      dayTextColor: lightColorScheme.tertiary,
      disabledDayTextColor: lightColorScheme.tertiaryFixedDim,
      selectedDayBackground: lightColorScheme.secondary,
      selectedDayTextColor: lightColorScheme.onPrimary,
      inRangeBackground: lightColorScheme.primaryFixed.withValues(alpha: 0.5),
      dialogBackground: lightColorScheme.surface,
    ),
  ],
);
