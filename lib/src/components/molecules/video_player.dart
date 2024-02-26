import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

/// A custom video player widget.
///
/// This widget uses the Chewie and Video Player packages to play a video from a file or a network URL.
class ZdsVideoPlayer extends StatefulWidget {
  /// Creates a new instance of ZdsVideoPlayer.
  ///
  /// Either [videoFile] or [videoUri] must be provided.
  const ZdsVideoPlayer({super.key, this.videoFile, this.videoUri, this.autoPlay = false, this.looping = false})
      : assert(videoFile != null || videoUri != null, 'File or URI must be provided.');

  /// The video file to be played.
  ///
  /// This is used when the video is available locally.
  final XFile? videoFile;

  /// The network URL of the video to be played.
  ///
  /// This is used when the video is not available locally.
  final Uri? videoUri;

  /// Whether the video should start playing automatically.
  ///
  /// Defaults to false.
  final bool autoPlay;

  /// Whether the video should loop after it ends.
  ///
  /// Defaults to false.
  final bool looping;

  @override
  ZdsVideoPlayerState createState() => ZdsVideoPlayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<XFile?>('videoFile', videoFile))
      ..add(DiagnosticsProperty<Uri?>('videoUri', videoUri))
      ..add(DiagnosticsProperty<bool>('autoPlay', autoPlay))
      ..add(DiagnosticsProperty<bool>('looping', looping));
  }
}

/// The state associated with a [ZdsVideoPlayer] widget.
///
/// This class manages the video playback using a [VideoPlayerController] and a [ChewieController].
class ZdsVideoPlayerState extends State<ZdsVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    unawaited(initializePlayer());
  }

  /// Initializes the video player.
  ///
  /// If a video file is provided, it initializes a [VideoPlayerController] with the file.
  /// If a network URL is provided, it initializes a [VideoPlayerController] with the URL.
  /// After the [VideoPlayerController] is initialized, it sets up a [ChewieController] for the video playback.
  Future<void> initializePlayer() async {
    if (widget.videoFile != null) {
      if (kIsWeb) {
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoFile!.path));
      } else {
        _videoPlayerController = VideoPlayerController.file(File(widget.videoFile!.path));
      }
    } else if (widget.videoUri != null) {
      _videoPlayerController = VideoPlayerController.networkUrl(widget.videoUri!);
    }

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final playerReady = _chewieController?.videoPlayerController.value.isInitialized ?? false;
    return ColoredBox(
      color: Colors.black,
      child: playerReady ? Chewie(controller: _chewieController!) : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    unawaited(_videoPlayerController.dispose());
    _chewieController?.dispose();
    super.dispose();
  }
}
