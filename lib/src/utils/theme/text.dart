import 'package:flutter/material.dart';

// ignore: public_member_api_docs
TextTheme buildZdsTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w400,
      color: base.displayLarge?.color,
      height: 36 / 30,
    ),
    displayMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: base.displayMedium?.color,
      height: 24 / 20,
    ),
    displaySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: base.displaySmall?.color,
      height: 22 / 18,
    ),
    headlineLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: base.headlineMedium?.color,
      height: 22 / 18,
    ),
    headlineMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: base.headlineMedium?.color,
      height: 20 / 16,
    ),
    headlineSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: base.headlineSmall?.color,
      height: 18 / 14,
    ),
    titleLarge: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: base.titleLarge?.color,
      height: 16 / 12,
    ),
    titleMedium: TextStyle(
      // TextField uses this as input color
      // But be careful as ListTile also does
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: base.titleMedium?.color,
      height: 20 / 16,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: base.titleSmall?.color,
      height: 20 / 16,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: base.bodyLarge?.color,
      height: 20 / 16,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: base.bodyMedium?.color,
      height: 18 / 14,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: base.bodySmall?.color,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: base.bodyMedium?.color,
      height: 18 / 14,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: base.bodyMedium?.color,
      height: 16 / 12,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: base.bodySmall?.color,
    ),
  );
}
