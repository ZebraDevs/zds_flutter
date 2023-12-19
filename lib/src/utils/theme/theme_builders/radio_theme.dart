import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

import '../../tools/utils.dart' show materialStatePropertyResolver;

/// An extension on [ZetaColorScheme].
///
/// This extension adds a method [radioThemeData], which allows for customizing
/// the appearance of a radio button using the [ZetaColorScheme].
extension RadioExtension on ZetaColorScheme {
  /// Creates and returns a [RadioThemeData] object.
  ///
  /// Mouse cursors, fill color, overlay color, tap target size, and visual density
  /// of radio buttons can be customized through this method.
  /// [MouseCursor] and Color values are resolved using materialStatePropertyResolver that handles
  /// different UI states of radio button (like hover, disabled etc.).
  RadioThemeData radioThemeData() {
    return RadioThemeData(
      /// Defines the mouse cursor when hovered, disabled and the default value.
      mouseCursor: materialStatePropertyResolver(
        hoveredValue: SystemMouseCursors.click,
        disabledValue: SystemMouseCursors.forbidden,
        defaultValue: SystemMouseCursors.basic,
      ),

      /// Defines the fill color for the different states of radio button.
      fillColor: materialStatePropertyResolver(
        selectedValue: zetaColors.secondary,
        hoveredValue: zetaColors.secondary.hover,
        focusedValue: zetaColors.secondary.hover,
        disabledValue: zetaColors.secondary.subtle,
        defaultValue: zetaColors.iconDefault,
      ),

      /// Defines the overlay color for hover state of radio button.
      overlayColor: materialStatePropertyResolver(
        hoveredValue: zetaColors.secondary.hover,
      ),

      /// Defines the size of the material tap target.
      materialTapTargetSize: MaterialTapTargetSize.padded,

      /// Defines the visual density - vertical and horizontal density
      /// of material components.
      visualDensity: VisualDensity.standard,
    );
  }
}
