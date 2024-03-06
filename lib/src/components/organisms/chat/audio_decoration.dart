import 'package:flutter/material.dart';
import '../../../../zds_flutter.dart';

abstract class _AudioDecoration {
  const _AudioDecoration({
    this.foregroundColor,
    this.backgroundColor,
    this.waveColor,
    this.thumbColor,
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
}

/// Decoration used for a [ZdsAudioPlayer]
class ZdsAudioPlayerDecoration extends _AudioDecoration {
  /// Creates a new [ZdsAudioPlayerDecoration]
  const ZdsAudioPlayerDecoration({
    super.foregroundColor,
    super.backgroundColor,
    super.waveColor,
    super.thumbColor,
    super.height,
    this.contentPadding = const EdgeInsets.all(4),
  });

  /// The padding inside the audio player
  final EdgeInsets contentPadding;

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

/// A decoration object for [ZdsVoiceNoteRecorder]
class ZdsAudioRecorderDecoration extends _AudioDecoration {
  /// Creates a new [ZdsAudioRecorderDecoration]
  const ZdsAudioRecorderDecoration({
    super.foregroundColor,
    super.waveColor,
    this.deleteIconTint,
    this.micIconTint,
    this.sendIconTint,
  });

  /// The color of the delete icon
  final Color? deleteIconTint;

  /// The color of the microphone icon
  final Color? micIconTint;

  /// The color of the send icon
  final Color? sendIconTint;

  @override
  Color resolveBackgroundColor(BuildContext context) {
    return backgroundColor ?? Theme.of(context).colorScheme.secondary.withLight(0.3);
  }

  @override
  Color resolveForegroundColor(BuildContext context) {
    return foregroundColor ?? Theme.of(context).colorScheme.secondaryContainer;
  }

  /// Resolves the delete icon color to the secondary color if not defined
  Color resolveDeleteIconTint(BuildContext context) {
    return deleteIconTint ?? Theme.of(context).colorScheme.secondary;
  }

  /// Resolves the microphone icon color to orange if not defined
  Color resolveMicIconTint(BuildContext context) {
    return micIconTint ?? Zeta.of(context).colors.orange;
  }

  /// Resolves the send icon color to the secondary color if not defined
  Color resolveSendIconTint(BuildContext context) {
    return sendIconTint ?? Theme.of(context).colorScheme.secondary;
  }

  /// Copies the given properties into a new [ZdsAudioRecorderDecoration]
  ZdsAudioRecorderDecoration copyWith({
    Color? foregroundColor,
    Color? waveColor,
    Color? deleteIconTint,
    Color? micIconTint,
    Color? sendIconTint,
  }) {
    return ZdsAudioRecorderDecoration(
      foregroundColor: foregroundColor ?? this.foregroundColor,
      waveColor: waveColor ?? this.waveColor,
      deleteIconTint: deleteIconTint ?? this.deleteIconTint,
      micIconTint: micIconTint ?? this.micIconTint,
      sendIconTint: sendIconTint ?? this.sendIconTint,
    );
  }
}
