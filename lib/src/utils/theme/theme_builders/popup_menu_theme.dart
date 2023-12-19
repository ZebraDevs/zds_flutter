import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// This extension on [ZetaColorScheme] allows to create and customize [PopupMenuThemeData].
extension PopupMenuExtension on ZetaColorScheme {
  /// Creates a custom [PopupMenuThemeData] using the specified
  /// properties and styles obtained from the [ZetaColorScheme] and [TextTheme].
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
      color: surface,

      /// Setting up the tint color of the surface.
      surfaceTintColor: onSurface,
    );
  }
}
