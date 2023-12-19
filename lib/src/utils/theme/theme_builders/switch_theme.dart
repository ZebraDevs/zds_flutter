import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

import '../../tools/utils.dart' show materialStatePropertyResolver;

/// This code defines a Dart extension method for [ZetaColorScheme], which uses Material UI components.
/// It provides a new [switchTheme] method that allows for customization of a [SwitchThemeData] according to the [ZetaColorScheme].

/// The [SwitchThemeData] object returned by the [switchTheme] method has three customized properties:
/// 1. mouseCursor: A [MouseCursor] determined by the Material State.
/// 2. overlayColor: A [Color] determined by the Material State.
/// 3. materialTapTargetSize: Defines the size of the tap target.
extension SwitchExtension on ZetaColorScheme {
  /// Generates a [SwitchThemeData] object with properties
  /// inherited from the parent [ThemeData].
  ///
  /// The [SwitchThemeData] object defines the visual properties of [Switch]es.
  /// [Switch]es are used to toggle the on/off state of a single setting.
  ///
  /// Returns a [SwitchThemeData] object.
  SwitchThemeData switchTheme() {
    return SwitchThemeData(
      /// Defines the mouse cursor for different [MaterialState]s.
      ///
      /// Hovered state uses [SystemMouseCursors.click], Disabled state
      /// uses [SystemMouseCursors.forbidden], default state uses
      /// [SystemMouseCursors.basic].
      mouseCursor: materialStatePropertyResolver(
        hoveredValue: SystemMouseCursors.click,
        disabledValue: SystemMouseCursors.forbidden,
        defaultValue: SystemMouseCursors.basic,
      ),

      /// Defines the overlay [Color] for the [Switch] when it's hovered.
      overlayColor: materialStatePropertyResolver(
        hoveredValue: zetaColors.secondary,
      ),

      /// The smallest detectable part of [Switch] that can lead to a tap event.
      ///
      /// Using [MaterialTapTargetSize.padded] means that the [Switch]
      /// will be bigger, but empty space can also trigger the tap event.
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
