import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaSemantics;

/// This extension method is used to add additional properties to the [ZetaSemantics].
extension ZetaCardTheme on ZetaSemantics {
  /// This function returns a [CardTheme] after applying some properties to the [ZetaSemantics].
  ///
  /// Returns:
  ///   A CardTheme with the applied properties.
  CardTheme cardTheme() {
    return CardTheme(
      /// Assigning color to surfaceDefault
      color: colors.surfaceDefault,

      /// Settings elevation to 2
      elevation: 2,

      /// Setting margin to EdgeInsets.all(3)
      margin: EdgeInsets.all(primitives.x1),

      /// Setting shadowColor with a bit of opacity
      shadowColor: colors.mainSubtle.withValues(alpha: 0.1),

      /// Customizing the shape of the Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(primitives.x4)),
    );
  }
}
