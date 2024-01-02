import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

import '../../theme.dart';

/// This extension method is used to add additional properties to the [ZetaColorScheme].
extension ZetaCardTheme on ZetaColorScheme {
  /// This function returns a [CardTheme] after applying some properties to the [ZetaColorScheme].
  ///
  /// Returns:
  ///   A CardTheme with the applied properties.
  CardTheme cardTheme() {
    /// Returns CardTheme after customizing properties like color,
    /// elevation, margin, shadowColor and shape.
    return CardTheme(
      /// Assigning color to surface
      color: surface,

      /// Settings elevation to 1
      elevation: 2,

      /// Setting margin to EdgeInsets.all(3)
      margin: const EdgeInsets.all(kZdsCardMargin),

      /// Setting shadowColor with a bit of opacity
      shadowColor: kZdsCardShadowColor,

      /// Customizing the shape of the Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kZdsCardRadius)),
    );
  }
}
