import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// This is an extension method on [ZetaColorScheme] which is used to customize the [DatePickerThemeData].
extension ZetaDatePickerTheme on ZetaColorScheme {
  /// This function returns a [DatePickerThemeData] customized with properties
  /// taken from the [ZetaColorScheme].
  ///
  /// Returns:
  ///   A [DatePickerThemeData] with the applied properties.
  DatePickerThemeData datePickerTheme(AppBarTheme appBarTheme) {
    /// Returns a DatePickerThemeData after assigning properties like
    /// thickness, space and color.
    return DatePickerThemeData(
      headerBackgroundColor: appBarTheme.backgroundColor,
      headerForegroundColor: appBarTheme.foregroundColor,
      backgroundColor: zetaColors.surfacePrimary,
      rangePickerBackgroundColor: zetaColors.surfacePrimary,
      rangePickerHeaderForegroundColor: appBarTheme.foregroundColor,
      rangeSelectionBackgroundColor: zetaColors.secondary.shade20,
    );
  }
}
