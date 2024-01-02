import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

import '../../theme.dart' show ZdsInputBorder;

/// This extension on [ZetaColorScheme] allows to create and customize [InputDecorationTheme].
extension ZetaDividerTheme on ZetaColorScheme {
  /// Creates a custom [InputDecorationTheme] using the specified
  /// properties and styles obtained from the [ZetaColorScheme] and [TextTheme].
  ///
  /// Parameter:
  ///   [textTheme] : A TextTheme object to copy text styles from.
  ///
  /// Returns:
  ///   A [InputDecorationTheme] with the applied properties.

  InputDecorationTheme inputDecorationTheme(TextTheme textTheme) {
    /// Returns InputDecorationTheme after assigning properties like
    /// border, focusedBorder, enabledBorder, disabledBorder, floatingLabelBehavior,
    /// contentPadding, errorBorder, focusColor, focusedErrorBorder,
    /// labelStyle, and counterStyle.
    return InputDecorationTheme(
      /// Setting up the border using custom ZdsInputBorder.
      border: ZdsInputBorder(borderSide: BorderSide(color: zetaColors.borderDefault)),

      /// Setting up the border when the input is focussed.
      focusedBorder: ZdsInputBorder(borderSide: BorderSide(color: zetaColors.borderSelected)),

      /// Setting up the border when the input is enabled.
      enabledBorder: ZdsInputBorder(borderSide: BorderSide(color: zetaColors.borderDefault)),

      /// Setting up the border when the input is disabled.
      disabledBorder: ZdsInputBorder(borderSide: BorderSide(color: zetaColors.borderDisabled)),

      /// Always displaying the floating label.
      floatingLabelBehavior: FloatingLabelBehavior.always,

      /// Setting the padding inside the input field.
      contentPadding: const EdgeInsets.fromLTRB(12, 27, 12, 27),

      /// Setting up the border to indicate an error.
      errorBorder: ZdsInputBorder(borderSide: BorderSide(color: errorContainer)),

      /// Setting up the colour of input when focused.
      focusColor: zetaColors.borderSelected,

      /// Custom border setup for when the input has focus and also has an error.
      focusedErrorBorder: ZdsInputBorder(borderSide: BorderSide(color: error)),

      /// Setting up the label text style using the provided textTheme.
      labelStyle: textTheme.titleSmall?.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: zetaColors.textSubtle,
        height: 0,
      ),

      /// Setting up the Icon color for suffix
      prefixIconColor: zetaColors.iconDefault,

      /// Setting up the Icon color for suffix
      suffixIconColor: zetaColors.iconSubtle,

      /// Setting up the label text style using the provided textTheme.
      suffixStyle: textTheme.titleSmall?.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: zetaColors.textSubtle,
        height: 0,
      ),

      /// Setting up the counter text style using the provided textTheme.
      counterStyle: textTheme.bodySmall?.copyWith(
        height: 0.1,
        color: zetaColors.textSubtle,
      ),
    );
  }
}
