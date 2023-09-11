import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../zds_flutter.dart';

/// Loads themes from json file
class ThemeLoader {
  /// Loads a [BrandColors] from a json file from it's provided path.
  ///
  /// See
  ///   * [BrandColors]
  static Future<BrandColors> fromAssets(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);

      final json = jsonDecode(jsonString);

      return BrandColors.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      return BrandColors.zdsDefault();
    }
  }
}

/// Extension to parse color from string
extension ColorParser on String {
  /// Returns a Color parsed from the contents of the String.
  ///
  /// Supports Hex colors with or without a leading #
  Color? toColor() {
    try {
      if (isEmpty) return null;
      if (startsWith('#')) {
        return Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
      }
      return Color(int.parse(this, radix: 16) + 0xFF000000);
    } catch (_) {
      return null;
    }
  }
}
