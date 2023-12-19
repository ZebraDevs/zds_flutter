import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// ZetaIconTheme extension on ZetaColorScheme.
/// Provides an IconThemeData instance with predefined size and color.
extension ZetaIconTheme on ZetaColorScheme {
  /// Returns a [IconThemeData] object taking the given parameters into account.
  ///
  /// [color] is used to define the icon color.
  /// If not provided, the default color is used.
  /// [size] defines the size of the icon. The default value is 30.
  IconThemeData iconTheme({Color? color, double size = 30}) {
    return IconThemeData(
      size: size,
      color: color,
    );
  }
}
