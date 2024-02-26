import 'package:flutter/material.dart';
import '../../../zds_flutter.dart';

/// Decoration used for a [ZdsAudioPlayer]
class ZdsAudioPlayerDecoration {
  /// Creates a new [ZdsAudioPlayerDecoration]
  const ZdsAudioPlayerDecoration({
    this.foregroundColor,
    this.backgroundColor,
    this.waveColor,
    this.thumbColor,
    this.contentPadding = const EdgeInsets.all(4),
    this.height = 55,
  });

  /// The color of the foreground elements
  final Color? foregroundColor;

  /// The color of the background
  final Color? backgroundColor;

  /// The color of the wave
  final Color? waveColor;

  /// The color of the slider thumb
  final Color? thumbColor;

  /// The height of the recorder
  final double height;

  /// The padding inside the recorder
  final EdgeInsets contentPadding;

  /// Resolves the background color to the secondary container color if not defined
  Color resolveBackgroundColor(BuildContext context) {
    return backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer;
  }

  /// Resolves the foreground color to the on secondary container color if not defined
  Color resolveForegroundColor(BuildContext context) {
    return foregroundColor ?? Theme.of(context).colorScheme.onSecondaryContainer;
  }

  /// Resolves the wave color to the foreground color if not defined
  Color resolveWaveColor(BuildContext context) {
    return waveColor ?? resolveForegroundColor(context);
  }

  /// Resolves the thumb color to the foreground color if not defined
  Color resolveThumbColor(BuildContext context) {
    return thumbColor ?? resolveForegroundColor(context);
  }

  /// Copies the given properties into a new [ZdsAudioPlayerDecoration]
  ZdsAudioPlayerDecoration copyWith({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? waveColor,
    Color? thumbColor,
    double? height,
    EdgeInsets? contentPadding,
  }) {
    return ZdsAudioPlayerDecoration(
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      waveColor: waveColor ?? this.waveColor,
      thumbColor: thumbColor ?? this.thumbColor,
      height: height ?? this.height,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }
}
