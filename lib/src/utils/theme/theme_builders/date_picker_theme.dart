import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// This is an extension method on [ZetaSemantics] which is used to customize the [DatePickerThemeData].
extension ZetaDatePickerTheme on ZetaSemantics {
  /// This function returns a [DatePickerThemeData] customized with properties
  /// taken from the [ZetaSemantics].
  ///
  /// Returns:
  ///   A [DatePickerThemeData] with the applied properties.
  DatePickerThemeData datePickerTheme(AppBarTheme appBarTheme) {
    /// Returns a DatePickerThemeData after assigning properties like
    /// thickness, space and color.
    return DatePickerThemeData(
      headerBackgroundColor: appBarTheme.backgroundColor,
      headerForegroundColor: appBarTheme.foregroundColor,
      backgroundColor: colors.surfacePrimary,
      rangePickerBackgroundColor: colors.surfacePrimary,
      rangePickerHeaderForegroundColor: appBarTheme.foregroundColor,
      rangeSelectionBackgroundColor: colors.primitives.secondary.shade20,
    );
  }
}
