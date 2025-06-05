import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

/// An extension on [ZetaSemantics] for customizing the [ProgressIndicatorThemeData].
extension ProgressIndicatorExtension on ZetaSemantics {
  /// Creates a custom [ProgressIndicatorThemeData] using the properties obtained
  /// from the [ZetaSemantics].
  ///
  /// Returns:
  ///   A [ProgressIndicatorThemeData] with the applied properties.

  ProgressIndicatorThemeData progressIndicatorTheme() {
    /// Returns ProgressIndicatorThemeData after assigning the color property.
    return ProgressIndicatorThemeData(
      /// Setting up the color.
      color: colors.mainSecondary,
      linearTrackColor: Colors.transparent,
      circularTrackColor: Colors.transparent,
    );
  }
}
