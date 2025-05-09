import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

/// This extends the [ZetaSemantics] class with a method [textSelectionTheme]
/// which allows you to generate a new [TextSelectionThemeData].
///
/// The [TextSelectionThemeData] object returned holds configurations for components
/// related to text selection within [TextField], [TextFormField], etc:
/// 1. cursorColor: Defines the color of the cursor in a text field.
/// 2. selectionColor: Color of the text selection toolbar.
/// 3. selectionHandleColor: Color of the text selection handle.
extension TextSelectionExtension on ZetaSemantics {
  /// Defines a [TextSelectionThemeData] using ZetaColorScheme.
  ///
  /// A [TextSelectionThemeData] holds the color and style parameters which
  /// defines a material design text selection toolbar.
  ///
  /// Returns a [TextSelectionThemeData] object matching the [ZetaSemantics].
  TextSelectionThemeData textSelectionTheme() {
    return TextSelectionThemeData(
      /// Defines the color of the cursor in a text field.
      cursorColor: colors.mainSecondary,

      /// Indicates the color of the text selection toolbar.
      selectionColor: colors.surfaceSecondarySubtle.withOpacity(0.5),

      /// Color of the text selection handle.
      selectionHandleColor: colors.stateSecondarySelected,
    );
  }
}
