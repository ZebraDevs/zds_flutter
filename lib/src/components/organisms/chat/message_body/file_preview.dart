import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../../../../zds_flutter.dart';
import '../chat_utils.dart';

/// Shows a preview of an attachment for [ZdsChatMessage].
class ZdsChatFilePreview extends StatefulWidget {
  /// Constructs a [ZdsChatFilePreview].
  const ZdsChatFilePreview({
    super.key,
    this.attachment,
    required this.type,
    this.fileName,
    this.downloadCallback,
  });

  /// Constructs a file preview for image strings in base64 format.
  const ZdsChatFilePreview.imageBase64({
    super.key,
    required String imageString,
    this.fileName,
    this.downloadCallback,
  })  : attachment = imageString,
        type = AttachmentType.imageBase64;

  /// Attachment to be previewed.
  final dynamic attachment;

  /// Type of attachment.
  final AttachmentType type;

  /// File name.
  ///
  /// If not provided, generic download prompt will show.
  final String? fileName;

  /// Callback to trigger file download.
  final VoidCallback? downloadCallback;

  @override
  State<ZdsChatFilePreview> createState() => _ZdsChatFilePreviewState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('attachment', attachment))
      ..add(EnumProperty<AttachmentType>('type', type))
      ..add(StringProperty('fileName', fileName))
      ..add(ObjectFlagProperty<VoidCallback>.has('downloadCallback', downloadCallback));
  }
}

class _ZdsChatFilePreviewState extends State<ZdsChatFilePreview> {
  bool _fileError = false;

  @override
  Widget build(BuildContext context) {
    final Widget? body;
    bool hero = false;
    switch (widget.type) {
      case AttachmentType.imageBase64:
        hero = true;
        body = Image.memory(const Base64Decoder().convert((widget.attachment as String).base64 ?? ''));
      case AttachmentType.imageNetwork:
        hero = true;
        body = CachedNetworkImage(
          imageUrl: widget.attachment as String,
          errorListener: (value) => setState(() => _fileError = true),
          placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
          errorWidget: (context, url, error) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                ComponentStrings.of(context).get('MEDIA_ERROR', 'Error loading media.'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Zeta.of(context).colors.error.text,
                    ),
              ),
            );
          },
        );
      case AttachmentType.imageLocal:
        hero = true;
        body = Image.file(widget.attachment as File);
      case AttachmentType.videoNetwork:
      case AttachmentType.videoLocal:
        body = _Video(type: widget.type, video: widget.attachment as String);
      case AttachmentType.audioNetwork:
      case AttachmentType.audioLocal:
      case AttachmentType.docNetwork:
      case AttachmentType.docLocal:
        body = const Text('Not done');
    }

    final Widget downloadRow = InkWell(
      onTap: () => widget.downloadCallback?.call(),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ZdsIcons.download, size: 24, color: Zeta.of(context).colors.iconSubtle),
            const SizedBox.square(dimension: 10),
            Text(
              widget.fileName ?? ComponentStrings.of(context).get('DOWNLOAD', 'Download'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );

    final heroWidget = Hero(
      createRectTween: (Rect? begin, Rect? end) => RectTween(begin: begin, end: end),
      tag: widget.attachment.toString(),
      child: body,
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: !_fileError && hero
                  ? () => unawaited(
                        Navigator.of(context).push(
                          ZdsFadePageRouteBuilder(
                            opaque: false,
                            builder: (_) => _FullScreenViewer(
                              imageBytes:
                                  widget.type == AttachmentType.imageBase64 ? widget.attachment as String? : null,
                              imagePath: widget.type == AttachmentType.imageLocal ? widget.attachment as String? : null,
                              imageUrl:
                                  widget.type == AttachmentType.imageNetwork ? widget.attachment as String? : null,
                              body: heroWidget,
                            ),
                          ),
                        ),
                      )
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: hero ? heroWidget : body,
              ),
            ),
            if (widget.downloadCallback != null && !_fileError) downloadRow,
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('attachment', widget.attachment))
      ..add(EnumProperty<AttachmentType>('type', widget.type))
      ..add(StringProperty('fileName', widget.fileName));
  }
}

class _Video extends StatefulWidget {
  const _Video({required this.type, required this.video});

  final AttachmentType type;

  final String video;
  @override
  State<_Video> createState() => __VideoState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<AttachmentType>('type', type))
      ..add(StringProperty('video', video));
  }
}

class __VideoState extends State<_Video> {
  VideoPlayerController? _videoController;
  bool loading = true;
  bool? isPlaying;
  bool _hover = false;
  @override
  Future<void> dispose() async {
    super.dispose();
    if (_videoController != null) await _videoController!.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.type == AttachmentType.videoLocal) {
      _videoController = VideoPlayerController.asset(widget.video);
    }
    if (widget.type == AttachmentType.videoNetwork) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.video));
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.type == AttachmentType.videoLocal || widget.type == AttachmentType.videoNetwork) {
        await _videoController?.initialize();
        setState(() => loading = false);

        _videoController?.addListener(() {
          if (_videoController?.value.isPlaying != isPlaying) {
            setState(() => isPlaying = _videoController?.value.isPlaying);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO(thelukewalton): Videos don't play on emulator / simulator. https://github.com/flutter/flutter/issues/75995
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AspectRatio(
        aspectRatio: _videoController?.value.aspectRatio ?? 16 / 9,
        child: Stack(
          children: [
            if (_videoController != null) VideoPlayer(_videoController!),
            if (_videoController == null ||
                !_videoController!.value.isInitialized ||
                _videoController!.value.isBuffering)
              const Center(child: CircularProgressIndicator.adaptive()),
            if (!loading &&
                _videoController != null &&
                _videoController!.value.isInitialized &&
                !_videoController!.value.isBuffering)
              AnimatedOpacity(
                opacity: _hover || !_videoController!.value.isPlaying ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: FloatingActionButton(
                    elevation: 0,
                    onPressed: () async {
                      _videoController!.value.isPlaying
                          ? await _videoController!.pause()
                          : await _videoController!.play();
                      setState(() {});
                    },
                    backgroundColor: Zeta.of(context).colors.cool.shade30.withOpacity(0.7),
                    hoverColor: Zeta.of(context).colors.cool.shade30.withOpacity(0.5),
                    hoverElevation: 0,
                    child: Icon(
                      _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Zeta.of(context).colors.cool.shade30.onColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('loading', loading))
      ..add(DiagnosticsProperty<bool?>('isPlaying', isPlaying));
  }
}

class _FullScreenViewer extends StatelessWidget {
  const _FullScreenViewer({required this.body, this.imageUrl, this.imageBytes, this.imagePath});
  final Widget body;
  final String? imageUrl;
  final String? imageBytes;
  final String? imagePath;

  void onDragEnd(double velocity, BuildContext context) {
    if (velocity.abs() > 100) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black.onColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: imageBytes != null || imagePath != null || imageUrl != null
                ? () async {
                    if (imageBytes != null && imageBytes!.base64Extension != null) {
                      final image = XFile.fromData(
                        const Base64Decoder().convert(imageBytes!.base64!),
                        mimeType: imageBytes!.base64Extension,
                      );
                      await Share.shareXFiles([image]);
                    }
                    if (imagePath != null) {
                      await Share.shareXFiles([XFile(imagePath!)]);
                    }
                    if (imageUrl != null) {
                      await Share.shareUri(Uri.parse(imageUrl!));
                    }
                  }
                : null,
            icon: const Icon(Icons.share),
            padding: const EdgeInsets.all(16),
            color: Colors.black.onColor,
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragEnd: (d) => onDragEnd(d.primaryVelocity ?? 0, context),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: InteractiveViewer(
                      child: body,
                      onInteractionEnd: (details) => onDragEnd(details.velocity.pixelsPerSecond.dy, context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('imageUrl', imageUrl))
      ..add(StringProperty('imagePath', imagePath))
      ..add(StringProperty('imageBytes', imageBytes));
  }
}
