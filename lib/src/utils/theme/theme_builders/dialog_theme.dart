import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// Extension method on the [ZetaColorScheme] class.
///
/// Returns a custom [DialogTheme].
extension ZetaDialogTheme on ZetaColorScheme {
  /// Generates a [DialogTheme] based on the current color scheme.
  ///
  /// The background color of the dialog will be set to the tertiary surface color
  /// of the current color scheme.
  ///
  /// The shape of the dialog is set to a [RoundedRectangleBorder] with a border radius of 8.
  DialogTheme dialogTheme() {
    // Return a DialogTheme with custom properties
    return DialogTheme(
      // Set the background color to the tertiary color of this ZetaColorScheme
      backgroundColor: zetaColors.surfaceTertiary,

      // Set the shape to a RoundedRectangle with a borderRadius of 8
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
