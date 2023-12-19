import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../zds_flutter.dart';

/// Translated Strings file
class ComponentStrings {
  /// Constructs a [ComponentStrings].
  /// default value for [debugStrings] is false.
  ComponentStrings(this.locale, {this.debugStrings = false});

  /// Default locale of the components is English.
  static const Locale defaultLocale = Locale('en');

  /// Locale set to get translated strings of.
  ///
  /// If the locale is not supported, will fallback to using [defaultLocale].
  final Locale locale;

  /// debug strings flag.
  /// Default value of [debugStrings] is false.
  /// If true then [get] method returns key instead of value
  final bool debugStrings;

  /// Delegate used to get the translated strings.
  static LocalizationsDelegate<ComponentStrings> delegate = ComponentDelegate();

  Map<String, String> _strings = <String, String>{};

  /// Returns the localized resources object of the given `ComponentStrings` for the widget
  /// tree that corresponds to the given `context`.
  static ComponentStrings of(BuildContext context) {
    return Localizations.of<ComponentStrings>(context, ComponentStrings)!;
  }

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('bs'),
    Locale('cs'),
    Locale('de'),
    Locale('de', 'AT'),
    Locale('de', 'BE'),
    Locale('el'),
    Locale('en'),
    Locale('en', 'CA'),
    Locale('en', 'GB'),
    Locale('en', 'US'),
    Locale('es'),
    Locale('es', 'CL'),
    Locale('es', 'EC'),
    Locale('es', 'ES'),
    Locale('es', 'PE'),
    Locale('es', 'PR'),
    Locale('es', 'UY'),
    Locale('fi'),
    Locale('fr'),
    Locale('fr', 'BE'),
    Locale('fr', 'CA'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ka'),
    Locale('ko'),
    Locale('lt'),
    Locale('lv'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sr'),
    Locale('sv'),
    Locale('th'),
    Locale('tl'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'HK'),
  ];

  /// Gets a translated string from [key], otherwise uses [fallback].
  ///
  /// Optional args can be added to place hardcoded values (such as numbers) within the translated text.
  /// if the [debugStrings] is true then it always return key.
  String get(String key, String fallback, {List<String>? args}) {
    if (debugStrings) return '#$key';

    final String str = _strings[key] ?? '';
    final String string = str.isEmpty ? fallback : str;
    if (args != null && args.isNotEmpty) {
      final List<MapEntry<String, String>> mapping = List<MapEntry<String, String>>.generate(
        args.length,
        (int index) => MapEntry<String, String>('$index', args[index]),
      );
      return string.format(Map<String, String>.fromEntries(mapping));
    } else {
      return string;
    }
  }

  /// Gets all translated strings
  Map<String, String> getAll() {
    return _strings;
  }

  /// Update existing strings with [delta].
  void update(Map<String, String> delta) {
    for (final MapEntry<String, String> entry in delta.entries) {
      if (entry.value.isNotEmpty) {
        _strings[entry.key] = entry.value;
      }
    }
  }

  /// Loads strings from file and sets [_strings].
  Future<ComponentStrings> load() async {
    // Loading strings from assets
    _strings = await _loadStrings();
    return this;
  }

  Future<Map<String, String>> _loadStrings() async {
    const String assetPath = 'packages/$packageName/lib/assets/strings/';

    String strings = '';

    if (locale.countryCode != null) {
      try {
        // Check if strings with lang-code and country code are present
        strings = await rootBundle.loadString('$assetPath${locale.languageCode}_${locale.countryCode}.json');
      } catch (e) {
        debugPrint(e.toString());
        try {
          strings = await rootBundle.loadString('$assetPath${locale.languageCode}.json');
        } catch (e2) {
          debugPrint(e2.toString());
        }
      }
    }

    // Fallback on langCode if it's not the english language
    if (strings.isEmpty) {
      try {
        // Check if strings with lang-code and country code are present
        strings = await rootBundle.loadString('$assetPath${locale.languageCode}.json');
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    if (strings.isEmpty) {
      return <String, String>{};
    } else {
      try {
        return Map<String, String>.from(jsonDecode(strings) as Map<dynamic, dynamic>);
      } catch (e) {
        return <String, String>{};
      }
    }
  }
}

/// Abstract class for the component delta strings
// ignore: one_member_abstracts
abstract class ComponentDeltaProvider {
  ///Load delta string of the locale.
  Future<Map<String, String>> loadDelta(Locale locale);
}

/// Delegate to get translations for these components.
class ComponentDelegate extends LocalizationsDelegate<ComponentStrings> {
  /// Constructs a [ComponentDelegate].
  ComponentDelegate({this.deltaProvider, this.debugStrings = false});

  /// Custom string delta
  final ComponentDeltaProvider? deltaProvider;

  ///debug strings
  final bool debugStrings;

  @override
  Future<ComponentStrings> load(Locale locale) async {
    final ComponentStrings strings = await ComponentStrings(locale).load();
    if (deltaProvider != null) {
      final Map<String, String> delta = await deltaProvider!.loadDelta(locale);
      if (delta.isNotEmpty) {
        strings.update(delta);
      }
    }
    return strings;
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bg',
        'bs',
        'cs',
        'de',
        'el',
        'en',
        'es',
        'fi',
        'fr',
        'hr',
        'hu',
        'id',
        'it',
        'ja',
        'ka',
        'ko',
        'lt',
        'lv',
        'nb',
        'nl',
        'pl',
        'pt',
        'ro',
        'ru',
        'sk',
        'sl',
        'sr',
        'sv',
        'th',
        'tl',
        'tr',
        'uk',
        'vi',
        'zh',
      ].contains(locale.languageCode);

  @override
  bool shouldReload(ComponentDelegate old) => true;
}

/// Formats the strings.
extension StringFormatter on String {
  /// Formats the strings.
  ///
  /// Replaces {placeholder} in strings with { "placeholder" : "some value"} map.
  /// Example
  ///  print("Hello {user}! You have {count} new messages.".format({ "user" : "John", "count" : "10"}))
  ///  prints -> "Hello John! You have 10 new messages."
  String format(Map<String, String> args) {
    String test = this;
    for (final MapEntry<String, String> entry in args.entries) {
      test = test.replaceAll('{${entry.key}}', entry.value);
    }
    return test;
  }
}
