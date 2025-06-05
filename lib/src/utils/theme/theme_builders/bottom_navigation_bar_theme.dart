import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaSemantics;

/// An extension on [ZetaSemantics] class, offering a collection of
/// methods for convenient creation of bottom sheet related
/// themes such as [BottomSheetThemeData], [BottomAppBarTheme] and
/// [BottomNavigationBarThemeData] objects.
extension ZetaBottomNavigationBarTheme on ZetaSemantics {
  /// Returns a [BottomNavigationBarTheme] object taking into account
  /// the [textTheme] style and the color scheme of this [ZetaSemantics].
  BottomNavigationBarThemeData bottomNavigationBarTheme(TextTheme textTheme) {
    return BottomNavigationBarThemeData(
      // Set the type of the bottom navigation bar
      type: BottomNavigationBarType.fixed,
      // Sets the style of the selected and unselected labels of the navigation bar
      selectedLabelStyle: textTheme.bodySmall,
      unselectedLabelStyle: textTheme.bodySmall,
      unselectedItemColor: colors.mainSubtle,
      selectedItemColor: colors.mainSecondary,
      // Sets the icon theme for selected and unselected items
      selectedIconTheme: IconThemeData(size: 24, color: colors.mainSecondary),
      unselectedIconTheme: IconThemeData(size: 24, color: colors.mainSubtle),
    );
  }
}
