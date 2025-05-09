import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

/// An extension on [ZetaSemantics].
///
/// This extension adds a method [sliderTheme], which allows for customizing
/// the appearance of a [Slider] using the [ZetaSemantics].
extension ZetaDividerTheme on ZetaSemantics {
  /// Creates and returns a [SliderThemeData] object.
  ///
  /// Track height, active and inactive track colors, active and inactive tick mark
  /// colors, and secondary active track color can be customized through this method.
  SliderThemeData sliderTheme() {
    return SliderThemeData(
      /// Defines the height of the slider track
      trackHeight: 3,

      /// Defines the color of the active part of the slider track
      activeTrackColor: colors.mainSecondary,

      /// Defines the color of the active tick mark in the slider
      activeTickMarkColor: colors.mainInverse,

      /// Defines the color of the inactive tick mark in the slider
      inactiveTickMarkColor: colors.borderSelected,

      /// Defines the color of the inactive part of the slider track
      inactiveTrackColor: colors.borderSubtle,

      /// Defines the color of the secondary active part of the slider track
      secondaryActiveTrackColor: colors.borderDefault,
    );
  }
}
