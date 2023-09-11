import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// Provides the Zds Theme to all children in the app
class ThemeProvider extends StatefulWidget {
  /// Builds the child.
  final Widget Function(
    BuildContext context,
    BrandColors colors,
    // ignore: avoid_positional_boolean_parameters
    bool isDarkMode,
  ) builder;

  /// Set of colors to theme the components within the app.
  final BrandColors colors;

  /// True if the app should run in dark mode.
  ///
  /// Not yet supported.
  final bool isDarkMode;

  /// Constructs a ThemeProvider
  const ThemeProvider({
    required this.builder,
    required this.colors,
    super.key,
    this.isDarkMode = false,
  });

  @override
  ThemeProviderState createState() => ThemeProviderState();

  /// Returns an ancestor ThemeProvider from context.
  ///
  /// If no theme provider is found this will throw an error.
  static ThemeProviderState? of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeProviderState>();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<Widget Function(BuildContext context, BrandColors colors, bool isDarkMode)>.has(
        'builder',
        builder,
      ),
    );
    properties.add(DiagnosticsProperty<BrandColors>('colors', colors));
    properties.add(DiagnosticsProperty<bool>('isDarkMode', isDarkMode));
  }
}

/// State for [ThemeProvider].
class ThemeProviderState extends State<ThemeProvider> {
  /// Custom brand colors provided to the theme.
  late BrandColors colors;

  /// True if dark mode is to be used.
  late bool isDarkMode;

  /// Sets [colors].
  void setColors(BrandColors brandColors) {
    if (colors == brandColors) return;
    setState(() {
      colors = brandColors;
    });
  }

  /// Sets [isDarkMode].
  void setDarkMode({bool isDark = false}) {
    if (isDark == isDarkMode) return;
    setState(() {
      isDarkMode = isDark;
    });
  }

  /// Toggles [isDarkMode] boolean value.
  void toggleDarkMode() => setState(() => isDarkMode = !isDarkMode);

  @override
  void initState() {
    colors = widget.colors;
    isDarkMode = widget.isDarkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, colors, isDarkMode);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BrandColors>('colors', colors));
    properties.add(DiagnosticsProperty<bool>('isDarkMode', isDarkMode));
  }
}
