import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

/// An extension on [ZetaColorScheme].
///
/// This extension adds a method [sliderTheme], which allows for customizing
/// the appearance of a [Slider] using the [ZetaColorScheme].
extension ZetaDividerTheme on ZetaColorScheme {
  /// Creates and returns a [SliderThemeData] object.
  ///
  /// Track height, active and inactive track colors, active and inactive tick mark
  /// colors, and secondary active track color can be customized through this method.
  SliderThemeData sliderTheme() {
    return SliderThemeData(
      /// Defines the height of the slider track
      trackHeight: 3,

      /// Defines the color of the active part of the slider track
      activeTrackColor: zetaColors.secondary,

      /// Defines the color of the active tick mark in the slider
      activeTickMarkColor: onSecondary,

      /// Defines the color of the inactive tick mark in the slider
      inactiveTickMarkColor: zetaColors.borderSelected,

      /// Defines the color of the inactive part of the slider track
      inactiveTrackColor: zetaColors.borderSubtle,

      /// Defines the color of the secondary active part of the slider track
      secondaryActiveTrackColor: zetaColors.borderDefault,
    );
  }
}
