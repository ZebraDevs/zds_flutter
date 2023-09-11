import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../zds_flutter.dart';
import '../tools/app.dart';
import 'theme_loader.dart';

ZetaColors get _zetaColors => appZetaColors ?? ZetaColors();
late ColorScheme? _colorScheme;

/// Utility extensions on Color.
extension ColorUtils on Color {
  /// This function calculates the luminance of the given color and returns either false or true based
  /// on whether the luminance is greater than 0.5 or not. The higher the luminance, the lighter the color.
  /// A luminance of 0.5 is considered the threshold to determine if the color is light or dark.
  bool get isDark => computeLuminance() <= 0.5;

  /// Determines if a color is dark taking into account its opacity.
  bool isDarkWithOpacity({Color? background}) => Color.alphaBlend(this, background ?? _colorScheme!.background).isDark;

  /// This getter on the Color class that determines if the color is warm or not.
  /// We can use the Hue-Saturation-Value (HSV) representation of the color.
  /// A color is generally considered warm if its hue lies between 0 and 180 degrees.
  bool get isWarm {
    final hsvColor = HSVColor.fromColor(this);
    return hsvColor.hue >= 0 && hsvColor.hue <= 180;
  }
}

/// Class that defines all colors to be used in the ZdsComponents
///
///
/// [greySwatch], [primarySwatch] and [secondarySwatch] all require a context be passed in that is a child of [ZdsApp],
/// like so:
/// ```dart
/// Container(color: ZdsColors.greySwatch(context)[500])
/// ```
///
/// All the other colors can be called directly without the context:
/// ```dart
/// Container(color: ZdsColors.darkGrey)
/// ```
class ZdsColors {
  ZdsColors._();

  /// Green color.
  ///
  /// Typically used to show success.
  static final green = _zetaColors.green.primary;

  /// Yellow color.
  ///
  /// Typically used to show warning.
  static final yellow = _zetaColors.yellow.primary;

  ///Orange color.
  static final orange = _zetaColors.orange.primary;

  /// Red color.
  ///
  /// Typically used to show an error.
  static final red = _zetaColors.red.primary;

  /// Purple color.
  static final purple = _zetaColors.purple.primary;

  /// Blue color.
  static final blue = _zetaColors.blue.primary;

  /// Teal color.
  static final teal = _zetaColors.teal.primary;

  /// Black color.
  ///
  /// Default text color.
  static final black = _zetaColors.textDefault;

  ///Dark-grey color
  ///
  /// Subtle text color.
  static final darkGrey = _zetaColors.textSubtle;

  /// Blue-grey color
  static final blueGrey = _zetaColors.cool.shade60;

  /// Light-grey color
  static final lightGrey = _zetaColors.cool.shade40;

  /// White color
  ///
  /// #FFFFFF
  static final white = _zetaColors.white;

  /// Transparent color
  ///
  /// #FFFFFF with 0% opacity
  static const Color transparent = Color(0x00000000);

  /// Splash color.
  ///
  /// Typically used for inkwell splash color
  ///
  /// #171717 with 10% opacity
  static final splashColor = _zetaColors.black.withOpacity(0.1);

  /// Shadow color.
  ///
  /// Used on cards and tiles to create the shadow.
  static final shadowColor = _zetaColors.shadow;

  /// Barrier color.
  ///
  /// Used as a background scrim for modals.
  static const barrierColor = Color(0x80000000);

  /// Shadow color with 100% opacity.
  ///
  /// Typically used with a level of opacity, i.e. `shadowColor100.withOpacity(0.4`
  ///
  /// Used on cards and tiles to create the shadow.
  static const shadowColor100 = Color(0xFF49505E);

  /// Hover color
  ///
  /// Typically used to show what the user has hovered on.
  static final hoverColor = _zetaColors.isDarkMode ? _zetaColors.black : _zetaColors.surfaceHovered;

  /// Swatch of green colors.

  static final ColorSwatch<String> greenSwatch = ColorSwatch(_zetaColors.green.shade60.value, {
    'light': _zetaColors.green.shade30,
    'medium': _zetaColors.green.shade60,
    'dark': _zetaColors.green.shade80,
  });

  /// Swatch of red colors.
  static final ColorSwatch<String> redSwatch = ColorSwatch(_zetaColors.red.shade60.value, {
    'fair': _zetaColors.red.shade10,
    'light': _zetaColors.red.shade30,
    'medium': _zetaColors.red.shade60,
    'dark': _zetaColors.red.shade80,
  });

  /// Requires that a [BuildContext] that is a child of  [ZdsApp]  is passed. Can be called using:
  /// ```dart
  /// Container(color: ZdsColors.greySwatch(context)[500])
  /// ```
  static MaterialColor greySwatch(BuildContext context) {
    final bool isWarm = Theme.of(context).colorScheme.background != greyCoolSwatch[50];
    return isWarm ? greyWarmSwatch : greyCoolSwatch;
  }

  /// Gets MaterialColor swatch for shades of the primary color.
  /// Requires that a [BuildContext] that is a child of  [ZdsApp]  is passed. Can be called using:
  /// ```dart
  /// Container(color: ZdsColors.primarySwatch(context)[500])
  /// ```
  static MaterialColor primarySwatch(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return MaterialColor(primary.value, {
      50: getShadedColor(primary, 0.05),
      100: getShadedColor(primary, 0.1),
      200: getShadedColor(primary, 0.2),
      300: getShadedColor(primary, 0.3),
      400: getShadedColor(primary, 0.4),
      500: getShadedColor(primary, 0.5),
      600: getShadedColor(primary, 0.6),
      700: getShadedColor(primary, 0.7),
      800: getShadedColor(primary, 0.8),
      900: getShadedColor(primary, 0.9),
      1000: getShadedColor(primary, 1),
    });
  }

  /// Gets MaterialColor swatch for shades of the secondary color
  /// Requires that a [BuildContext] that is a child of  [ZdsApp]  is passed. Can be called using:
  /// ```dart
  /// Container(color: ZdsColors.secondarySwatch(context)[500])
  /// ```
  static MaterialColor secondarySwatch(BuildContext context) {
    final Color secondary = Theme.of(context).colorScheme.secondary;
    return MaterialColor(secondary.value, {
      50: getShadedColor(secondary, 0.05),
      100: getShadedColor(secondary, 0.1),
      200: getShadedColor(secondary, 0.2),
      300: getShadedColor(secondary, 0.3),
      400: getShadedColor(secondary, 0.4),
      500: getShadedColor(secondary, 0.5),
      600: getShadedColor(secondary, 0.6),
      700: getShadedColor(secondary, 0.7),
      800: getShadedColor(secondary, 0.8),
      900: getShadedColor(secondary, 0.9),
    });
  }

  /// Swatch of cool grey colors to be used with a cool theme.
  static final MaterialColor greyCoolSwatch = MaterialColor(_zetaColors.cool.shade60.value, {
    50: _zetaColors.cool.shade10,
    100: _zetaColors.cool.shade10,
    200: _zetaColors.cool.shade20,
    300: _zetaColors.cool.shade30,
    400: _zetaColors.cool.shade40,
    500: _zetaColors.cool.shade50,
    600: _zetaColors.cool.shade60,
    700: _zetaColors.cool.shade70,
    800: _zetaColors.cool.shade80,
    900: _zetaColors.cool.shade90,
    1000: _zetaColors.cool.shade100,
    1100: _zetaColors.cool.shade100,
    1200: _zetaColors.cool.shade100,
  });

  /// Swatch of warm grey colors to be used with a warm theme.
  ///
  /// NOTE: Colors come from zeta, and so 50,1100 and 1200 no longer exist and will be their nearest values.
  static final MaterialColor greyWarmSwatch = MaterialColor(_zetaColors.warm.shade60.value, {
    50: _zetaColors.warm.shade10,
    100: _zetaColors.warm.shade10,
    200: _zetaColors.warm.shade20,
    300: _zetaColors.warm.shade30,
    400: _zetaColors.warm.shade40,
    500: _zetaColors.warm.shade50,
    600: _zetaColors.warm.shade60,
    700: _zetaColors.warm.shade70,
    800: _zetaColors.warm.shade80,
    900: _zetaColors.warm.shade90,
    1000: _zetaColors.warm.shade100,
    1100: _zetaColors.warm.shade100,
    1200: _zetaColors.warm.shade100,
  });

  /// Const definition needed for input border.
  // TODO(colors): replace this with reference to Zeta.
  static const Color inputBorderColor = Color(0xFFBDBDBD);

  static const Color _defaultPrimary = Color(0xFF1C3760);
  static const Color _defaultPrimaryContainer = Color(0xFF2A526F);
  static const Color _defaultSecondary = Color(0xFF007ABA);
  static const Color _defaultSecondaryContainer = Color(0xFF2B54A3);
}

/// Class to allow custom color definitions in dark and light modes
///
/// See also:
/// * [ZdsColorScheme]
@immutable
class BrandColors {
  /// Constructs a [BrandColors]
  const BrandColors({
    required this.light,
    required this.dark,
  });

  /// Color Scheme to use in light mode.
  final ColorScheme light;

  ///Color scheme to use in dark mode.
  final ColorScheme dark;

  /// Default color scheme containing Zds theme colors.
  BrandColors.zdsDefault()
      : light = ZdsColorScheme.light(),
        dark = ZdsColorScheme.dark();

  /// Creates a BrandColors from a json object passed in.
  factory BrandColors.fromJson(Map<String, dynamic> json) {
    return BrandColors(
      light: ZdsColorScheme.lightFromJson(json['light'] as Map<dynamic, dynamic>),
      dark: ZdsColorScheme.darkFromJson(json['dark'] as Map<dynamic, dynamic>),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandColors && runtimeType == other.runtimeType && light == other.light && dark == other.dark;

  @override
  int get hashCode => light.hashCode ^ dark.hashCode;
}

/// Builds color schemes that are supported in the Zds Library
/// [ZdsColorScheme.light] and [ZdsColorScheme.dark] optional parameters have the following defaults:
///  * primary: #1C3760
///  * primaryContainer: #2A526F
///  * secondary: #007ABA
///  * secondaryContainer: #2B54A3
///  * error: #ED1C24
class ZdsColorScheme extends ColorScheme {
  /// Constructs a light theme.
  ///
  /// All parameters are optional, and if not provided the fallback will be the Zds default colors.
  ZdsColorScheme.light({
    Color? primary,
    Color? primaryContainer,
    Color? secondary,
    Color? secondaryContainer,
    Color? error,
    bool isWarm = true,
  }) : super.light(
          brightness: Brightness.light,
          primary: primary ?? ZdsColors._defaultPrimary,
          onPrimary: computeForeground(primary ?? ZdsColors._defaultPrimary),
          primaryContainer: primaryContainer ?? ZdsColors._defaultPrimaryContainer,
          onPrimaryContainer: computeForeground(primaryContainer ?? ZdsColors._defaultPrimaryContainer),
          secondary: secondary ?? ZdsColors._defaultSecondary,
          onSecondary: computeForeground(secondary ?? ZdsColors._defaultSecondary),
          secondaryContainer: secondaryContainer ?? ZdsColors._defaultSecondaryContainer,
          onSecondaryContainer: computeForeground(secondary ?? ZdsColors._defaultSecondaryContainer),
          surface: ZdsColors.white,
          onSurface: ZdsColors.black,
          background: isWarm ? ZdsColors.greyWarmSwatch[50]! : ZdsColors.greyCoolSwatch[50]!,
          onBackground: isWarm ? ZdsColors.greyWarmSwatch[1200]! : ZdsColors.greyCoolSwatch[1200]!,
          error: error ?? ZdsColors.red,
          onError: computeForeground(error ?? ZdsColors.red),
        );

  /// Constructs a dark theme.
  ///
  /// All parameters are optional, and if not provided the fallback will be the Zds default colors:
  ZdsColorScheme.dark({
    Color? primary,
    Color? primaryContainer,
    Color? secondary,
    Color? secondaryContainer,
    Color? error,
    bool isWarm = true,
  }) : super.dark(
          brightness: Brightness.dark,
          primary: primary ?? ZdsColors._defaultPrimary,
          onPrimary: computeForeground(primary ?? ZdsColors._defaultPrimary),
          primaryContainer: primaryContainer ?? ZdsColors._defaultPrimaryContainer,
          onPrimaryContainer: computeForeground(primaryContainer ?? ZdsColors._defaultPrimaryContainer),
          secondary: secondary ?? ZdsColors._defaultSecondary,
          onSecondary: computeForeground(secondary ?? ZdsColors._defaultSecondary),
          secondaryContainer: secondaryContainer ?? ZdsColors._defaultSecondaryContainer,
          onSecondaryContainer: computeForeground(secondary ?? ZdsColors._defaultSecondaryContainer),
          surface: ZdsColors.black,
          onSurface: ZdsColors.white,
          background: isWarm ? ZdsColors.greyWarmSwatch[1200]! : ZdsColors.greyCoolSwatch[1200]!,
          onBackground: isWarm ? ZdsColors.greyWarmSwatch[50]! : ZdsColors.greyCoolSwatch[50]!,
          error: error ?? ZdsColors.red,
          onError: computeForeground(error ?? ZdsColors.red),
        );

  /// Constructs a light theme from a provided json object.
  ///
  /// Colors should be as hexadecimal colors, and the naming conventions should match [ColorScheme]
  ///
  /// The json object should contain the keys:
  /// * primary
  /// * primaryVariant
  /// * secondary
  /// * secondaryVariant
  /// * error
  factory ZdsColorScheme.lightFromJson(Map<dynamic, dynamic>? json) {
    if (json != null) {
      return ZdsColorScheme.light(
        primary: _toColor(json['primary']),
        primaryContainer: _toColor(json['primaryVariant']),
        secondary: _toColor(json['secondary']),
        secondaryContainer: _toColor(json['secondaryVariant']),
        error: _toColor(json['error']),
      );
    } else {
      return ZdsColorScheme.light();
    }
  }

  /// Constructs a dark theme from a provided json object.
  ///
  /// Colors should be as hexadecimal colors, and the naming conventions should match [ColorScheme]
  ///
  /// The json object should contain the keys:
  /// * primary
  /// * primaryVariant
  /// * secondary
  /// * secondaryVariant
  /// * error
  factory ZdsColorScheme.darkFromJson(Map<dynamic, dynamic>? json) {
    if (json != null) {
      return ZdsColorScheme.dark(
        primary: _toColor(json['primary']),
        primaryContainer: _toColor(json['primaryVariant']),
        secondary: _toColor(json['secondary']),
        secondaryContainer: _toColor(json['secondaryVariant']),
        error: _toColor(json['error']),
      );
    } else {
      return ZdsColorScheme.dark();
    }
  }

  static Color? _toColor(dynamic color) {
    if (color != null && color is String && color.isNotEmpty) {
      return color.toColor();
    } else {
      return null;
    }
  }
}
