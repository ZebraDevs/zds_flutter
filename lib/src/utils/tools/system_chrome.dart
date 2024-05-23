import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Controls orientations of the application interface
class ZdsSystemChrome {
  static List<DeviceOrientation> _orientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  /// Get the set of orientations the application interface can
  /// be displayed in.
  static List<DeviceOrientation> get appOrientations => _orientations;

  /// Specifies the set of orientations the application interface can
  /// be displayed in.
  ///
  /// The `orientation` argument is a list of [DeviceOrientation] enum values.
  static Future<void> setPreferredOrientations(List<DeviceOrientation>? orientations) async {
    final platformMediaQuery = MediaQueryData.fromView(PlatformDispatcher.instance.views.first);
    if (orientations == null || orientations.isEmpty) {
      if (platformMediaQuery.size.shortestSide < 600) {
        _orientations = [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
      } else {
        _orientations = [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ];
      }
    } else {
      _orientations = orientations;
    }

    await resetAppOrientations();
  }

  /// Set the set of orientations the application interface can
  /// be displayed in.
  static Future<void> resetAppOrientations() async {
    await SystemChrome.setPreferredOrientations(appOrientations);
  }
}
