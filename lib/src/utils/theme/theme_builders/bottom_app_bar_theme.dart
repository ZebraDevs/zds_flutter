import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// This extension provides a [BottomAppBarTheme] instance for a given [ZetaColorScheme].
extension ZetaBottomAppBartTheme on ZetaColorScheme {
  /// Creates and returns a [BottomAppBarTheme] based on the defined [ZetaColorScheme].
  ///
  /// The [BottomAppBarTheme] has its color, surface tint color, shadow color, and padding values
  /// influenced by the [ZetaColorScheme].
  BottomAppBarTheme bottomAppBarTheme() {
    return BottomAppBarTheme(
      /// The color of the `BottomAppBar`. This is set to the `surface` color of the
      /// `ZetaColorScheme`.
      color: surface,

      /// The surface tint color of the `BottomAppBar`. This is set to the `onSurface` color of the
      /// `ZetaColorScheme`.
      surfaceTintColor: onSurface,

      /// The shadow color of the `BottomAppBar` is set to the `onBackground` color of the `ZetaColorScheme`,
      /// but with an opacity of 0.1.
      shadowColor: onSurface.withOpacity(0.1),

      /// Padding inside the `BottomAppBar`. This is constant and set to be symmetric both horizontally
      /// and vertically. When running on the web, vertical padding is 8, otherwise it's 4.
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: kIsWeb ? 8 : 4),
    );
  }
}
