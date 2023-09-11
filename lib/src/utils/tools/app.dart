import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zeta_flutter/zeta_flutter.dart';
import '../../../zds_flutter.dart';

/// App wide zeta colors object.
ZetaColors? appZetaColors;

/// A wrapper around MaterialApp that adds Zds styling and other properties.
///
/// Should be used in the same way as MaterialApp.
///
/// ```dart
/// class App extends StatelessWidget {
///   const App({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return ZdsApp(
///       title: 'App',
///       routes: [...],
///     );
///   }
/// }
/// ```
class ZdsApp extends StatelessWidget {
  /// A one line description of the application.
  /// {@macro flutter.widgets.widgetsApp.title}
  final String title;

  /// {@macro flutter.widgets.widgetsApp.home}
  final Widget? home;

  /// Default theme used, to which Zds styles are applied.
  ///
  /// Default visual properties, like colors fonts and shapes, for this app's material widgets.
  ///
  /// The default value of this property is the value of [ThemeData.light()].
  final ThemeData? theme;

  /// {@macro flutter.widgets.widgetsApp.routes}
  final Map<String, WidgetBuilder> routes;

  /// {@macro flutter.widgets.widgetsApp.localizationsDelegates}
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// The initial locale for this app's [Localizations] widget is based on this value.
  ///
  /// If the 'locale' is null then the system's locale value is used.
  ///
  /// The value of [Localizations.locale] will equal this locale if it matches one of the [MaterialApp.supportedLocales]. Otherwise it will be `en`.
  final Locale? localeOverride;

  /// Optional parameter to add custom branded colors to the application.
  ///
  /// See also:
  ///
  /// * [BrandColors]
  final BrandColors? colors;

  /// {@macro flutter.widgets.widgetsApp.onGenerateRoute}
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;

  /// {@macro flutter.widgets.widgetsApp.initialRoute}
  final String? initialRoute;

  /// {@macro flutter.widgets.widgetsApp.onGenerateInitialRoutes}
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;

  /// {@macro flutter.widgets.widgetsApp.onUnknownRoute}
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;

  /// {@macro flutter.widgets.widgetsApp.navigatorKey}
  final GlobalKey<NavigatorState>? navigatorKey;

  /// ZetaColors object for app color theme.
  final ZetaColors? zetaColors;

  /// {@macro flutter.widgets.widgetsApp.debugShowCheckedModeBanner}
  final bool? debugShowCheckedModeBanner;

  /// Creates a ZdsApp
  const ZdsApp({
    required this.title,
    super.key,
    this.home,
    this.theme,
    this.routes = const <String, WidgetBuilder>{},
    this.localizationsDelegates,
    this.localeOverride,
    this.colors,
    this.zetaColors,
    this.onGenerateRoute,
    this.initialRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorKey,
    this.debugShowCheckedModeBanner,
  });

  @override
  Widget build(BuildContext context) {
    appZetaColors = zetaColors ?? ZetaColors();
    return Zeta(
      colors: zetaColors,
      builder: (BuildContext context, ThemeData zetaThemeData, ZetaColors zetaColors) {
        return ComponentLocalisation(
          child: Builder(
            builder: (context) {
              if (colors != null) {
                /// Use BrandColors
                return ThemeProvider(
                  colors: colors!,
                  builder: (BuildContext context, BrandColors brandColors, bool isDarkTheme) => _AppWrapper(
                    title,
                    localeOverride,
                    localizationsDelegates,
                    home,
                    routes,
                    onGenerateRoute,
                    onGenerateInitialRoutes,
                    onUnknownRoute,
                    initialRoute,
                    navigatorKey,
                    isDarkTheme ? ThemeData.dark() : ThemeData.light(),
                    isDarkTheme ? brandColors.dark : brandColors.light,
                    debugShowCheckedModeBanner ?? false,
                  ),
                );
              }

              /// Use ZetaColors
              return _AppWrapper(
                title,
                localeOverride,
                localizationsDelegates,
                home,
                routes,
                onGenerateRoute,
                onGenerateInitialRoutes,
                onUnknownRoute,
                initialRoute,
                navigatorKey,
                zetaThemeData,
                zetaColors.toColorScheme,
                debugShowCheckedModeBanner ?? false,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(DiagnosticsProperty<ThemeData?>('theme', theme));
    properties.add(DiagnosticsProperty<Map<String, WidgetBuilder>>('routes', routes));
    properties.add(IterableProperty<LocalizationsDelegate<dynamic>>('localizationsDelegates', localizationsDelegates));
    properties.add(DiagnosticsProperty<Locale?>('localeOverride', localeOverride));
    properties.add(DiagnosticsProperty<BrandColors?>('colors', colors));
    properties
        .add(ObjectFlagProperty<Route<dynamic>? Function(RouteSettings p1)?>.has('onGenerateRoute', onGenerateRoute));
    properties.add(StringProperty('initialRoute', initialRoute));
    properties.add(
      ObjectFlagProperty<List<Route<dynamic>> Function(String p1)?>.has(
        'onGenerateInitialRoutes',
        onGenerateInitialRoutes,
      ),
    );
    properties
        .add(ObjectFlagProperty<Route<dynamic>? Function(RouteSettings p1)?>.has('onUnknownRoute', onUnknownRoute));
    properties.add(DiagnosticsProperty<GlobalKey<NavigatorState>?>('navigatorKey', navigatorKey));
    properties.add(DiagnosticsProperty<ZetaColors?>('zetaColors', zetaColors));
    properties.add(DiagnosticsProperty<bool?>('debugShowCheckedModeBanner', debugShowCheckedModeBanner));
  }
}

class _AppWrapper extends StatelessWidget {
  const _AppWrapper(
    this.title,
    this.localeOverride,
    this.localizationsDelegates,
    this.home,
    this.routes,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.initialRoute,
    this.navigatorKey,
    this.theme,
    this.colorScheme,
    this.debugShowCheckedModeBanner,
  );

  final String title;
  final Locale? localeOverride;
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Widget? home;
  final Map<String, WidgetBuilder> routes;
  final Route<dynamic>? Function(RouteSettings p1)? onGenerateRoute;
  final List<Route<dynamic>> Function(String p1)? onGenerateInitialRoutes;
  final Route<dynamic>? Function(RouteSettings p1)? onUnknownRoute;
  final String? initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      title: title,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        final locale = localeOverride ?? deviceLocale;
        return ComponentStrings.delegate.isSupported(locale!) ? locale : ComponentStrings.defaultLocale;
      },
      locale: localeOverride,
      builder: (context, child) {
        return ZdsBottomBarTheme(
          data: buildZdsBottomBarThemeData(context),
          child: child ?? const SizedBox(),
        );
      },
      localizationsDelegates: localizationsDelegates ??
          [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            ComponentStrings.delegate,
          ],
      home: home,
      routes: routes,
      theme: buildTheme(theme, colorScheme),
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      initialRoute: initialRoute,
      navigatorKey: navigatorKey,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(DiagnosticsProperty<Locale?>('localeOverride', localeOverride));
    properties.add(IterableProperty<LocalizationsDelegate<dynamic>>('localizationsDelegates', localizationsDelegates));
    properties.add(DiagnosticsProperty<Map<String, WidgetBuilder>>('routes', routes));
    properties
        .add(ObjectFlagProperty<Route<dynamic>? Function(RouteSettings p1)?>.has('onGenerateRoute', onGenerateRoute));
    properties.add(
      ObjectFlagProperty<List<Route<dynamic>> Function(String p1)?>.has(
        'onGenerateInitialRoutes',
        onGenerateInitialRoutes,
      ),
    );
    properties
        .add(ObjectFlagProperty<Route<dynamic>? Function(RouteSettings p1)?>.has('onUnknownRoute', onUnknownRoute));
    properties.add(StringProperty('initialRoute', initialRoute));
    properties.add(DiagnosticsProperty<GlobalKey<NavigatorState>?>('navigatorKey', navigatorKey));
    properties.add(DiagnosticsProperty<ThemeData>('theme', theme));
    properties.add(DiagnosticsProperty<ColorScheme>('colorScheme', colorScheme));
    properties.add(DiagnosticsProperty<bool>('debugShowCheckedModeBanner', debugShowCheckedModeBanner));
  }
}
