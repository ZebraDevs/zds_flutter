import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// An extension on [ZetaColorScheme] for customizing the [ProgressIndicatorThemeData].
extension ProgressIndicatorExtension on ZetaColorScheme {
  /// Creates a custom [ProgressIndicatorThemeData] using the properties obtained
  /// from the [ZetaColorScheme].
  ///
  /// Returns:
  ///   A [ProgressIndicatorThemeData] with the applied properties.

  ProgressIndicatorThemeData progressIndicatorTheme() {
    /// Returns ProgressIndicatorThemeData after assigning the color property.
    return ProgressIndicatorThemeData(
      /// Setting up the color.
      color: secondary,
    );
  }
}
