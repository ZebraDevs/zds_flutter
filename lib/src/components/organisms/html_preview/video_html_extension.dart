import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:video_player/video_player.dart';

/// [ZdsVideoHtmlExtension] adds support for the <video> tag to the flutter_html
/// library.
class ZdsVideoHtmlExtension extends HtmlExtension {
  /// Creates a new instance of the [ZdsVideoHtmlExtension] widget.
  const ZdsVideoHtmlExtension({
    this.videoControllerCallback,
    this.deviceOrientationsOnEnterFullScreen = const <DeviceOrientation>[DeviceOrientation.portraitUp],
    this.deviceOrientationsAfterFullScreen = const <DeviceOrientation>[DeviceOrientation.portraitUp],
  });
  //// VideoControllerCallback
  final VideoControllerCallback? videoControllerCallback;

  /// Defines the set of allowed device orientations on entering fullscreen
  final List<DeviceOrientation>? deviceOrientationsOnEnterFullScreen;

  /// Defines the set of allowed device orientations after exiting fullscreen
  final List<DeviceOrientation> deviceOrientationsAfterFullScreen;

  @override
  Set<String> get supportedTags => <String>{'video'};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
      child: LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints box) {
          return DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.4), width: 0.5),
            ),
            child: ZdsVideoWidget(
              context: context,
              callback: videoControllerCallback,
              deviceOrientationsAfterFullScreen: deviceOrientationsAfterFullScreen,
              deviceOrientationsOnEnterFullScreen: deviceOrientationsOnEnterFullScreen,
            ),
          );
        },
      ),
    );
  }
}

/// A VideoWidget for displaying within the HTML tree.
class ZdsVideoWidget extends StatefulWidget {
  /// Creates a new instance of the [ZdsVideoWidget] widget.
  const ZdsVideoWidget({
    required this.context,
    super.key,
    this.callback,
    this.deviceOrientationsOnEnterFullScreen,
    this.deviceOrientationsAfterFullScreen = DeviceOrientation.values,
  });

  /// Provides information about the current element on the Html tree for
  /// an `Extension` to use.
  final ExtensionContext context;

  //// VideoControllerCallback
  final VideoControllerCallback? callback;

  /// Defines the set of allowed device orientations on entering fullscreen
  final List<DeviceOrientation>? deviceOrientationsOnEnterFullScreen;

  //// Defines the set of allowed device orientations after exiting fullscreen
  final List<DeviceOrientation> deviceOrientationsAfterFullScreen;

  @override
  State<StatefulWidget> createState() => _VideoWidgetState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ExtensionContext>('context', context))
      ..add(ObjectFlagProperty<VideoControllerCallback?>.has('callback', callback))
      ..add(
        IterableProperty<DeviceOrientation>('deviceOrientationsOnEnterFullScreen', deviceOrientationsOnEnterFullScreen),
      )
      ..add(
        IterableProperty<DeviceOrientation>('deviceOrientationsAfterFullScreen', deviceOrientationsAfterFullScreen),
      );
  }
}

class _VideoWidgetState extends State<ZdsVideoWidget> with AutomaticKeepAliveClientMixin {
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;
  double? _width;
  double? _height;

  @override
  void initState() {
    super.initState();
    final LinkedHashMap<String, String> attributes = widget.context.attributes;

    final List<String?> sources = <String?>[
      if (attributes['src'] != null) attributes['src'],
      ...ReplacedElement.parseMediaSources(widget.context.node.children),
    ];

    final double? givenWidth = double.tryParse(attributes['width'] ?? '');
    final double? givenHeight = double.tryParse(attributes['height'] ?? '');

    if (sources.isNotEmpty && sources.first != null) {
      _width = givenWidth ?? (givenHeight ?? 150) * 2;
      _height = givenHeight ?? (givenWidth ?? 300) / 2;

      final Uri sourceUri = Uri.parse(sources.first!);
      switch (sourceUri.scheme) {
        case 'asset':
          _videoController = VideoPlayerController.asset(sourceUri.path);
        case 'file':
          _videoController = VideoPlayerController.file(File.fromUri(sourceUri));
        default:
          _videoController = VideoPlayerController.networkUrl(sourceUri);
          break;
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        placeholder: attributes['poster'] != null && attributes['poster']!.isNotEmpty
            ? Image.network(attributes['poster']!)
            : Container(color: Colors.black),
        autoPlay: attributes['autoplay'] != null,
        looping: attributes['loop'] != null,
        showControls: attributes['controls'] != null,
        autoInitialize: true,
        aspectRatio: _width == null || _height == null ? null : _width! / _height!,
        deviceOrientationsOnEnterFullScreen: widget.deviceOrientationsOnEnterFullScreen,
        deviceOrientationsAfterFullScreen: widget.deviceOrientationsAfterFullScreen,
      );

      widget.callback?.call(
        widget.context.element,
        _chewieController!,
        _videoController!,
      );
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    unawaited(_videoController?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext bContext) {
    super.build(context);
    if (_chewieController == null) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: _width != null && _height != null ? _width! / _height! : 16 / 9,
      child: Chewie(
        controller: _chewieController!,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
