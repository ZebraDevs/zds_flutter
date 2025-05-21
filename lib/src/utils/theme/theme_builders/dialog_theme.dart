import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

/// Extension method on the [ZetaSemantics] class.
///
/// Returns a custom [DialogTheme].
extension ZetaDialogTheme on ZetaSemantics {
  /// Generates a [DialogTheme] based on the current color scheme.
  ///
  /// The background color of the dialog will be set to the tertiary surface color
  /// of the current color scheme.
  ///
  /// The shape of the dialog is set to a [RoundedRectangleBorder] with a border radius of 8.
  DialogThemeData dialogTheme() {
    // Return a DialogTheme with custom properties
    return DialogThemeData(
      // Set the background color to the tertiary color of this ZetaColorScheme
      backgroundColor: colors.surfaceDefault,

      // sets dialog barrier color to white12 if the brightness is dark, otherwise black54
      barrierColor: colors.primitives.brightness == Brightness.dark ? Colors.white12 : Colors.black54,

      // Set the shape to a RoundedRectangle with a borderRadius of 8
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
