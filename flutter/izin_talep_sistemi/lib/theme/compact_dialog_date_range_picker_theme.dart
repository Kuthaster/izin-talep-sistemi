// lib/theme/compact_date_range_picker_theme.dart
import 'package:flutter/material.dart';

@immutable
class CompactDialogDateRangePickerTheme
    extends ThemeExtension<CompactDialogDateRangePickerTheme> {
  final Color headerTextColor;
  final Color monthLabelColor;
  final Color weekdayLabelColor;
  final Color dayTextColor;
  final Color disabledDayTextColor;
  final Color selectedDayBackground;
  final Color selectedDayTextColor;
  final Color inRangeBackground;
  final Color dialogBackground;

  const CompactDialogDateRangePickerTheme({
    required this.headerTextColor,
    required this.monthLabelColor,
    required this.weekdayLabelColor,
    required this.dayTextColor,
    required this.disabledDayTextColor,
    required this.selectedDayBackground,
    required this.selectedDayTextColor,
    required this.inRangeBackground,
    required this.dialogBackground,
  });

  @override
  CompactDialogDateRangePickerTheme copyWith({
    Color? headerTextColor,
    Color? monthLabelColor,
    Color? weekdayLabelColor,
    Color? dayTextColor,
    Color? disabledDayTextColor,
    Color? selectedDayBackground,
    Color? selectedDayTextColor,
    Color? inRangeBackground,
    Color? dialogBackground,
  }) {
    return CompactDialogDateRangePickerTheme(
      headerTextColor: headerTextColor ?? this.headerTextColor,
      monthLabelColor: monthLabelColor ?? this.monthLabelColor,
      weekdayLabelColor: weekdayLabelColor ?? this.weekdayLabelColor,
      dayTextColor: dayTextColor ?? this.dayTextColor,
      disabledDayTextColor: disabledDayTextColor ?? this.disabledDayTextColor,
      selectedDayBackground:
          selectedDayBackground ?? this.selectedDayBackground,
      selectedDayTextColor: selectedDayTextColor ?? this.selectedDayTextColor,
      inRangeBackground: inRangeBackground ?? this.inRangeBackground,
      dialogBackground: dialogBackground ?? this.dialogBackground,
    );
  }

  @override
  CompactDialogDateRangePickerTheme lerp(
    CompactDialogDateRangePickerTheme? other,
    double t,
  ) {
    if (other is! CompactDialogDateRangePickerTheme) return this;
    return CompactDialogDateRangePickerTheme(
      headerTextColor: Color.lerp(headerTextColor, other.headerTextColor, t)!,
      monthLabelColor: Color.lerp(monthLabelColor, other.monthLabelColor, t)!,
      weekdayLabelColor: Color.lerp(
        weekdayLabelColor,
        other.weekdayLabelColor,
        t,
      )!,
      dayTextColor: Color.lerp(dayTextColor, other.dayTextColor, t)!,
      disabledDayTextColor: Color.lerp(
        disabledDayTextColor,
        other.disabledDayTextColor,
        t,
      )!,
      selectedDayBackground: Color.lerp(
        selectedDayBackground,
        other.selectedDayBackground,
        t,
      )!,
      selectedDayTextColor: Color.lerp(
        selectedDayTextColor,
        other.selectedDayTextColor,
        t,
      )!,
      inRangeBackground: Color.lerp(
        inRangeBackground,
        other.inRangeBackground,
        t,
      )!,
      dialogBackground: Color.lerp(
        dialogBackground,
        other.dialogBackground,
        t,
      )!,
    );
  }
}
