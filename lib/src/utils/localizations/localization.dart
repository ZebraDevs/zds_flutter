import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../zds_flutter.dart';

/// Provides localizations for this library.
///
class ComponentLocalisation extends StatelessWidget {
  /// Creates a [ComponentLocalisation].
  const ComponentLocalisation({
    required this.child,
    super.key,
    this.delegates,
    this.localeOverride,
  });

  /// The widget to contain translations.
  ///
  /// ```dart
  ///class App extends StatelessWidget {
  ///   const App({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return ComponentLocalisation(
  ///       localeOverride: Locale('de'),
  ///       child: MaterialApp(
  ///         body:
  ///         builder: (context, child) {
  ///            return Text(ComponentStrings.of(context).get('VIEW','View'));
  ///          },
  ///        ),
  ///     );
  ///   }
  /// }
  /// ```
  final Widget child;

  ///The delegates for this app's [Localizations] widget.
  ///
  ///The delegates collectively define all of the localized resources for this application's [Localizations] widget.
  ///
  ///Internationalized apps that require translations for one of the locales listed in [GlobalMaterialLocalizations] should specify this parameter and list the [MaterialApp.supportedLocales] that the application can handle.
  final List<LocalizationsDelegate<dynamic>>? delegates;

  /// Overrides the locale that would otherwise be set.
  final Locale? localeOverride;

  @override
  Widget build(BuildContext context) {
    return Localizations(
      delegates: delegates ??
          <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            ComponentStrings.delegate,
          ],
      locale: localeOverride ?? ComponentStrings.defaultLocale,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<LocalizationsDelegate<dynamic>>('delegates', delegates))
      ..add(DiagnosticsProperty<Locale?>('localeOverride', localeOverride));
  }
}
