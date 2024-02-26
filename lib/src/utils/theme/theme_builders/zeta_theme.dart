import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart' show ZetaColorScheme;

import '../text.dart';
import 'app_bar_theme.dart';
import 'bottom_app_bar_theme.dart';
import 'bottom_navigation_bar_theme.dart';
import 'bottom_sheet_theme.dart';
import 'button_theme.dart';
import 'card_theme.dart';
import 'checkbox_theme.dart';
import 'chip_theme.dart';
import 'date_picker_theme.dart';
import 'dialog_theme.dart';
import 'divider_theme.dart';
import 'icon_theme.dart';
import 'input_decoration_theme.dart';
import 'list_tile_theme.dart';
import 'popup_menu_theme.dart';
import 'progress_indicator_theme.dart';
import 'radio_theme.dart';
import 'search_bar_theme.dart';
import 'slider_theme.dart';
import 'switch_theme.dart';
import 'tab_bar_theme.dart';
import 'text_selection_theme.dart';

/// Enum to select the used AppBarTheme style in [ZetaColorScheme] based themes.
enum ZetaAppBarStyle {
  /// Use the scheme primary color as the AppBar's themed background color.
  ///
  /// This is the default for light themes.
  primary,

  /// Use the scheme secondary color as the AppBar's themed background color.
  ///
  /// This is the default for light themes.
  secondary,

  /// Use scheme surface color as the AppBar's themed background color,
  /// including any blend (surface tint) color it may have.
  surface,

  /// Use scheme background color as the AppBar's themed background color,
  /// including any blend (surface tint) color it may have.
  background,
}

/// Extension method on ZetaAppBarStyle to add appBar color functionality.
extension AppBarColor on ZetaAppBarStyle {
  /// Returns effective appBar color depending upon the color scheme.
  ///
  /// [colorScheme] is the color palette maintained by the app/theme
  /// for standard color consistency across the app.
  ///
  /// [ZetaAppBarStyle] is the style variant for AppBar, which determines
  /// the colour that should be derived from the [colorScheme].
  ///
  /// Returns [Color], the final colour to be applied to the appBar.
  Color effectiveAppBarColor(ZetaColorScheme colorScheme) {
    switch (this) {
      case ZetaAppBarStyle.primary:
        // Applying primary color of color scheme
        return colorScheme.primary;
      case ZetaAppBarStyle.secondary:
        // Applying secondary color of color scheme
        return colorScheme.secondary;
      case ZetaAppBarStyle.surface:
        // Applying surface color of color scheme
        return colorScheme.surface;
      case ZetaAppBarStyle.background:
        // Applying background color of color scheme
        return colorScheme.background;
    }
  }
}

/// A Dart extension on [ZetaColorScheme]
///
/// Allows the client to easily interface with the more verbose ThemeData class of Flutter
/// and generate a theme configuration based on the simpler ZetaColorScheme object.
extension ZetaThemeBuilder on ZetaColorScheme {
  /// Converts the ZetaColorScheme to a ThemeData object.
  ///
  /// Takes optional parameters [fontFamily] , a string representing
  /// the font that the generated ThemeData object will use, and
  /// [appBarStyle] an enum object of type ZetaAppBarStyle to define the
  /// style of the AppBar. These parameters defaults to null and ZetaAppBarStyle.primary
  /// respectively if they're not provided.
  /// [useMaterial3] enables or disabled the Material3 design, defaults to false
  ThemeData toTheme({
    String? fontFamily,
    ZetaAppBarStyle appBarStyle = ZetaAppBarStyle.primary,
    bool useMaterial3 = false,
  }) {
    // A TextTheme object for the colors onPrimary.
    final primaryTextTheme = buildZdsTextTheme(
      textColor: onPrimary,
      fontFamily: fontFamily,
    );

    // A TextTheme object for the colors onSurface.
    final TextTheme textTheme = buildZdsTextTheme(
      textColor: onSurface,
      fontFamily: fontFamily,
    );

    // The actual appBar color defined by the appBarStyle, based on the color scheme.
    final effectiveAppBarColor = appBarStyle.effectiveAppBarColor(this);

    // Returns a ThemeData that is constructed from the ZetaColorScheme.
    final barTheme = appBarTheme(primaryTextTheme, effectiveAppBarColor);

    return ThemeData(
      colorScheme: this,
      appBarTheme: barTheme,
      useMaterial3: useMaterial3,
      bottomAppBarTheme: bottomAppBarTheme(),
      bottomNavigationBarTheme: bottomNavigationBarTheme(textTheme),
      bottomSheetTheme: bottomSheetTheme(),
      brightness: brightness,
      canvasColor: surface,
      cardTheme: cardTheme(),
      checkboxTheme: checkboxTheme(),
      chipTheme: chipThemeData(textTheme),
      datePickerTheme: datePickerTheme(barTheme),
      dividerColor: zetaColors.borderSubtle,
      dividerTheme: dividerTheme(),
      elevatedButtonTheme: elevatedButtonTheme(primaryTextTheme),
      fontFamily: fontFamily,
      iconTheme: iconTheme(color: zetaColors.iconDefault),
      indicatorColor: secondary,
      inputDecorationTheme: inputDecorationTheme(textTheme),
      listTileTheme: listTileTheme(textTheme),
      outlinedButtonTheme: outlinedButtonTheme(primaryTextTheme),
      popupMenuTheme: popupMenuTheme(textTheme),
      primaryColor: primary,
      primaryIconTheme: iconTheme(color: onPrimary),
      primaryTextTheme: primaryTextTheme,
      progressIndicatorTheme: progressIndicatorTheme(),
      radioTheme: radioThemeData(),
      scaffoldBackgroundColor: background,
      searchBarTheme: searchBarTheme(textTheme),
      shadowColor: zetaColors.borderDisabled.withOpacity(0.7),
      sliderTheme: sliderTheme(),
      splashColor: zetaColors.surfaceSelected,
      switchTheme: switchTheme(),
      tabBarTheme: tabBarTheme(textTheme),
      textButtonTheme: textButtonTheme(primaryTextTheme),
      textSelectionTheme: textSelectionTheme(),
      textTheme: textTheme,
      dialogTheme: dialogTheme(),
    );
  }
}
