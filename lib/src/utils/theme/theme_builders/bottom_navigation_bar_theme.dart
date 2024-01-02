import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// An extension on [ZetaColorScheme] class, offering a collection of
/// methods for convenient creation of bottom sheet related
/// themes such as [BottomSheetThemeData], [BottomAppBarTheme] and
/// [BottomNavigationBarThemeData] objects.
extension ZetaBottomNavigationBarTheme on ZetaColorScheme {
  /// Returns a [BottomNavigationBarTheme] object taking into account
  /// the [textTheme] style and the color scheme of this [ZetaColorScheme].
  BottomNavigationBarThemeData bottomNavigationBarTheme(TextTheme textTheme) {
    return BottomNavigationBarThemeData(
      // Set the type of the bottom navigation bar
      type: BottomNavigationBarType.fixed,
      // Sets the style of the selected and unselected labels of the navigation bar
      selectedLabelStyle: textTheme.bodySmall,
      unselectedLabelStyle: textTheme.bodySmall,
      unselectedItemColor: zetaColors.textSubtle,
      selectedItemColor: secondary,
      // Sets the icon theme for selected and unselected items
      selectedIconTheme: IconThemeData(size: 24, color: secondary),
      unselectedIconTheme: IconThemeData(size: 24, color: zetaColors.iconSubtle),
    );
  }
}
