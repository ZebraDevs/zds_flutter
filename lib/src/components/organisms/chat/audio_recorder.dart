import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import '../../../../zds_flutter.dart';
import 'audio_decoration.dart';

/// Represents a recording created by a [ZdsVoiceNoteRecorder]
class ZdsRecording {
  /// Creates a new [ZdsRecording]
  ZdsRecording({required this.filePath, required this.duration});

  /// The path to the recording
  String filePath;

  /// The duration of the recording
  Duration duration;
}

/// A widget for recording audio. Also handles the playback of the recorded audio.
/// Not supported for web.
class ZdsVoiceNoteRecorder extends StatefulWidget {
  /// Creates a new [ZdsVoiceNoteRecorder]
  const ZdsVoiceNoteRecorder({
    required this.fileName,
    required this.rootDirectory,
    required this.maxDuration,
    required this.onSubmit,
    this.fileType = 'wav',
    this.playerDecoration = const ZdsAudioPlayerDecoration(),
    this.recorderDecoration = const ZdsAudioRecorderDecoration(),
    super.key,
  });

  /// The name of the file the recording will be stored in
  final String fileName;

  /// The directory the recording will be stored in
  final String rootDirectory;

  /// The maximum duration of the recording
  final Duration maxDuration;

  /// The decoration applied to the audio player
  final ZdsAudioPlayerDecoration playerDecoration;

  /// The decoration applied to the audio recorder
  final ZdsAudioRecorderDecoration recorderDecoration;

  /// The function called when the submit button is pressed
  final void Function(ZdsRecording audioFile) onSubmit;

  /// The type of the file
  ///
  /// Defaults to 'wav'
  final String fileType;

  @override
  State<ZdsVoiceNoteRecorder> createState() => ZdsVoiceNoteRecorderState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('fileName', fileName))
      ..add(DiagnosticsProperty<String>('rootDirectory', rootDirectory))
      ..add(DiagnosticsProperty<Duration>('maxDuration', maxDuration))
      ..add(DiagnosticsProperty<ZdsAudioPlayerDecoration>('playerDecoration', playerDecoration))
      ..add(DiagnosticsProperty<ZdsAudioRecorderDecoration>('recorderDecoration', recorderDecoration))
      ..add(ObjectFlagProperty<void Function(ZdsRecording audioFile)>.has('onSubmit', onSubmit))
      ..add(StringProperty('fileType', fileType));
  }
}

/// The state for a [ZdsVoiceNoteRecorder]
class ZdsVoiceNoteRecorderState extends State<ZdsVoiceNoteRecorder> {
  final _playerKey = GlobalKey<ZdsAudioPlayerState>();
  final _recorder = AudioRecorder();

  bool _isRecording = false;
  int _duration = 0;
  Timer? _updateDuration;
  List<double> _waveform = [];

  Duration get _recordingDuration => Duration(milliseconds: _duration);
  String get _recordingPath => '${widget.rootDirectory}/${widget.fileName}.${widget.fileType}';

  /// The destination the recording gets saved to
  String? recordingDestination;

  @override
  void initState() {
    super.initState();
    _recorder.onStateChanged().listen((event) {
      if (event != RecordState.record) {
        _updateDuration?.cancel();
        setState(() {
          _isRecording = false;
        });
      } else {
        setState(() {
          _isRecording = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _updateDuration?.cancel();
    unawaited(_recorder.dispose());
  }

  /// Starts the recording
  Future<void> start() async {
    if (await _recorder.hasPermission() && mounted) {
      await _recorder.start(const RecordConfig(encoder: AudioEncoder.wav), path: _recordingPath);
      _updateDuration = Timer.periodic(const Duration(milliseconds: 100), (_) {
        _duration += 100;
        setState(() {
          // TODO(UX-1000):  either create an actual waveform or replace the progress widget with something
          _waveform.add(0);
        });
        if (_duration >= widget.maxDuration.inMilliseconds) {
          stop();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showZdsToast(
        ZdsToast(
          title: Text(
            ComponentStrings.of(context).get(
              'MICROPHONE_PERMISISON_ERROR',
              'Microphone permissions need to be granted in order to record',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: const Icon(ZdsIcons.close),
            ),
          ],
          color: ZdsToastColors.error,
        ),
      );
    }
  }

  /// Stops the recording
  Future<void> stop() async {
    _updateDuration?.cancel();
    final String? path = await _recorder.stop();
    setState(() {
      recordingDestination = path;
    });
  }

  /// Resets the recorder. This will delete any recordings created.
  Future<void> reset() async {
    if (recordingDestination != null) {
      await File(recordingDestination!).delete();

      setState(() {
        _waveform = [];
        recordingDestination = null;
        _duration = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;

    return Material(
      color: Colors.transparent,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: (_isRecording || recordingDestination == null)
                  ? SizedBox(
                      height: widget.playerDecoration.height,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          color: widget.recorderDecoration.resolveBackgroundColor(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            child: DefaultTextStyle(
                              style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 12)).copyWith(
                                color: widget.recorderDecoration.resolveForegroundColor(context),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_recordingDuration.formatted()),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _RecordingProgress(
                                        decibelsMeter: _waveform,
                                        foregroundColor: widget.recorderDecoration.resolveForegroundColor(context),
                                        progress: _duration / widget.maxDuration.inMilliseconds,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(widget.maxDuration.formatted()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : ZdsAbsorbPointer(
                      absorbing: recordingDestination != null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ZdsAudioPlayer.fromFile(
                          key: _playerKey,
                          path: recordingDestination,
                          decoration: widget.playerDecoration,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Semantics(
                  excludeSemantics: _isRecording || recordingDestination == null,
                  child: ZdsAbsorbPointer(
                    absorbing: _isRecording || recordingDestination == null,
                    child: IconButton(
                      tooltip: 'Delete recording',
                      onPressed: () async {
                        final audioPlayer = _playerKey.currentState;
                        if (audioPlayer != null && audioPlayer.playing) {
                          await audioPlayer.pause();
                        }
                        await reset();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: widget.recorderDecoration.resolveDeleteIconTint(context),
                      ),
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: !_isRecording ? 'Pause recording' : 'Start recording',
                  child: InkResponse(
                    onTap: () {
                      if (_isRecording) {
                        unawaited(stop());
                      } else {
                        unawaited(start());
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: widget.recorderDecoration.resolveMicIconTint(context),
                      foregroundColor: zetaColors.surfacePrimary,
                      radius: 27.5,
                      child: Icon(
                        _isRecording ? Icons.pause : Icons.mic,
                        color: zetaColors.surfacePrimary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Semantics(
                  excludeSemantics: _isRecording || recordingDestination != null,
                  child: ZdsAbsorbPointer(
                    absorbing: _isRecording || recordingDestination != null,
                    child: IconButton(
                      tooltip: 'Send audio',
                      onPressed: () async {
                        final audioPlayer = _playerKey.currentState;
                        if (audioPlayer != null && audioPlayer.playing) {
                          await audioPlayer.pause();
                        }
                        widget.onSubmit.call(
                          ZdsRecording(filePath: _recordingPath, duration: Duration(milliseconds: _duration)),
                        );
                      },
                      icon: Icon(
                        Icons.send,
                        color: widget.recorderDecoration.resolveSendIconTint(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('recordingDestination', recordingDestination));
  }
}

class _RecordingProgress extends StatelessWidget {
  const _RecordingProgress({
    required this.foregroundColor,
    required this.progress,
    required this.decibelsMeter,
  });

  final double progress;
  final List<double> decibelsMeter;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        return ListView.separated(
          key: ValueKey(decibelsMeter.length),
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: decibelsMeter.length,
          separatorBuilder: (a, b) => const SizedBox(width: 2),
          itemBuilder: (context, index) {
            final height = decibelsMeter[index] * box.maxHeight;
            return Center(
              child: Container(
                width: 2,
                height: max(height, 1),
                color: foregroundColor,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('progress', progress))
      ..add(IterableProperty<double>('decibelsMeter', decibelsMeter))
      ..add(ColorProperty('foregroundColor', foregroundColor));
  }
}
