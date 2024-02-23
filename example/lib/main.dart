import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final themeService = ZdsThemeService(assetPath: 'assets/colors.json', preferences: preferences);
  final themeData = await themeService.load();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    DemoApp(
      data: themeData,
      themeService: themeService,
    ),
  );
}

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key, required this.data, required this.themeService}) : super(key: key);

  final ZetaThemeService themeService;
  final ZdsThemeData data;

  @override
  Widget build(BuildContext context) {
    return ZetaProvider(
      themeService: themeService,
      initialThemeMode: data.themeMode,
      initialThemeData: data.themeData,
      initialContrast: data.contrast,
      builder: (context, themeData, themeMode) {
        return MaterialApp(
          title: 'Zds Demo',
          localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
            return locale != null && ComponentStrings.delegate.isSupported(locale)
                ? locale
                : ComponentStrings.defaultLocale;
          },
          builder: (BuildContext context, Widget? child) {
            return ZdsBottomBarTheme(
              data: buildZdsBottomBarThemeData(context),
              child: child ?? const SizedBox(),
            );
          },
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            ComponentStrings.delegate,
          ],
          routes: kAllRoutes,
          themeMode: themeMode,
          theme: themeData.colorsLight.toScheme().toTheme(
                fontFamily: themeData.fontFamily,
                appBarStyle: data.lightAppBarStyle,
              ),
          darkTheme: themeData.colorsDark.toScheme().toTheme(
                fontFamily: themeData.fontFamily,
                appBarStyle: data.darkAppBarStyle,
              ),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
