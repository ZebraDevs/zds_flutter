import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaSemantics;

/// This extension provides a [BottomAppBarTheme] instance for a given [ZetaSemantics].
extension ZetaBottomAppBarTheme on ZetaSemantics {
  /// Creates and returns a [BottomAppBarTheme] based on the defined [ZetaSemantics].
  ///
  /// The [BottomAppBarTheme] has its color, surface tint color, shadow color, and padding values
  /// influenced by the [ZetaSemantics].
  BottomAppBarTheme bottomAppBarTheme() {
    return BottomAppBarTheme(
      /// The color of the `BottomAppBar`. This is set to the `surfaceDefault` color of the
      /// `ZetaSemantics`.
      color: colors.surfaceDefault,

      /// The surface tint color of the `BottomAppBar`. This is set to the `mainDefault` color of the
      /// `ZetaSemantics`.
      surfaceTintColor: colors.mainDefault,

      /// The shadow color of the `BottomAppBar` is set to the `mainSubtle` color of the `ZetaSemantics`,
      /// but with an opacity of 0.1.
      shadowColor: colors.mainSubtle.withValues(alpha: 0.1),

      /// Padding inside the `BottomAppBar`. This is constant and set to be symmetric both horizontally
      /// and vertically. When running on the web, vertical padding is 8, otherwise it's 4.
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: kIsWeb ? 8 : 4),
    );
  }
}
