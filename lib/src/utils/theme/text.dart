import 'package:flutter/material.dart';

/// Builds textTheme for ZDS.
TextTheme buildZdsTextTheme({
  required Color textColor,
  String? fontFamily,
}) {
  return TextTheme(
    displayLarge: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 30,
      fontWeight: FontWeight.w400,
      height: 36 / 30,
    ),
    displayMedium: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      height: 24 / 20,
    ),
    displaySmall: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 22 / 18,
    ),
    headlineLarge: TextStyle(
      color: textColor,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 22 / 18,
    ),
    headlineMedium: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 20 / 16,
    ),
    headlineSmall: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 18 / 14,
    ),
    titleLarge: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 16 / 12,
    ),
    titleMedium: TextStyle(
      // TextField uses this as input color
      // But be careful as ListTile also does
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 20 / 16,
    ),
    titleSmall: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 18 / 14,
    ),
    bodyLarge: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 20 / 16,
    ),
    bodyMedium: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
    ),
    bodySmall: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18 / 14,
    ),
    labelMedium: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
    ),
    labelSmall: TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
  );
}
