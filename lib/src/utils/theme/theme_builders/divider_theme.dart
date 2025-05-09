import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

/// This is an extension method on [ZetaSemantics] which is used to customize the [DividerThemeData].
extension ZetaDividerTheme on ZetaSemantics {
  /// This function returns a [DividerThemeData] customized with properties
  /// taken from the [ZetaSemantics].
  ///
  /// Returns:
  ///   A [DividerThemeData] with the applied properties.
  DividerThemeData dividerTheme() {
    /// Returns a DividerThemeData after assigning properties like
    /// thickness, space and color.
    return DividerThemeData(
      /// Setting up the thickness property
      thickness: 1,

      /// Setting up the space property
      space: 1,

      /// Using a color from the zetaColors for the divider color
      color: colors.borderSubtle,
    );
  }
}
