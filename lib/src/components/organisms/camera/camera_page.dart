import 'dart:async';
import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:path_provider/path_provider.dart';

import '../../../../zds_flutter.dart';
import '../../../utils/tools/pausable_timer.dart';

export 'package:camerawesome/camerawesome_plugin.dart' show AwesomeFilter, CaptureRequest, CaptureRequestBuilder;

/// Defines the camera modes available in the ZdsCameraWidget.
///
/// This enum is used to specify whether the camera is set to photo or video mode.
enum ZdsCameraMode {
  /// Camera mode for taking photos.
  photo,

  /// Camera mode for recording videos.
  video,
}

/// A widget for displaying a camera interface that supports both photo and video modes.
///
/// This widget provides a customizable camera UI with options for capturing photos
/// and videos, including setting a maximum duration for video recording and
/// toggling the preview display.
class ZdsCamera extends StatelessWidget {
  /// Creates a ZdsCameraWidget.
  ///
  /// The camera mode can be set to either photo or video, with photo being the default.
  /// Optionally, a maximum video duration and a flag to show or hide the preview can be provided.
  ///
  /// - [key] identifies the widget in the widget tree.
  /// - [cameraMode] specifies the initial mode of the camera, defaulting to photo.
  /// - [maxVideoDuration] sets a limit on the length of video recording.
  /// - [showPreview] determines whether the camera preview is shown, enabled by default.
  const ZdsCamera({
    super.key,
    this.cameraMode = ZdsCameraMode.photo,
    this.maxVideoDuration,
    this.showPreview = true,
    this.photoPathBuilder,
    this.videoPathBuilder,
    this.filters,
  });

  /// - [cameraMode] specifies the initial mode of the camera, defaulting to photo.
  final ZdsCameraMode cameraMode;

  /// - [maxVideoDuration] sets a limit on the length of video recording.
  final Duration? maxVideoDuration;

  /// - [showPreview] determines whether the camera preview is shown before selecting a file, enabled by default.
  final bool showPreview;

  /// A builder for the path to save the photo or video file.
  ///
  /// This builder is used to specify the path to save the photo or video file.
  final CaptureRequestBuilder? photoPathBuilder;

  /// A builder for the path to save the video file.
  ///
  /// This builder is used to specify the path to save the video file.
  final CaptureRequestBuilder? videoPathBuilder;

  /// A list of filters to apply to the camera preview.
  ///
  /// This list is used to specify the filters to apply to the camera preview.
  /// If not provided, the default list [awesomePresetFiltersList] of filters is used.
  final List<AwesomeFilter>? filters;

  /// A static method to take a photo using the [ZdsCamera].
  ///
  /// This method opens the camera interface and allows the user to take a photo.
  /// Optionally, the [showPreview] flag can be set to show or hide the preview.
  /// The [rootNavigator] flag can be set to control whether the camera interface is displayed as a root navigator.
  /// The [photoPathBuilder] and [videoPathBuilder] can be used to specify the path to save the photo or video file.
  /// The [filters] list can be used to specify the filters to apply to the camera preview.
  static Future<XFile?> takePhoto(
    BuildContext context, {
    bool showPreview = true,
    bool rootNavigator = true,
    CaptureRequestBuilder? photoPathBuilder,
    CaptureRequestBuilder? videoPathBuilder,
    List<AwesomeFilter>? filters,
  }) async {
    if (kIsWeb) {
      return image_picker.ImagePicker().pickImage(source: image_picker.ImageSource.camera);
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).push<XFile>(
        ZdsFadePageRouteBuilder(
          builder: (context) => ZdsCamera(
            showPreview: showPreview,
            photoPathBuilder: photoPathBuilder,
            videoPathBuilder: videoPathBuilder,
            filters: filters,
          ),
        ),
      );
    }
  }

  /// A static method to record a video using the [ZdsCamera].
  /// This method opens the camera interface and allows the user to record a video.
  /// Optionally, the [showCapturePreview] flag can be set to show or hide the preview.
  /// The [rootNavigator] flag can be set to control whether the camera interface is displayed as a root navigator.
  /// The [photoPathBuilder] and [videoPathBuilder] can be used to specify the path to save the photo or video file.
  /// The [maxVideoDuration] can be used to set a limit on the length of video recording.
  static Future<XFile?> recordVideo(
    BuildContext context, {
    bool showCapturePreview = true,
    bool rootNavigator = true,
    CaptureRequestBuilder? photoPathBuilder,
    CaptureRequestBuilder? videoPathBuilder,
    Duration? maxVideoDuration,
  }) async {
    if (kIsWeb) {
      return image_picker.ImagePicker().pickVideo(source: image_picker.ImageSource.camera);
    } else {
      return Navigator.of(context, rootNavigator: rootNavigator).push<XFile>(
        ZdsFadePageRouteBuilder(
          builder: (context) => ZdsCamera(
            cameraMode: ZdsCameraMode.video,
            showPreview: showCapturePreview,
            photoPathBuilder: photoPathBuilder,
            videoPathBuilder: videoPathBuilder,
            maxVideoDuration: maxVideoDuration,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: CameraAwesomeBuilder.custom(
            enablePhysicalButton: true,
            previewFit: CameraPreviewFit.contain,
            filters: filters ?? awesomePresetFiltersList,
            saveConfig: _saveConfig(),
            builder: (state, preview) {
              return _CameraWrapper(
                state: state,
                cameraMode: cameraMode,
                maxVideoDuration: maxVideoDuration,
                onPhoto: (CaptureRequest request) => _onPhoto(context, request),
                onVideo: (CaptureRequest request) => _onVideo(context, request),
              );
            },
            sensorConfig: SensorConfig.single(
              sensor: Sensor.position(SensorPosition.back),
              flashMode: FlashMode.auto,
            ),
          ),
        ),
      ),
    );
  }

  void _onVideo(BuildContext context, CaptureRequest request) {
    unawaited(
      request.when(
        single: (single) async {
          if (single.file == null) return;

          if (showPreview) {
            final choice = await Navigator.of(context).push<bool>(
              ZdsFadePageRouteBuilder(builder: (context) => _VideoPreviewer(videoFile: single.file!)),
            );

            if (choice != null && choice && context.mounted) {
              Navigator.of(context).pop(single.file);
            } else {
              unawaited(single.file?.delete());
            }
          } else {
            Navigator.of(context).pop(single.file);
          }
        },
      ),
    );
  }

  void _onPhoto(BuildContext context, CaptureRequest request) {
    unawaited(
      request.when(
        single: (single) async {
          if (single.file == null) return;

          if (showPreview) {
            final choice = await Navigator.of(context).push<bool>(
              ZdsFadePageRouteBuilder(builder: (context) => _ImagePreviewer(imageFile: single.file!)),
            );

            if (choice != null && choice && context.mounted) {
              Navigator.of(context).pop(single.file);
            } else {
              unawaited(single.file?.delete());
            }
          } else {
            Navigator.of(context).pop(single.file);
          }
        },
      ),
    );
  }

  SaveConfig _saveConfig() {
    return cameraMode == ZdsCameraMode.video
        ? SaveConfig.video(
            pathBuilder: photoPathBuilder ??
                (sensors) async {
                  final Directory extDir = await getTemporaryDirectory();
                  final testDir = await Directory('${extDir.path}/Zds-ui').create(recursive: true);
                  final ext = Platform.isIOS ? 'mov' : 'mp4';
                  if (sensors.length == 1) {
                    final String filePath = '${testDir.path}/VID_${DateTime.now().millisecondsSinceEpoch}.$ext';
                    return SingleCaptureRequest(filePath, sensors.first);
                  } else {
                    // Separate pictures taken with front and back camera
                    return MultipleCaptureRequest({
                      for (final sensor in sensors)
                        sensor: '${testDir.path}/VID_${DateTime.now().millisecondsSinceEpoch}.$ext',
                    });
                  }
                },
            videoOptions: VideoOptions(
              enableAudio: true,
              quality: VideoRecordingQuality.fhd,
            ),
          )
        : SaveConfig.photo(
            exifPreferences: ExifPreferences(saveGPSLocation: true),
            pathBuilder: videoPathBuilder ??
                (sensors) async {
                  final Directory extDir = await getTemporaryDirectory();
                  final testDir = await Directory('${extDir.path}/Zds-ui').create(recursive: true);
                  if (sensors.length == 1) {
                    final String filePath = '${testDir.path}/IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
                    return SingleCaptureRequest(filePath, sensors.first);
                  } else {
                    // Separate pictures taken with front and back camera
                    return MultipleCaptureRequest({
                      for (final sensor in sensors)
                        sensor: '${testDir.path}/IMG_${DateTime.now().millisecondsSinceEpoch}.jpg',
                    });
                  }
                },
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZdsCameraMode>('cameraMode', cameraMode))
      ..add(DiagnosticsProperty<Duration?>('maxVideoDuration', maxVideoDuration))
      ..add(DiagnosticsProperty<bool>('showPreview', showPreview))
      ..add(ObjectFlagProperty<CaptureRequestBuilder?>.has('photoPathBuilder', photoPathBuilder))
      ..add(ObjectFlagProperty<CaptureRequestBuilder?>.has('videoPathBuilder', videoPathBuilder))
      ..add(IterableProperty<AwesomeFilter>('filters', filters));
  }
}

class _CameraWrapper extends StatefulWidget {
  const _CameraWrapper({
    required this.state,
    required this.cameraMode,
    this.maxVideoDuration,
    required this.onPhoto,
    required this.onVideo,
  });

  final CameraState state;
  final ZdsCameraMode cameraMode;
  final void Function(CaptureRequest request) onPhoto;
  final void Function(CaptureRequest request) onVideo;
  final Duration? maxVideoDuration;

  @override
  State<_CameraWrapper> createState() => _CameraWrapperState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<CameraState>('state', state))
      ..add(EnumProperty<ZdsCameraMode>('cameraMode', cameraMode))
      ..add(DiagnosticsProperty<Duration?>('maxVideoDuration', maxVideoDuration))
      ..add(ObjectFlagProperty<void Function(CaptureRequest request)>.has('onPhoto', onPhoto))
      ..add(ObjectFlagProperty<void Function(CaptureRequest request)>.has('onVideo', onVideo));
  }
}

class _CameraWrapperState extends State<_CameraWrapper> {
  int _elapsed = 0;

  int get elapsed => _elapsed;

  set elapsed(int value) {
    if (mounted) setState(() => _elapsed = value);
  }

  ZdsPausableTimer? timer;

  @override
  void initState() {
    super.initState();
    widget.state.captureState$.listen((event) {
      if (event?.videoState == VideoState.started) {
        timer = ZdsPausableTimer(const Duration(seconds: 1), () {
          elapsed = elapsed + 1;
          if (widget.maxVideoDuration != null && elapsed > widget.maxVideoDuration!.inSeconds) {
            timer?.cancel();
            elapsed = 0;
            widget.state.when(
              onVideoRecordingMode: (state) {
                unawaited(state.stopRecording(onVideo: widget.onVideo));
              },
            );
          }
        });
      } else if (event?.videoState == VideoState.paused) {
        timer?.pause();
      } else if (event?.videoState == VideoState.resumed) {
        timer?.resume();
      } else if (event?.videoState == VideoState.stopped) {
        timer?.cancel();
        elapsed = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AwesomeThemeProvider.of(context).theme;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.state is! VideoRecordingCameraState)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: AwesomeCircleWidget(
                      theme: theme,
                      size: 45,
                      child: const Icon(Icons.close, color: ZetaColorBase.white),
                    ),
                  ),
                const Spacer(),
                if (widget.state is! VideoRecordingCameraState)
                  AwesomeFlashButton(state: widget.state)
                else if (widget.state is VideoRecordingCameraState) ...[
                  _ElapsedTime(elapsedTime: Duration(seconds: elapsed), totalTime: widget.maxVideoDuration),
                  const Spacer(),
                ],
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Spacer(),
                if (widget.state is PhotoCameraState && (widget.state as PhotoCameraState).hasFilters)
                  AwesomeFilterWidget(state: widget.state)
                else if (!kIsWeb && Platform.isAndroid)
                  AwesomeZoomSelector(state: widget.state),
                AwesomeCameraModeSelector(state: widget.state),
              ],
            ),
          ),
          ColoredBox(
            color: theme.bottomActionsBackgroundColor,
            child: Column(
              children: [
                AwesomeBottomActions(
                  state: widget.state,
                  left: widget.state is PhotoCameraState
                      ? Builder(
                          builder: (context) {
                            final theme = AwesomeThemeProvider.of(context).theme;
                            return AwesomeAspectRatioButton(
                              state: widget.state as PhotoCameraState,
                              theme: theme.copyWith(
                                buttonTheme: theme.buttonTheme.copyWith(
                                  backgroundColor: Colors.white12,
                                ),
                              ),
                            );
                          },
                        )
                      : widget.state is VideoRecordingCameraState
                          ? Builder(
                              builder: (context) {
                                final theme = AwesomeThemeProvider.of(context).theme;
                                return AwesomePauseResumeButton(
                                  state: widget.state as VideoRecordingCameraState,
                                  theme: theme.copyWith(
                                    buttonTheme: theme.buttonTheme.copyWith(
                                      backgroundColor: Colors.white12,
                                    ),
                                  ),
                                );
                              },
                            )
                          : const SizedBox.shrink(),
                  right: widget.state is VideoRecordingCameraState
                      ? const SizedBox.shrink()
                      : Builder(
                          builder: (context) {
                            final theme = AwesomeThemeProvider.of(context).theme;
                            return AwesomeCameraSwitchButton(
                              state: widget.state,
                              theme: theme.copyWith(
                                buttonTheme: theme.buttonTheme.copyWith(
                                  backgroundColor: Colors.white12,
                                ),
                              ),
                            );
                          },
                        ),
                  captureButton: _CaptureButton(
                    state: widget.state,
                    onPhoto: widget.onPhoto,
                    onVideo: widget.onVideo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ZdsPausableTimer?>('timer', timer))
      ..add(IntProperty('elapsed', elapsed));
  }
}

class _ElapsedTime extends StatelessWidget {
  const _ElapsedTime({
    required this.elapsedTime,
    this.totalTime,
  });

  final Duration elapsedTime;
  final Duration? totalTime;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTimeStr = _formatDuration(elapsedTime);
    final totalTimeStr = totalTime != null ? _formatDuration(totalTime!) : null;
    return ZdsTag(
      customBackgroundColor: ZetaColorBase.red,
      child: Text(
        totalTimeStr != null ? '$elapsedTimeStr/$totalTimeStr' : elapsedTimeStr,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ZetaColorBase.white, // Use the determined text color
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Duration?>('totalTime', totalTime))
      ..add(DiagnosticsProperty<Duration>('elapsedTime', elapsedTime));
  }
}

class _CaptureButton extends StatefulWidget {
  const _CaptureButton({
    this.onPhoto,
    this.onVideo,
    required this.state,
  });

  final CameraState state;
  final void Function(CaptureRequest request)? onPhoto;
  final void Function(CaptureRequest request)? onVideo;

  @override
  _CaptureButtonState createState() => _CaptureButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<CameraState>('state', state))
      ..add(ObjectFlagProperty<void Function(CaptureRequest request)?>.has('onPhoto', onPhoto))
      ..add(ObjectFlagProperty<void Function(CaptureRequest request)?>.has('onVideo', onVideo));
  }
}

class _CaptureButtonState extends State<_CaptureButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double _scale;

  bool _capturing = false;

  bool get capturing => _capturing;

  set capturing(bool value) {
    if (_capturing == value) return;
    if (mounted) setState(() => _capturing = value);
  }

  final Duration _duration = const Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state is AnalysisController) {
      return Container();
    }

    _scale = 1 - _animationController.value;

    return ZdsConditionalWrapper(
      condition: widget.state is PhotoCameraState && capturing,
      wrapperBuilder: (Widget child) {
        return Stack(
          children: [
            ZdsAbsorbPointer(child: child),
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: SizedBox(
          key: const ValueKey('cameraButton'),
          height: 80,
          width: 80,
          child: Transform.scale(
            scale: _scale,
            child: CustomPaint(
              painter: widget.state.when(
                onPhotoMode: (_) => _CameraButtonPainter(),
                onPreparingCamera: (_) => _CameraButtonPainter(),
                onVideoMode: (_) => _VideoButtonPainter(),
                onVideoRecordingMode: (_) => _VideoButtonPainter(isRecording: true),
              ) as CustomPainter?,
            ),
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    unawaited(HapticFeedback.selectionClick());
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(_duration, () {
      _animationController.reverse();
    });

    onTap.call();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  Null Function() get onTap => () {
        capturing = true;
        widget.state.when(
          onPhotoMode: (photoState) =>
              unawaited(photoState.takePhoto(onPhoto: widget.onPhoto).whenComplete(() => capturing = false)),
          onVideoMode: (videoState) => unawaited(videoState.startRecording()),
          onVideoRecordingMode: (videoState) =>
              unawaited(videoState.stopRecording(onVideo: widget.onVideo).whenComplete(() => capturing = false)),
        );
      };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('capturing', capturing));
  }
}

class _CameraButtonPainter extends CustomPainter {
  _CameraButtonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bgPainter = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    bgPainter.color = ZetaColorBase.white.withOpacity(.5);
    canvas.drawCircle(center, radius, bgPainter);

    bgPainter.color = ZetaColorBase.white;
    canvas.drawCircle(center, radius - 8, bgPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _VideoButtonPainter extends CustomPainter {
  _VideoButtonPainter({this.isRecording = false});

  final bool isRecording;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPainter = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    bgPainter.color = ZetaColorBase.white.withOpacity(.5);
    canvas.drawCircle(center, radius, bgPainter);

    if (isRecording) {
      bgPainter.color = ZetaColorBase.red;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            17,
            17,
            size.width - (17 * 2),
            size.height - (17 * 2),
          ),
          const Radius.circular(12),
        ),
        bgPainter,
      );
    } else {
      bgPainter.color = ZetaColorBase.red;
      canvas.drawCircle(center, radius - 8, bgPainter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ImagePreviewer extends StatelessWidget {
  const _ImagePreviewer({required this.imageFile});

  final XFile imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ZdsInteractiveViewer(
                  clipBehavior: Clip.none,
                  minScale: 1,
                  maxScale: 4,
                  child: XImage.file(imageFile),
                ),
              ),
            ),
            const _PreviewActions(),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<XFile>('imageFile', imageFile));
  }
}

class _VideoPreviewer extends StatelessWidget {
  const _VideoPreviewer({required this.videoFile});

  final XFile videoFile;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<XFile>('videoFile', videoFile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ZdsVideoPlayer(videoFile: videoFile, autoPlay: true, looping: true),
            ),
            const _PreviewActions(),
          ],
        ),
      ),
    );
  }
}

class _PreviewActions extends StatelessWidget {
  const _PreviewActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            elevation: 0,
            shape: const CircleBorder(),
            backgroundColor: Colors.black38,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Icon(Icons.close, color: ZetaColorBase.white),
          ),
          FloatingActionButton(
            elevation: 0,
            shape: const CircleBorder(),
            backgroundColor: Colors.black38,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Icon(Icons.done, color: ZetaColorBase.white),
          ),
        ],
      ),
    );
  }
}
