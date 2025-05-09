import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../theme.dart';

/// A class representing theme service which extends `ZetaThemeService` class.
/// This class assists in loading and saving theme data.
/// See also:
///  * [ZetaProvider]
///  * [ZdsThemeData]
class ZdsThemeService extends ZetaThemeService {
  /// Creates an instance of `ZdsThemeService`.
  ///
  /// Throws an [ArgumentError] if [assetPath] or [preferences] is null.
  ///
  /// The optional [assetPath] parameter defines the path to theme assets.
  ///  - This asset path should point to a valid json file.
  ///  - The JSON string should conform to the structure of [ZdsThemeData].
  ZdsThemeService({required this.preferences, this.assetPath});

  /// The path to load theme assets from.
  final String? assetPath;

  /// An instance of `SharedPreferences` class to manage local user preferences.
  final SharedPreferences preferences;

  /// Loads theme data from local storage or assets.
  ///
  /// Returns an instance of `ZdsThemeData` either from a saved JSON string in preferences or from assets.
  Future<ZdsThemeData> load() async {
    final json = preferences.getString('zds.theme.preferences.json');
    if (json != null) {
      return ZdsThemeData.fromJsonString(json);
    } else if (assetPath != null) {
      return ZdsThemeData.fromAssets(assetPath!);
    } else {
      return ZdsThemeData.defaultData();
    }
  }

  /// An overridden method to load theme, theme mode, and contrast.
  ///
  /// Returns a `ZetaThemeServiceData` object containing theme data, mode, and contrast.
  @override
  Future<ZetaThemeServiceData> loadTheme() async {
    final data = await load();
    return ZetaThemeServiceData(
      // themeId: data.identifier,
      themeMode: data.themeMode,
      contrast: data.contrast,
      // fontFamily: data.fontFamily,
    );
  }

  /// An overridden method to save the theme, theme mode, and contrast.
  ///
  /// Save the setting as a JSON string to local storage (`SharedPreferences`).
  ///
  /// Called from [ZetaProvider] when any theme attribute is changed.
  @override
  Future<void> saveTheme({required ZetaThemeServiceData themeData}) async {
    final data = await load();
    final newData = data.copyWith(
      // identifier: themeData.themeId,
      themeMode: themeData.themeMode,
      contrast: themeData.contrast,
      // fontFamily: themeData.fontFamily,
    );
    await preferences.setString('zds.theme.preferences.json', jsonEncode(newData.toJson()));
  }
}
