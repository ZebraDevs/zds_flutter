import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../../zds_flutter.dart';
import 'attachment.dart';
import 'chat_utils.dart';

/// Shows a preview of an attachment for [ZdsChatMessage].
class ZdsChatFilePreview extends StatefulWidget {
  /// Constructs a [ZdsChatFilePreview].
  const ZdsChatFilePreview({
    super.key,
    required this.attachment,
    this.downloadCallback,
  });

  /// Attachment to be previewed.
  final ZdsChatAttachment attachment;

  /// Callback to trigger file download.
  final VoidCallback? downloadCallback;

  @override
  State<ZdsChatFilePreview> createState() => _ZdsChatFilePreviewState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('attachment', attachment))
      ..add(ObjectFlagProperty<VoidCallback>.has('downloadCallback', downloadCallback));
  }
}

class _ZdsChatFilePreviewState extends State<ZdsChatFilePreview> {
  bool _fileError = false;

  @override
  Widget build(BuildContext context) {
    final Widget? body;
    bool hero = false;
    switch (widget.attachment.type) {
      case ZdsChatAttachmentType.imageBase64:
        hero = true;
        body = Image.memory(const Base64Decoder().convert((widget.attachment.content.toString().base64) ?? ''));
      case ZdsChatAttachmentType.imageNetwork:
        hero = true;
        body = CachedNetworkImage(
          imageUrl: widget.attachment.url?.toString() ?? '',
          errorListener: (value) => setState(() => _fileError = true),
          placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
          errorWidget: (context, url, error) => ZdsChatAttachmentWidget.fromAttachment(
            attachment: widget.attachment,
            onTap: widget.downloadCallback,
          ),
        );
      case ZdsChatAttachmentType.imageLocal:
        hero = true;
        body = Image.file(widget.attachment as File);
      case ZdsChatAttachmentType.videoNetwork:
      case ZdsChatAttachmentType.videoLocal:
        body = _Video(type: widget.attachment.type, video: widget.attachment as String);
      case ZdsChatAttachmentType.audioNetwork:
      case ZdsChatAttachmentType.audioLocal:
        body = const Text('Not done');
      case ZdsChatAttachmentType.doc:
        body = null;
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
              ComponentStrings.of(context).get('DOWNLOAD', 'Download'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );

    final heroWidget = Hero(
      createRectTween: (Rect? begin, Rect? end) => RectTween(begin: begin, end: end),
      // If multiple files have the same name, Hero should still function.
      tag: widget.attachment.name + (Random().nextDouble() * 100).toString(),
      child: body ?? const SizedBox(),
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        padding: _fileError ? EdgeInsets.zero : const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_fileError && hero)
              InkWell(
                onTap: () => unawaited(
                  Navigator.of(context).push(
                    ZdsFadePageRouteBuilder(
                      opaque: false,
                      builder: (_) => _FullScreenViewer(
                        imageBytes: widget.attachment.type == ZdsChatAttachmentType.imageBase64
                            ? widget.attachment.content.toString().base64
                            : null,
                        imagePath: widget.attachment.type == ZdsChatAttachmentType.imageLocal
                            ? widget.attachment.content
                            : null,
                        imageUrl: widget.attachment.type == ZdsChatAttachmentType.imageNetwork
                            ? widget.attachment.content
                            : null,
                        body: heroWidget,
                      ),
                    ),
                  ),
                ),
                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: hero ? heroWidget : body),
              )
            else
              body ?? const SizedBox(),
            if (widget.downloadCallback != null && !_fileError) downloadRow,
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('attachment', widget.attachment));
  }
}

class _Video extends StatefulWidget {
  const _Video({required this.type, required this.video});

  final ZdsChatAttachmentType type;

  final String video;
  @override
  State<_Video> createState() => __VideoState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZdsChatAttachmentType>('type', type))
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

    if (widget.type == ZdsChatAttachmentType.videoLocal) {
      _videoController = VideoPlayerController.asset(widget.video);
    }
    if (widget.type == ZdsChatAttachmentType.videoNetwork) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.video));
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.type == ZdsChatAttachmentType.videoLocal || widget.type == ZdsChatAttachmentType.videoNetwork) {
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
