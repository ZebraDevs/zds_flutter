import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../zds_flutter.dart';

/// Controls for playing audio files.
/// This widget does not handle the actual playing of the audio files.
/// That can be done with various packages like just_audio.
class ZdsAudioPlayer extends StatefulWidget {
  /// Creates a new [ZdsAudioPlayer]
  const ZdsAudioPlayer({
    this.onPlay,
    this.onPause,
    this.onFinish,
    this.onProgress,
    this.decoration = const ZdsAudioPlayerDecoration(),
    this.disabled = false,
    this.autoPlay = false,
    this.onSeek,
    this.path,
    this.url,
    this.headers,
    this.assetPath,
    super.key,
  });

  /// Load an audio asset from a file path
  const ZdsAudioPlayer.fromFile({
    required this.path,
    this.onPlay,
    this.onPause,
    this.onFinish,
    this.onProgress,
    this.decoration = const ZdsAudioPlayerDecoration(),
    this.disabled = false,
    this.autoPlay = false,
    this.onSeek,
    super.key,
  })  : url = null,
        headers = null,
        assetPath = null;

  /// Load an audio asset from a url
  const ZdsAudioPlayer.fromUrl({
    required this.url,
    this.headers,
    this.onPlay,
    this.onPause,
    this.onFinish,
    this.onProgress,
    this.decoration = const ZdsAudioPlayerDecoration(),
    this.disabled = false,
    this.autoPlay = false,
    this.onSeek,
    super.key,
  })  : path = null,
        assetPath = null;

  /// Load an audio asset from an asset path
  const ZdsAudioPlayer.fromAsset({
    required this.assetPath,
    this.onPlay,
    this.onPause,
    this.onFinish,
    this.onProgress,
    this.decoration = const ZdsAudioPlayerDecoration(),
    this.disabled = false,
    this.autoPlay = false,
    this.onSeek,
    super.key,
  })  : url = null,
        path = null,
        headers = null;

  /// Called when the audio is played
  final VoidCallback? onPlay;

  /// Called when the audio is paused
  final VoidCallback? onPause;

  /// Called when the audio is finished playing
  final VoidCallback? onFinish;

  /// Called when the audio is scrolled.
  ///
  /// position is the progress of the audio being scrolled to.
  final void Function(Duration position)? onSeek;

  /// The url of the audio file
  final String? url;

  /// The headers used if fetching audio via [url]
  final Map<String, String>? headers;

  /// The path of the audio file
  final String? path;

  /// The path of the audio file asset
  final String? assetPath;

  /// Auto plays the audio after it is loaded
  final bool autoPlay;

  /// Disables the player
  final bool disabled;

  /// Called when the audio is playing
  ///
  /// duration is the total duration of the audio.
  /// position is the current progress of the audio.
  final void Function(Duration duration, Duration position)? onProgress;

  /// Decoration for the player
  final ZdsAudioPlayerDecoration decoration;

  @override
  State<ZdsAudioPlayer> createState() => ZdsAudioPlayerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<void Function(Duration duration, Duration position)?>.has('onProgress', onProgress))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPause', onPause))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onFinish', onFinish))
      ..add(ObjectFlagProperty<void Function(Duration position)?>.has('onScroll', onSeek))
      ..add(DiagnosticsProperty<bool>('disabled', disabled))
      ..add(DiagnosticsProperty<ZdsAudioPlayerDecoration>('decoration', decoration))
      ..add(DiagnosticsProperty<bool>('isPlaying', autoPlay))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPlay', onPlay))
      ..add(StringProperty('url', url))
      ..add(DiagnosticsProperty<Map<String, String>?>('headers', headers))
      ..add(StringProperty('path', path))
      ..add(StringProperty('assetPath', assetPath));
  }
}

/// A state to the [ZdsAudioPlayer]
class ZdsAudioPlayerState extends State<ZdsAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();

  Duration _duration = Duration.zero;

  bool _completed = false;
  bool _initComplete = false;
  bool get _disabled => !_initComplete || widget.disabled;

  int _position = 0;

  String get _durationText {
    return (_position > 0)
        ? Duration(milliseconds: _position).formatted()
        : (_duration != Duration.zero ? _duration.formatted() : '');
  }

  /// If the player is currently playing audio
  bool get playing => _player.playing;

  @override
  void initState() {
    if (widget.path != null) {
      unawaited(_player.setFilePath(widget.path!).then(_onPlayerInit));
    } else if (widget.url != null) {
      unawaited(_player.setUrl(widget.url!, headers: widget.headers).then(_onPlayerInit));
    } else if (widget.assetPath != null) {
      unawaited(_player.setAsset(widget.assetPath!).then(_onPlayerInit));
    }

    super.initState();
  }

  void _onPlayerInit(Duration? duration) {
    setState(() {
      _duration = duration ?? Duration.zero;
      _initComplete = true;
    });
    final stream = _player.createPositionStream(
      minPeriod: const Duration(milliseconds: 20),
      maxPeriod: const Duration(milliseconds: 20),
    );

    _player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        unawaited(_stop());
      }
    });

    stream.listen((event) {
      if (mounted) {
        widget.onProgress?.call(_duration, event);
        setState(() {
          _position = event.inMilliseconds;
        });
      }
    });

    if (widget.autoPlay) {
      unawaited(play());
    }
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  /// Plays the audio
  Future<void> play() async {
    if (_completed) {
      _completed = false;
      await _player.seek(Duration.zero);
    }
    await _player.play();
    widget.onPlay?.call();
  }

  /// Pauses the audio
  Future<void> pause() async {
    await _player.pause();
    widget.onPause?.call();
  }

  Future<void> _stop() async {
    await _player.stop();
    _completed = true;
    widget.onFinish?.call();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final foregroundColor = widget.decoration.resolveForegroundColor(context);
    final backgroundColor = widget.decoration.resolveBackgroundColor(context);
    final thumbColor = widget.decoration.resolveThumbColor(context);
    final waveColor = widget.decoration.resolveWaveColor(context);
    final inactiveTrackColor = backgroundColor.withOpacity(0.5);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: widget.decoration.height,
        child: Padding(
          padding: widget.decoration.contentPadding,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  playing ? Icons.pause_circle_outline : Icons.play_circle_outline,
                  color: !_disabled ? foregroundColor : foregroundColor.withOpacity(0.5),
                ),
                onPressed: !_disabled
                    ? playing
                        ? pause
                        : play
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: _PlaybackProgress(
                    enabled: !_disabled,
                    randomized: playing,
                    foregroundColor: waveColor,
                    thumbColor: thumbColor,
                    backgroundColor: inactiveTrackColor,
                    maxValue: _duration.inMilliseconds + 0.0,
                    value: _position.toDouble(),
                    onChange: (double d) async {
                      final duration = Duration(milliseconds: d.floor());
                      await _player.seek(duration);
                      widget.onSeek?.call(duration);
                    },
                  ),
                ),
              ),
              Text(
                _durationText,
                style: themeData.textTheme.titleSmall?.copyWith(
                  color: foregroundColor,
                ),
              ).paddingOnly(left: 8, right: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('playing', playing));
  }
}

class _PlaybackProgress extends StatelessWidget {
  const _PlaybackProgress({
    required this.foregroundColor,
    required this.randomized,
    required this.enabled,
    required this.maxValue,
    required this.value,
    required this.thumbColor,
    required this.backgroundColor,
    required this.onChange,
  });

  final bool randomized;
  final bool enabled;
  final double maxValue;
  final double value;
  final Color thumbColor;
  final Color foregroundColor;
  final Color backgroundColor;
  final void Function(double d) onChange;

  static const _wavePattern = [0.8, 0.6, 0.5, 0.45, 0.65, 0.7, 0.4];
  static const _waveBarWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final random = Random();
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Row(
                children: List.generate(box.maxWidth ~/ _waveBarWidth, (index) {
                  return Container(
                    width: _waveBarWidth,
                    height:
                        _wavePattern[randomized ? random.nextInt(_wavePattern.length) : index % _wavePattern.length] *
                            box.maxHeight,
                    color: index.isEven ? foregroundColor : Colors.transparent,
                  );
                }),
              ),
            ),
            Positioned(
              left: -24,
              right: -24,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: backgroundColor.withOpacity(0.4),
                  trackShape: const RectangularSliderTrackShape(),
                  thumbShape: enabled ? const RoundSliderThumbShape() : SliderComponentShape.noThumb,
                  trackHeight: box.maxHeight,
                  thumbColor: thumbColor,
                  disabledThumbColor: thumbColor,
                  disabledActiveTrackColor: Colors.transparent,
                  disabledInactiveTrackColor: backgroundColor.withOpacity(0.4),
                ),
                child: Slider(
                  value: min(value, maxValue),
                  max: maxValue,
                  onChanged: enabled ? onChange : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('randomized', randomized))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(DoubleProperty('maxValue', maxValue))
      ..add(DoubleProperty('value', value))
      ..add(ColorProperty('thumbColor', thumbColor))
      ..add(ColorProperty('foregroundColor', foregroundColor))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ObjectFlagProperty<void Function(double d)?>.has('onChange', onChange));
  }
}
