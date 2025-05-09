import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../tools/utils.dart' show widgetStatePropertyResolver;

/// An extension on [ZetaSemantics].
///
/// This extension adds a method [radioThemeData], which allows for customizing
/// the appearance of a radio button using the [ZetaSemantics].
extension RadioExtension on ZetaSemantics {
  /// Creates and returns a [RadioThemeData] object.
  ///
  /// Mouse cursors, fill color, overlay color, tap target size, and visual density
  /// of radio buttons can be customized through this method.
  /// [MouseCursor] and Color values are resolved using WidgetStatePropertyResolver that handles
  /// different UI states of radio button (like hover, disabled etc.).
  RadioThemeData radioThemeData() {
    return RadioThemeData(
      /// Defines the mouse cursor when hovered, disabled and the default value.
      mouseCursor: widgetStatePropertyResolver(
        hoveredValue: SystemMouseCursors.click,
        disabledValue: SystemMouseCursors.forbidden,
        defaultValue: SystemMouseCursors.basic,
      ),

      /// Defines the fill color for the different states of radio button.
      fillColor: widgetStatePropertyResolver(
        selectedValue: colors.mainSecondary,
        hoveredValue: colors.stateSecondaryHover,
        focusedValue: colors.stateSecondaryHover,
        disabledValue: colors.surfaceSecondarySubtle,
        defaultValue: colors.mainDefault,
      ),

      /// Defines the overlay color for hover state of radio button.
      overlayColor: widgetStatePropertyResolver(
        hoveredValue: colors.surfaceHover,
      ),

      /// Defines the size of the material tap target.
      materialTapTargetSize: MaterialTapTargetSize.padded,

      /// Defines the visual density - vertical and horizontal density
      /// of material components.
      visualDensity: VisualDensity.standard,
    );
  }
}
