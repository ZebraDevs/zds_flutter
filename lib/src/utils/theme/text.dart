import 'package:flutter/material.dart';

/// Builds textTheme for ZDS.
TextTheme buildZdsTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w400,
      color: base.displayLarge?.color,
      height: 36 / 30,
      fontFamily: base.displayLarge?.fontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: base.displayMedium?.color,
      height: 24 / 20,
      fontFamily: base.displayMedium?.fontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: base.displaySmall?.color,
      height: 22 / 18,
      fontFamily: base.displaySmall?.fontFamily,
    ),
    headlineLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: base.headlineMedium?.color,
      fontFamily: base.headlineLarge?.fontFamily,
      height: 22 / 18,
    ),
    headlineMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: base.headlineMedium?.color,
      height: 20 / 16,
      fontFamily: base.headlineMedium?.fontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: base.headlineSmall?.color,
      height: 18 / 14,
      fontFamily: base.headlineSmall?.fontFamily,
    ),
    titleLarge: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: base.titleLarge?.color,
      height: 16 / 12,
      fontFamily: base.titleLarge?.fontFamily,
    ),
    titleMedium: TextStyle(
      // TextField uses this as input color
      // But be careful as ListTile also does
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: base.titleMedium?.color,
      height: 20 / 16,
      fontFamily: base.titleMedium?.fontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: base.titleSmall?.color,
      height: 18 / 14,
      fontFamily: base.titleSmall?.fontFamily,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: base.bodyLarge?.color,
      height: 20 / 16,
      fontFamily: base.bodyLarge?.fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: base.bodyMedium?.color,
      fontFamily: base.displayLarge?.fontFamily,
      height: 18 / 14,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: base.displayLarge?.fontFamily,
      color: base.bodySmall?.color,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: base.bodyMedium?.color,
      height: 18 / 14,
      fontFamily: base.labelLarge?.fontFamily,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: base.bodyMedium?.color,
      height: 16 / 12,
      fontFamily: base.labelMedium?.fontFamily,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: base.bodySmall?.color,
      fontFamily: base.labelSmall?.fontFamily,
    ),
  );
}
