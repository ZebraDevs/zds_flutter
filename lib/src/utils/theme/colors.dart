import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../zds_flutter.dart';
import '../tools/app.dart';
import 'theme_loader.dart';

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
    final HSVColor hsvColor = HSVColor.fromColor(this);
    return hsvColor.hue >= 0 && hsvColor.hue <= 180;
  }
}

/// Class that defines all colors to be used in Zds.
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

  /// Green color
  ///
  /// Typically used to show success.
  ///
  /// Defaults to #00B400, if not overridden by [ZetaColors].
  static final Color green = appZetaColors?.green ?? const Color(0xff00B400);

  /// Yellow color
  ///
  /// Typically used to show warning.
  ///
  /// Defaults to #FFD200c
  static final Color yellow = appZetaColors?.yellow ?? const Color(0xffFFD200);

  /// Orange color
  ///
  /// Defaults to #FF8000, unless overridden by [ZetaColors].
  static final Color orange = appZetaColors?.orange ?? const Color(0xffFF8000);

  /// Red color
  ///
  /// Typically used to show an error.
  ///
  /// Defaults to #ED1C24, unless overridden by [ZetaColors].
  static final Color red = appZetaColors?.red ?? const Color(0xffED1C24);

  /// Purple color
  ///
  /// Defaults to #6400D6, unless overridden by [ZetaColors].
  static final Color purple = appZetaColors?.purple ?? const Color(0xff6400D6);

  /// Blue color
  ///
  /// Defaults to #0073E6, unless overridden by [ZetaColors].
  static final Color blue = appZetaColors?.blue ?? const Color(0xff0073E6);

  /// Teal color
  ///
  /// Defaults to #017474, unless overridden by [ZetaColors].
  static final Color teal = appZetaColors?.teal ?? const Color(0xff017474);

  /// Black color
  ///
  /// Typically used for text as this is not total black, but easier on the eyes.
  ///
  /// Defaults to #171717, unless overridden by [ZetaColors].
  static final Color black = appZetaColors?.black ?? const Color(0xff171717);

  ///Dark-grey color
  ///
  /// #4C4C4C, unless overridden by [ZetaColors].
  static final Color darkGrey = appZetaColors?.cool.shade70 ?? const Color(0xff4c4c4c);

  /// Blue-grey color
  ///
  /// #616976, unless overridden by [ZetaColors].
  static final Color blueGrey = appZetaColors?.cool.shade60 ?? const Color(0xff616976);

  /// Light-grey color
  ///
  /// #D1D5DC, unless overridden by [ZetaColors].
  static final Color lightGrey = appZetaColors?.cool.shade40 ?? const Color(0xffD1D5DC);

  /// White color
  ///
  /// #FFFFFF, unless overridden by [ZetaColors].
  static final Color white = appZetaColors?.white ?? const Color(0xffFFFFFF);

  /// Transparent color
  ///
  /// #FFFFFF with 0% opacity
  static const Color transparent = Color(0x00000000);

  /// Splash color.
  ///
  /// Typically used for inkwell splash color
  ///
  /// #171717 with 10% opacity
  static final Color splashColor = ZdsColors.black.withOpacity(0.1);

  /// Shadow color.
  ///
  /// Used on cards and tiles to create the shadow.
  static final Color shadowColor = appZetaColors?.shadow ?? const Color(0x1A49505E);

  /// Barrier color.
  ///
  /// Used as a background scrim for modals.
  static const Color barrierColor = Color(0x80000000);

  /// Shadow color with 100% opacity.
  ///
  /// Typically used with a level of opacity, i.e. `shadowColor100.withOpacity(0.4`
  ///
  /// Used on cards and tiles to create the shadow.
  static const Color shadowColor100 = Color(0xFF49505E);

  /// Hover color
  ///
  /// Typically used to show what the user has hovered on.
  ///
  /// [ZdsColors.darkGrey] with 1.5% opacity
  static final Color hoverColor = ZdsColors.darkGrey.withOpacity(0.015);

  /// Swatch of green colors.
  ///
  /// * Light - #EBFDDE
  /// * Medium - #00B400
  /// * Dark - #006F00
  static final ColorSwatch<String> greenSwatch =
      ColorSwatch<String>(appZetaColors?.green.shade60.value ?? 0xff00B400, <String, Color>{
    'light': appZetaColors?.green.shade30 ?? const Color(0xffEBFDDE),
    'medium': appZetaColors?.green.shade60 ?? green,
    'dark': appZetaColors?.green.shade80 ?? const Color(0xff006F00),
  });

  /// Swatch of red colors.
  ///
  /// * Fair - #f5E8E8
  /// * Light - #DDB8B8
  /// * Medium - fED1C24
  /// * Dark - #C81C00
  static final ColorSwatch<String> redSwatch =
      ColorSwatch<String>(appZetaColors?.red.shade60.value ?? 0xffED1C24, <String, Color>{
    'fair': appZetaColors?.red.shade10 ?? const Color(0xfff5E8E8),
    'light': appZetaColors?.red.shade30 ?? const Color(0xffDDB8B8),
    'medium': appZetaColors?.red.shade60 ?? red,
    'dark': appZetaColors?.red.shade80 ?? const Color(0xffC81C00),
  });

  /// Requires that a [BuildContext] that contains Zds is passed. Can be called using:
  /// ```dart
  /// Container(color: ZdsColors.greySwatch(context)[500])
  /// ```
  static MaterialColor greySwatch(BuildContext context) {
    final bool isWarm = Theme.of(context).colorScheme.background != greyCoolSwatch[50];
    return isWarm ? greyWarmSwatch : greyCoolSwatch;
  }

  /// Gets MaterialColor swatch for shades of the primary color.
  /// Requires that a [BuildContext] that contains Zds is passed. Can be called using:
  /// ```dart
  /// Container(color: ZdsColors.primarySwatch(context)[500])
  /// ```
  static MaterialColor primarySwatch(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return MaterialColor(primary.value, <int, Color>{
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
    return MaterialColor(secondary.value, <int, Color>{
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
  static MaterialColor greyCoolSwatch = MaterialColor(appZetaColors?.cool.shade60.value ?? 0xFF616976, <int, Color>{
    50: appZetaColors?.cool.shade10 ?? const Color(0xffE6EDFA),
    100: appZetaColors?.cool.shade10 ?? const Color(0xffE0E8F5),
    200: appZetaColors?.cool.shade20 ?? const Color(0xffD6DEEB),
    300: appZetaColors?.cool.shade30 ?? const Color(0xffCCD4E0),
    400: appZetaColors?.cool.shade40 ?? const Color(0xffC2C9D6),
    500: appZetaColors?.cool.shade50 ?? const Color(0xffB8BFCC),
    600: appZetaColors?.cool.shade60 ?? const Color(0xffA8B0BD),
    700: appZetaColors?.cool.shade70 ?? const Color(0xff9199A6),
    800: appZetaColors?.cool.shade80 ?? const Color(0xff7A828F),
    900: appZetaColors?.cool.shade90 ?? const Color(0xff616976),
    1000: appZetaColors?.cool.shade100 ?? const Color(0xff4F5763),
    1100: appZetaColors?.cool.shade100 ?? const Color(0xff38404D),
    1200: appZetaColors?.cool.shade100 ?? const Color(0xff1A212E),
  });

  /// Swatch of warm grey colors to be used with a warm theme.
  static MaterialColor greyWarmSwatch = MaterialColor(appZetaColors?.warm.shade60.value ?? 0xFF4C4C4C, <int, Color>{
    50: appZetaColors?.warm.shade10 ?? const Color(0xffFAFAFA),
    100: appZetaColors?.warm.shade10 ?? const Color(0xffF5F5F5),
    200: appZetaColors?.warm.shade20 ?? const Color(0xffEBEBEB),
    300: appZetaColors?.warm.shade30 ?? const Color(0xffE1E1E1),
    400: appZetaColors?.warm.shade40 ?? const Color(0xffD7D7D7),
    500: appZetaColors?.warm.shade50 ?? const Color(0xffCDCDCD),
    600: appZetaColors?.warm.shade60 ?? const Color(0xffBDBDBD),
    700: appZetaColors?.warm.shade70 ?? const Color(0xffA6A6A6),
    800: appZetaColors?.warm.shade80 ?? const Color(0xff8E8E8E),
    900: appZetaColors?.warm.shade90 ?? const Color(0xff757575),
    1000: appZetaColors?.warm.shade100 ?? const Color(0xff636363),
    1100: appZetaColors?.warm.shade100 ?? const Color(0xff4C4C4C),
    1200: appZetaColors?.warm.shade100 ?? const Color(0xff2E2E2E),
  });

  /// Const definition needed for input border.
  static const Color inputBorderColor = Color(0xFFBDBDBD);
  // TODO(colors): replace this with reference to Zeta.
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

  /// Color Scheme to use in light mode.
  final ColorScheme light;

  ///Color scheme to use in dark mode.
  final ColorScheme dark;

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
