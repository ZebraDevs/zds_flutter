import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorExtensions, ZetaColorScheme;

import '../../tools.dart' show computeSystemOverlayStyle;

/// An extension on the [ZetaColorScheme] class that adds the method
/// [appBarTheme] for creating an [AppBarTheme] object.
extension ZetaAppBarTheme on ZetaColorScheme {
  /// Returns an [AppBarTheme] object created based on the provided [textTheme]
  /// and [background].
  ///
  /// [textTheme] is the [TextTheme] used to style text within the appBar.
  /// [background] is a [Color] object representing the color of the appBar.
  ///
  /// The `foreground` color is determined based on the [background] color.
  AppBarTheme appBarTheme(TextTheme textTheme, Color background) {
    // Calculate the preferred foreground color based on the given background color.
    final foreground = background.onColor;

    // Return an AppBarTheme instant built using the resolved foreground color and provided parameters.
    return AppBarTheme(
      // Compute the SystemUiOverlayStyle to be set given the appBar's background color.
      systemOverlayStyle: computeSystemOverlayStyle(background),

      // Set the background color as provided in the parameter.
      backgroundColor: background,

      // Set the foreground color as calculated based on the background color.
      foregroundColor: foreground,

      // Align title to start of the AppBar i.e., not centered.
      centerTitle: false,

      // Spacing around the title, here it is set to 0.
      titleSpacing: 0,

      // Add a subtle shadow to the appBar.
      elevation: 0.5,

      // Set icon theme
      iconTheme: IconThemeData(color: foreground),

      // Set actions icon theme
      actionsIconTheme: IconThemeData(color: foreground),

      // Set the text style of the title to match the provided text theme.
      // If the headlineLarge text style is not available fallback to default text style.
      titleTextStyle: textTheme.headlineLarge?.copyWith(
        color: foreground,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
