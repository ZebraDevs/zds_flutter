import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

import '../../tools.dart' show materialStatePropertyResolver;

/// This extension on [ZetaColorScheme] allows to create and customize [ListTileThemeData].
extension ListTileExtension on ZetaColorScheme {
  /// Creates a custom [ListTileThemeData] using the specified
  /// properties and styles obtained from the [ZetaColorScheme] and [TextTheme].
  ///
  /// Parameter:
  ///   [textTheme] : A TextTheme object to copy text styles from.
  ///
  /// Returns:
  ///   A [ListTileThemeData] with the applied properties.

  ListTileThemeData listTileTheme(TextTheme textTheme) {
    /// ListTileThemeData returns after assigning properties like selectedColor,
    /// iconColor, titleTextStyle, subtitleTextStyle, leadingAndTrailingTextStyle and
    /// mouseCursor.
    return ListTileThemeData(
      /// Setting up the selected list tile color.
      selectedColor: zetaColors.primary.selected,

      /// Selected tile color
      selectedTileColor: zetaColors.primary.surface,

      /// Setting up the icon color.
      iconColor: zetaColors.iconDefault,

      /// Setting up the title text style using the provided textTheme.
      titleTextStyle: textTheme.bodyMedium?.copyWith(color: zetaColors.textDefault),

      /// Setting up the subtitle text style using the provided textTheme.
      subtitleTextStyle: textTheme.bodySmall?.copyWith(color: zetaColors.textSubtle),

      /// Setting up the styles for both leading and trailing texts.
      leadingAndTrailingTextStyle: textTheme.bodySmall?.copyWith(color: zetaColors.textSubtle),

      /// Setting up custom mouse cursors for different material states.
      mouseCursor: materialStatePropertyResolver(
        hoveredValue: SystemMouseCursors.click,
        disabledValue: SystemMouseCursors.forbidden,
        defaultValue: SystemMouseCursors.basic,
      ),
    );
  }
}
