import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../tools.dart' show widgetStatePropertyResolver;

/// This is an extension method on [ZetaSemantics] which is used to customize the [CheckboxThemeData].
extension ZetaCheckboxTheme on ZetaSemantics {
  /// This function returns a [CheckboxThemeData] customized with properties taken from the [ZetaSemantics].
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
        selectedValue: colors.mainSecondary,
        hoveredValue: colors.mainSecondary,
        focusedValue: colors.stateSecondaryHover,
        disabledValue: colors.surfaceSecondarySubtle,
        defaultValue: Colors.transparent,
      ),

      /// Setting up the side property.
      side: BorderSide(color: colors.mainDefault, width: 2),

      /// Setting up custom checkColor for different material states.
      checkColor: widgetStatePropertyResolver(
        selectedValue: colors.mainInverse,
        hoveredValue: colors.mainInverse,
        defaultValue: colors.mainInverse,
      ),

      /// Setting up custom overlayColor for different material states.
      overlayColor: widgetStatePropertyResolver(
        hoveredValue: colors.surfaceHover,
      ),

      /// Setting tap target size to "padded".
      materialTapTargetSize: MaterialTapTargetSize.padded,

      /// Setting visual density as "standard".
      visualDensity: VisualDensity.standard,
    );
  }
}
