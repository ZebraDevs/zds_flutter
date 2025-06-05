import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

/// This extension on [ZetaSemantics] allows to create and customize [PopupMenuThemeData].
extension PopupMenuExtension on ZetaSemantics {
  /// Creates a custom [PopupMenuThemeData] using the specified
  /// properties and styles obtained from the [ZetaSemantics] and [TextTheme].
  ///
  /// Parameter:
  ///   [textTheme] : A TextTheme object to copy text styles from.
  ///
  /// Returns:
  ///   A [PopupMenuThemeData] with the applied properties.

  PopupMenuThemeData popupMenuTheme(TextTheme textTheme) {
    /// Returns PopupMenuThemeData after assigning properties like
    /// textStyle, elevation, color and surfaceTintColor.
    return PopupMenuThemeData(
      /// Setting up the text style using the provided textTheme.
      textStyle: textTheme.bodyMedium,

      /// Setting up the elevation.
      elevation: 5,

      /// Setting up the color.
      color: colors.surfaceDefault,

      /// Setting up the tint color of the surface.
      surfaceTintColor: colors.mainDefault,
    );
  }
}
