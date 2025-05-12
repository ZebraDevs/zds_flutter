import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// An extension on [ZetaSemantics] class, offering methods for creating
/// text, elevated, and outlined button themes for this [ZetaSemantics].
extension ZetaButtonTheme on ZetaSemantics {
  /// Returns a [BorderSide] with no outline. This is meant for buttons
  /// that should not have any border.
  WidgetStateProperty<BorderSide> baseButtonBorderSide() => WidgetStateProperty.all(BorderSide.none);

  /// Provides a standard padding for buttons across this [ZetaSemantics].
  EdgeInsets buttonPadding() => const EdgeInsets.symmetric(horizontal: 24, vertical: 10);

  /// Provides the border radius for round buttons in this [ZetaSemantics].
  BorderRadius buttonBorderRadius() => const BorderRadius.all(Radius.circular(71));

  /// Returns a [WidgetStateProperty] of [OutlinedBorder] which could
  /// be used when round buttons are required in this [ZetaSemantics].
  WidgetStateProperty<OutlinedBorder> buttonCircularShapeBorder() {
    return WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: buttonBorderRadius(),
      ),
    );
  }

  /// Builds a [TextButtonThemeData] with styles specified by the [ZdsButton.getStyle] function
  /// and the [ZetaSemantics] colors.
  TextButtonThemeData textButtonTheme(TextTheme textTheme) {
    return TextButtonThemeData(
      style: ZdsButton.getStyle(
        variant: ZdsButtonVariant.text,
        zetaColors: colors,
        textTheme: textTheme,
      ).copyWith(
        padding: WidgetStateProperty.all(buttonPadding()),
        shape: buttonCircularShapeBorder(),
        elevation: WidgetStateProperty.all(0),
        visualDensity: VisualDensity.standard,
      ),
    );
  }

  /// Builds a [ElevatedButtonThemeData] with properties specified by
  /// the [ZdsButton.getStyle] function and the [ZetaSemantics] colors.
  ElevatedButtonThemeData elevatedButtonTheme(TextTheme textTheme) {
    return ElevatedButtonThemeData(
      style: ZdsButton.getStyle(
        variant: ZdsButtonVariant.filled,
        zetaColors: colors,
        textTheme: textTheme,
      ).copyWith(
        padding: WidgetStateProperty.all(buttonPadding()),
        shape: buttonCircularShapeBorder(),
        elevation: WidgetStateProperty.all(0),
        visualDensity: VisualDensity.standard,
      ),
    );
  }

  /// Builds a [OutlinedButtonThemeData] with properties specified by
  /// the [ZdsButton.getStyle] function and the [ZetaSemantics] colors.
  OutlinedButtonThemeData outlinedButtonTheme(TextTheme textTheme) {
    return OutlinedButtonThemeData(
      style: ZdsButton.getStyle(
        variant: ZdsButtonVariant.outlined,
        zetaColors: colors,
        textTheme: textTheme,
      ).copyWith(
        padding: WidgetStateProperty.all(buttonPadding()),
        shape: buttonCircularShapeBorder(),
        elevation: WidgetStateProperty.all(0),
        visualDensity: VisualDensity.standard,
      ),
    );
  }
}
