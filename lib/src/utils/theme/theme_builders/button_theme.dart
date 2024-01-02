import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

import '../../../components/atoms/button.dart' show ZdsButton, ZdsButtonVariant;

/// An extension on [ZetaColorScheme] class, offering methods for creating
/// text, elevated, and outlined button themes for this [ZetaColorScheme].
extension ZetaButtonTheme on ZetaColorScheme {
  /// Returns a [BorderSide] with no outline. This is meant for buttons
  /// that should not have any border.
  MaterialStateProperty<BorderSide> baseButtonBorderSide() => MaterialStateProperty.all(BorderSide.none);

  /// Provides a standard padding for buttons across this [ZetaColorScheme].
  EdgeInsets buttonPadding() => const EdgeInsets.symmetric(horizontal: 24, vertical: 10);

  /// Provides the border radius for round buttons in this [ZetaColorScheme].
  BorderRadius buttonBorderRadius() => const BorderRadius.all(Radius.circular(71));

  /// Returns a [MaterialStateProperty] of [OutlinedBorder] which could
  /// be used when round buttons are required in this [ZetaColorScheme].
  MaterialStateProperty<OutlinedBorder> buttonCircularShapeBorder() {
    return MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: buttonBorderRadius(),
      ),
    );
  }

  /// Builds a [TextButtonThemeData] with styles specified by the [ZdsButton.getStyle] function
  /// and the [ZetaColorScheme] colors.
  TextButtonThemeData textButtonTheme(TextTheme textTheme) {
    return TextButtonThemeData(
      style: ZdsButton.getStyle(
        variant: ZdsButtonVariant.text,
        zetaColors: zetaColors,
        textTheme: textTheme,
      ).copyWith(
        padding: MaterialStateProperty.all(buttonPadding()),
        shape: buttonCircularShapeBorder(),
        elevation: MaterialStateProperty.all(0),
        visualDensity: VisualDensity.standard,
      ),
    );
  }

  /// Builds a [ElevatedButtonThemeData] with properties specified by
  /// the [ZdsButton.getStyle] function and the [ZetaColorScheme] colors.
  ElevatedButtonThemeData elevatedButtonTheme(TextTheme textTheme) {
    return ElevatedButtonThemeData(
      style: ZdsButton.getStyle(
        variant: ZdsButtonVariant.filled,
        zetaColors: zetaColors,
        textTheme: textTheme,
      ).copyWith(
        padding: MaterialStateProperty.all(buttonPadding()),
        shape: buttonCircularShapeBorder(),
        elevation: MaterialStateProperty.all(0),
        visualDensity: VisualDensity.standard,
      ),
    );
  }

  /// Builds a [OutlinedButtonThemeData] with properties specified by
  /// the [ZdsButton.getStyle] function and the [ZetaColorScheme] colors.
  OutlinedButtonThemeData outlinedButtonTheme(TextTheme textTheme) {
    return OutlinedButtonThemeData(
      style: ZdsButton.getStyle(
        variant: ZdsButtonVariant.outlined,
        zetaColors: zetaColors,
        textTheme: textTheme,
      ).copyWith(
        padding: MaterialStateProperty.all(buttonPadding()),
        shape: buttonCircularShapeBorder(),
        elevation: MaterialStateProperty.all(0),
        visualDensity: VisualDensity.standard,
      ),
    );
  }
}
