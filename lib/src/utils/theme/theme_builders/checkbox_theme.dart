import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorExtensions, ZetaColorScheme;

import '../../tools.dart' show widgetStatePropertyResolver;

/// This is an extension method on [ZetaColorScheme] which is used to customize the [CheckboxThemeData].
extension ZetaCheckboxTheme on ZetaColorScheme {
  /// This function returns a [CheckboxThemeData] customized with properties taken from the [ZetaColorScheme].
  ///
  /// Returns:
  ///   A [CheckboxThemeData] with the applied properties.
  CheckboxThemeData checkboxTheme() {
    /// Returns CheckboxThemeData after setting up properties like mouseCursor, fillColor, side, checkColor,
    /// overlayColor, materialTapTargetSize and visualDensity.
    return CheckboxThemeData(
      /// Setting up custom mouse cursors for different material states.
      mouseCursor: widgetStatePropertyResolver(
        hoveredValue: SystemMouseCursors.click,
        disabledValue: SystemMouseCursors.forbidden,
        defaultValue: SystemMouseCursors.basic,
      ),

      /// Setting up custom fill color for different material states.
      fillColor: widgetStatePropertyResolver(
        selectedValue: zetaColors.secondary,
        hoveredValue: zetaColors.secondary,
        focusedValue: zetaColors.secondary.hover,
        disabledValue: zetaColors.secondary.subtle,
        defaultValue: Colors.transparent,
      ),

      /// Setting up the side property.
      side: BorderSide(color: zetaColors.iconDefault, width: 2),

      /// Setting up custom checkColor for different material states.
      checkColor: widgetStatePropertyResolver(
        selectedValue: onSecondary,
        hoveredValue: onSecondary,
        defaultValue: zetaColors.secondary.onColor,
      ),

      /// Setting up custom overlayColor for different material states.
      overlayColor: widgetStatePropertyResolver(
        hoveredValue: zetaColors.surfaceHover,
      ),

      /// Setting tap target size to "padded".
      materialTapTargetSize: MaterialTapTargetSize.padded,

      /// Setting visual density as "standard".
      visualDensity: VisualDensity.standard,
    );
  }
}
