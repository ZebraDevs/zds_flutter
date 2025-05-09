import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../tools.dart' show widgetStatePropertyResolver;

/// This extension on [ZetaSemantics] allows to create and customize [ListTileThemeData].
extension ListTileExtension on ZetaSemantics {
  /// Creates a custom [ListTileThemeData] using the specified
  /// properties and styles obtained from the [ZetaSemantics] and [TextTheme].
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
      selectedColor: colors.statePrimarySelected,

      /// Selected tile color
      selectedTileColor: colors.surfacePrimarySubtle,

      /// Setting up the icon color.
      iconColor: colors.mainDefault,

      /// Setting up the title text style using the provided textTheme.
      titleTextStyle: textTheme.bodyMedium?.copyWith(color: colors.mainDefault),

      /// Setting up the subtitle text style using the provided textTheme.
      subtitleTextStyle: textTheme.bodySmall?.copyWith(color: colors.mainSubtle),

      /// Setting up the styles for both leading and trailing texts.
      leadingAndTrailingTextStyle: textTheme.bodySmall?.copyWith(color: colors.mainSubtle),

      /// Setting up custom mouse cursors for different material states.
      mouseCursor: widgetStatePropertyResolver(
        hoveredValue: SystemMouseCursors.click,
        disabledValue: SystemMouseCursors.forbidden,
        defaultValue: SystemMouseCursors.basic,
      ),
    );
  }
}
