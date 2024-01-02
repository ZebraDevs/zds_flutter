import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// This extension method for the [ZetaColorScheme] class provides a new [tabBarTheme]
/// method. It enables the customization of a [TabBarTheme] to match the [ZetaColorScheme].
///
/// The [TabBarTheme] object returned has several properties:
/// 1. indicatorColor: The color of the selected tab's underline.
/// 2. labelColor: The color of the text within the selected tab.
/// 3. unselectedLabelColor: The color of the text within any unselected tabs.
/// 4. labelStyle: The text styling applied to text within the selected tab.
/// 5. unselectedLabelStyle: The text styling applied to text within any unselected tabs.
extension TabBarExtension on ZetaColorScheme {
  /// Generate a [TabBarTheme] object with visual properties for a [TabBar].
  /// [TabBar]s display a horizontal row of tabs, one tab per [TabController].
  ///
  /// [textTheme] is used to style the labels of the selected and unselected tabs.
  ///
  /// Returns a [TabBarTheme] that matches the [ZetaColorScheme].
  TabBarTheme tabBarTheme(TextTheme textTheme) {
    return TabBarTheme(
      /// The color of the line that appears below the selected tab.
      indicatorColor: zetaColors.secondary,

      /// The color to use for [Tab] labels when a [Tab] is selected.
      labelColor: zetaColors.secondary,

      /// The color to use for [Tab] labels when the associated [Tab] is not selected.
      unselectedLabelColor: zetaColors.textSubtle,

      /// The [TextStyle] to apply to [Tab] labels when a [Tab] is selected.
      labelStyle: textTheme.bodySmall,

      /// The [TextStyle] to apply to [Tab] labels when a [Tab] is not selected.
      unselectedLabelStyle: textTheme.bodySmall,
    );
  }
}
