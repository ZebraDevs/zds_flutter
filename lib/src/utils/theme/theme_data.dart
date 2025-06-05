import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../theme.dart';
import '../tools/utils.dart';

class _ZdsBaseColors {
  _ZdsBaseColors({required this.primary, required this.secondary, required this.error});

  factory _ZdsBaseColors.fromJson(Map<String, dynamic>? json) {
    // Extracts primary, secondary, and error colors from JSON, with default fallbacks.
    final primary = (json?['primary'] as String?)?.toColor() ?? const ZetaPrimitivesLight().blue;
    final secondary = (json?['secondary'] as String?)?.toColor() ?? const ZetaPrimitivesLight().blue;

    var error = (json?['error'] as String?)?.toColor();
    if (error == null && isShadeOfRed(primary)) {
      error = const ZetaPrimitivesLight().warm;
    } else {
      error = const ZetaPrimitivesLight().red;
    }

    return _ZdsBaseColors(primary: primary, secondary: secondary, error: error);
  }

  final Color primary;
  final Color secondary;
  final Color error;

  static bool isShadeOfRed(Color color) {
    // Get the red, green, and blue components of the color
    final red = color.r;
    final green = color.g;
    final blue = color.b;

    // Check if the red component is dominant
    return red > green && red > blue;
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary.toHex(),
      'secondary': secondary.toHex(),
      'error': error.toHex(),
    };
  }
}

/// Class to allow custom color definitions in dark and light modes and used with new [ZetaProvider]
///
/// This class holds the definitions for themes in both Dark and Light mode.
/// These definitions are later used by `ZetaProvider` class.
///
/// See also:
/// * [ZetaProvider]
/// * [Zeta]
/// * [ZetaColors]
/// * [ZetaAppBarStyle]
@immutable
class ZdsThemeData {
  /// Creates a `ZdsThemeData`.
  ///
  /// The [themeMode] must not be null.
  ///
  /// The [themeMode] parameter, which is required, defines the theme mode for the [Zeta], and defaults to [ThemeMode.system].
  // /// The [darkAppBarStyle] parameter defines the AppBar style for the dark theme, used to select the colors used in AppBarTheme style from [ZetaColorScheme]. Defaults to [ZetaAppBarStyle.surface].
  // /// The [lightAppBarStyle] parameter defines the AppBar style for the light theme, used to select the colors used in AppBarTheme style from [ZetaColorScheme]. Defaults to [ZetaAppBarStyle.primary].
  const ZdsThemeData._({
    // required this.themeData,
    required this.themeMode,
    required this.darkAppBarStyle,
    required this.lightAppBarStyle,
    required this.contrast,
    required this.adjustAccessibility,
    required this.fontFamily,
    required _ZdsBaseColors lightColors,
    required _ZdsBaseColors darkColors,
  })  : _lightColors = lightColors,
        _darkColors = darkColors;

  /// Creates a default [ZdsThemeData] instance with predefined settings.
  ///
  /// This factory constructor initializes a [ZdsThemeData] object with a set of default values. It is useful for creating a standard theme data configuration that can be used across the app when specific customizations are not required.
  ///
  /// The default settings include:
  /// - A primary and secondary color set to blue.
  /// - An error color set to red.
  /// - The theme mode set to the system's default.
  /// - Default styles for both dark and light app bar styles.
  /// - A default contrast level.
  /// - Accessibility adjustments set to false.
  /// - The same color settings applied for both light and dark themes.
  factory ZdsThemeData.defaultData() {
    // Initialize base colors with default primary, secondary, and error colors.
    final baseColors = _ZdsBaseColors(
      primary: const ZetaPrimitivesLight().blue, // Default primary color set to blue.
      secondary: const ZetaPrimitivesLight().blue, // Default secondary color set to blue.
      error: const ZetaPrimitivesLight().red, // Default error color set to red.
    );

    // Return a new instance of ZdsThemeData with default settings.
    return ZdsThemeData._(
      // themeData: ThemeData(),
      // themeData: generateZetaTheme(brightness: Brightness.light, colorScheme: , textTheme: textTheme),
      // themeData: ZetaThemeData(),
      // Initialize with default ZetaThemeData.
      themeMode: ThemeMode.system,
      // Use system default theme mode.
      darkAppBarStyle: ZetaAppBarStyle.surface,
      // Default style for dark app bar.
      lightAppBarStyle: ZetaAppBarStyle.primary,
      // Default style for light app bar.
      contrast: ZetaContrast.aa,
      // Set default contrast level.
      adjustAccessibility: false,
      // Accessibility adjustments are turned off by default.
      lightColors: baseColors,
      // Apply the base colors to light theme.
      darkColors: baseColors, // Apply the same base colors to dark theme.
      fontFamily: kZetaFontFamily,
    );
  }

  /// Factory constructor for creating [ZdsThemeData] from a JSON map.
  factory ZdsThemeData.fromJson(Map<String, dynamic> json) {
    // Determines if accessibility adjustments are needed.
    final adjustAccessibility = json['adjustAccessibility'] as bool? ?? false;

    // Determines the contrast level, defaulting to 'aa' if not specified as 'aaa'.
    final contrast = _zetaContrast(json);

    // Determines theme mode
    final themeMode = _themeMode(json);

    final light = json['light'] as Map<String, dynamic>?;
    final dark = json['dark'] as Map<String, dynamic>?;

    final lightColors = _ZdsBaseColors.fromJson(light);
    final darkColors = dark != null ? _ZdsBaseColors.fromJson(light) : lightColors;

    final fontFamily = json['fontFamily'] as String? ?? kZetaFontFamily;

    return ZdsThemeData._(
      themeMode: themeMode,
      contrast: contrast,
      lightColors: lightColors,
      darkColors: darkColors,
      adjustAccessibility: adjustAccessibility,
      lightAppBarStyle: _zetaAppBarStyle(light),
      darkAppBarStyle: _zetaAppBarStyle(dark),
      fontFamily: fontFamily,
      // themeData: _zetaThemeDataFromJson(
      //   json,
      //   contrast,
      //   adjustAccessibility,
      //   lightColors,
      //   darkColors,
      // ),
    );
  }

  /// Creates a new instance of [ZdsThemeData] from a JSON format string.
  ///
  /// The [json] parameter is a JSON string that conforms to the structure of [ZdsThemeData].
  /// Example:
  /// {
  ///   "identifier": "default",
  ///   "themeMode": "system", // Possible values "dark", "light", "system"
  ///   "contrast": "aa", // Possible values "aa", "aaa"
  ///   "fontFamily": "packages/zeta_flutter/IBMPlexSans",
  ///   "adjustAccessibility": true,
  ///   "light": {
  ///     "appBarStyle": "primary", // Possible values "surface", "background", "secondary", "primary"
  ///     "primary": "#0073e6",
  ///     "secondary": "#0073e6",
  ///     "error": "#D70015"
  ///   },
  ///   "dark": {
  ///     "appBarStyle": "surface", // Possible values "surface", "background", "secondary", "primary"
  ///     "primary": "#0073e6",
  ///     "secondary": "#0073e6",
  ///     "error": "#D70015"
  ///   }
  /// }
  ///
  ///
  /// This string is parsed to a Map using the [_parseJson] helper method, and then
  /// it's used to construct a new instance of [ZdsThemeData].
  ///
  /// Returns a new [ZdsThemeData] object from JSON data.
  factory ZdsThemeData.fromJsonString(String json) {
    return ZdsThemeData.fromJson(_parseJson(json));
  }

  /// Asynchronously creates an instance of [ZdsThemeData] from the JSON file at the given [path].
  ///
  /// [path] represents the location of the JSON file in your application assets.
  ///
  /// The JSON data is expected to be a serialized version of the [ZdsThemeData] object.
  ///
  /// Returns a Future that completes with the [ZdsThemeData] once it has been loaded and parsed.
  static Future<ZdsThemeData> fromAssets(String path) async {
    final json = await _readAsset(path);
    return ZdsThemeData.fromJsonString(json);
  }

  // /// Theme data to be used with [ZetaProvider]
  // ///
  // /// This field hold the instance of [ZetaThemeServiceData] which is used by `ZetaProvider` class.
  // final ZetaThemeServiceData themeData;

  /// The theme mode for the [Zeta]
  ///
  /// It defaults to [ThemeMode.system]
  /// This holds the mode of the theme which is by default set to [ThemeMode.system].
  final ThemeMode themeMode;

  /// AppBar style for the dark theme
  ///
  /// This holds the AppBar style for dark theme mode which is used to
  /// select the colors from [ZetaColors].
  final ZetaAppBarStyle darkAppBarStyle;

  /// AppBar style for the light theme
  ///
  /// This holds the AppBar style for light theme mode which is used to
  /// select the colors from [ZetaColors].
  final ZetaAppBarStyle lightAppBarStyle;

  /// Represents the Zeta accessibility standard.
  /// {@macro zeta-color-dark}
  final ZetaContrast contrast;

  /// Decides if accessibility adjustments should be applied to colors.
  ///
  /// Defaults to false
  final bool adjustAccessibility;

  /// Base light colors, used internally to save and retrieve the colors from JSON
  final _ZdsBaseColors _lightColors;

  /// Base dark colors, used internally to save and retrieve the colors from JSON
  final _ZdsBaseColors _darkColors;

  /// Font override to use
  final String fontFamily;

  /// Converts the [ZdsThemeData] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      // 'identifier': themeData.identifier,
      'themeMode': _themeModeToString(themeMode),
      // 'fontFamily': themeData.fontFamily,
      'adjustAccessibility': adjustAccessibility,
      'contrast': _contrastToString(contrast),
      'light': {
        'appBarStyle': _zetaAppBarStyleToString(lightAppBarStyle),
        ..._lightColors.toJson(),
      },
      'dark': {
        'appBarStyle': _zetaAppBarStyleToString(darkAppBarStyle),
        ..._darkColors.toJson(),
      },
    };
  }

  static ZetaContrast _zetaContrast(Map<String, dynamic> json) {
    final contrastString = json['contrast'] as String?;
    final contrast = contrastString == 'aaa' ? ZetaContrast.aaa : ZetaContrast.aa;
    return contrast;
  }

  static ThemeMode _themeMode(Map<String, dynamic> json) {
    final themModeString = json['themeMode'] as String?;
    final themeMode = themModeString == 'light'
        ? ThemeMode.light
        : themModeString == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
    return themeMode;
  }

  static ZetaAppBarStyle _zetaAppBarStyle(Map<String, dynamic>? json) {
    final appBarStyleString = json?['appBarStyle'] as String?;
    return appBarStyleString == 'surface'
        ? ZetaAppBarStyle.surface
        : appBarStyleString == 'secondary'
            ? ZetaAppBarStyle.secondary
            : ZetaAppBarStyle.primary;
  }

  // // /// Parses the given JSON map into [ZetaThemeServiceData].
  // static ZetaThemeServiceData _zetaThemeDataFromJson(
  //   Map<String, dynamic> json,
  //   ZetaContrast contrast,
  //   bool adjustAccessibility,
  //   _ZdsBaseColors lightColors,
  //   _ZdsBaseColors darkColors,
  // ) {
  //   // Constructs and returns a new instance of ZetaThemeData.
  //   final light = _colors(lightColors, Brightness.light, contrast, adjustAccessibility);
  //   final dark = _colors(darkColors, Brightness.dark, contrast, adjustAccessibility);

  //   return ZetaThemeServiceData(
  //     identifier: json['identifier'] as String? ?? 'default',
  //     // Sets the identifier, defaulting to 'default'.
  //     fontFamily: json['fontFamily'] as String? ?? kZetaFontFamily,
  //     // Sets the font family, with a default value.
  //     contrast: contrast,
  //     // Sets the determined contrast.
  //     colorsLight: light,
  //     // Processes light theme colors.
  //     colorsDark: dark, // Processes dark theme colors.
  //   );
  // }

  /// Creates a [ZetaColors] object from the given JSON, brightness, and contrast.
  // static ZetaColors _colors(
  //   _ZdsBaseColors colors,
  //   Brightness brightness,
  //   ZetaContrast contrast,
  //   bool adjustAccessibility,
  // ) {
  //   // Helper function to create a color swatch based on the given base color.
  //   ZetaColorSwatch swatch(Color base) => ZetaColorSwatch.fromColor(base).apply(brightness: brightness);

  //   // Returns either a dark or light themed [ZetaColors] object based on the brightness.
  //   return brightness == Brightness.dark
  //       ? ZetaColors.dark(
  //           contrast: contrast,
  //           primary: swatch(colors.primary),
  //           secondary: swatch(colors.mainSecondary),
  //           error: swatch(colors.error),
  //         )
  //       : ZetaColors.light(
  //           contrast: contrast,
  //           primary: swatch(colors.primary),
  //           secondary: swatch(colors.mainSecondary),
  //           error: swatch(colors.error),
  //         );
  // }

  /// Helper function to convert [ThemeMode] to string representation.
  static String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Helper function to convert [ZetaAppBarStyle] to string representation.
  static String _zetaAppBarStyleToString(ZetaAppBarStyle appBarStyle) {
    switch (appBarStyle) {
      case ZetaAppBarStyle.surface:
        return 'surface';
      case ZetaAppBarStyle.secondary:
        return 'secondary';
      case ZetaAppBarStyle.primary:
        return 'primary';
    }
  }

  /// Converts [ZetaContrast] to string.
  static String _contrastToString(ZetaContrast contrast) {
    return contrast == ZetaContrast.aaa ? 'aaa' : 'aa';
  }

  /// Private helper function that reads a JSON file from the application assets.
  ///
  /// [path] is the location of the JSON file.
  ///
  /// Returns a Future that completes with a `Map<String, dynamic>` once the file has been loaded and decoded.
  /// If an error occurs during loading or decoding, it catches the exception and returns an empty Map.
  static Future<String> _readAsset(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      return '{}';
    }
  }

  /// Parses a JSON string and returns it as a Map.
  ///
  /// The [jsonString] argument is a JSON string that will be parsed into a `Map<String, dynamic>`.
  ///
  /// This method tries to decode the given JSON string. If an error occurs during decoding,
  /// it catches the exception and returns an empty Map.
  static Map<String, dynamic> _parseJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  /// Creates a copy of this [ZdsThemeData] but with the given fields replaced with the new values.
  ///
  /// [themeMode] (optional): Specifies the mode of the theme - light, dark etc. If a themeMode
  /// is not provided, it will default to the current [ZdsThemeData] theme mode.
  ///
  /// [darkAppBarStyle] (optional): Defines the style of the app bar in dark theme. If not provided,
  /// it will use the existing style from this [ZdsThemeData] for the dark app bar style.
  ///
  /// [lightAppBarStyle] (optional): Same as [darkAppBarStyle], but for light theme.
  ///
  /// [contrast] (optional): Specifies the contrast level for the theme. If not provided,
  /// it defaults to the current contrast level of this [ZdsThemeData] instance.
  ///
  /// [adjustAccessibility] (optional): Boolean value that controls whether to adjust the accessibility
  /// options depending on the theme contrast. If not provided, it will preserve the original value
  /// of [adjustAccessibility] from this [ZdsThemeData] instance.
  ///
  /// Returns a new [ZdsThemeData] instance.
  ZdsThemeData copyWith({
    ZetaCustomTheme? themeData,
    ThemeMode? themeMode,
    ZetaAppBarStyle? darkAppBarStyle,
    ZetaAppBarStyle? lightAppBarStyle,
    ZetaContrast? contrast,
    bool? adjustAccessibility,
    String? fontFamily,
  }) {
    var lightColors = _lightColors;
    var darkColors = _darkColors;

    if (themeData != null) {
      lightColors = _ZdsBaseColors(
        primary: themeData.primary ?? const ZetaPrimitivesLight().blue,
        secondary: themeData.secondary ?? const ZetaPrimitivesLight().blue,
        error: const ZetaPrimitivesLight().red,
      );

      darkColors = _ZdsBaseColors(
        primary: themeData.primaryDark ?? const ZetaPrimitivesDark().blue,
        secondary: themeData.secondaryDark ?? const ZetaPrimitivesDark().blue,
        error: const ZetaPrimitivesDark().red,
      );
    }

    return ZdsThemeData._(
      lightColors: lightColors,
      darkColors: darkColors,
      // themeData:
      // themeData: ThemeData(),
      // themeData: themeData ?? this.themeData,
      themeMode: themeMode ?? this.themeMode,
      darkAppBarStyle: darkAppBarStyle ?? this.darkAppBarStyle,
      lightAppBarStyle: lightAppBarStyle ?? this.lightAppBarStyle,
      contrast: contrast ?? this.contrast,
      adjustAccessibility: adjustAccessibility ?? this.adjustAccessibility,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  /// Converts ZDS legacy theme to Zeta theme.
  ZetaCustomTheme toCustomTheme() {
    return ZetaCustomTheme(
      id: 'zds',
      primary: _lightColors.primary,
      secondary: _lightColors.secondary,
      primaryDark: _darkColors.primary,
      secondaryDark: _darkColors.secondary,
    );
  }
}

/// Returns a map of colors shades with their respective indexes.
class ZetaSwatchGenerator {
  /// Darker shades are obtained by darkening the primary color and
  /// lighter shades by lightening it.
  ///
  /// - 100, 90, 80, and 70 are darker shades of the primary color.
  /// - 60 is the primary color itself.
  /// - 50, 40, 30, 20, and 10 are progressively lighter shades of the primary color.
  static ZetaColorSwatch generate(
    Color primary, {
    Brightness brightness = Brightness.light,
    ZetaContrast contrast = ZetaContrast.aa,
    Color background = Colors.white,
    bool adjustAccessibility = false,
  }) {
    return ZetaColorSwatch(
      // contrast: contrast,
      // brightness: brightness,
      primary: primary.toARGB32(),
      swatch: primary.generateSwatch(background: background, adjustPrimary: adjustAccessibility),
    ).apply(brightness: brightness);
  }
}
