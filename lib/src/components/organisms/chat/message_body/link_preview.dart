import 'dart:async';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../zds_flutter.dart';

/// Shows a preview of a link in a [ZdsChatMessage].
///
/// Shows an image, the page title and the URL or page description.
class ZdsChatLinkPreview extends StatefulWidget {
  /// Constructs a [ZdsChatLinkPreview].
  const ZdsChatLinkPreview({
    super.key,
    required this.link,
    this.onTap,
    this.showDescription = false,
  });

  /// Link to display.
  final String link;

  /// Called when [ZdsChatLinkPreview] is tapped.
  final ValueChanged<String>? onTap;

  /// If true, shows longer description of link.
  /// If false, shows URL.
  ///
  /// Defaults to false.
  final bool showDescription;

  @override
  State<ZdsChatLinkPreview> createState() => _ZdsChatLinkPreviewState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('link', link))
      ..add(DiagnosticsProperty<bool>('showDescription', showDescription))
      ..add(ObjectFlagProperty<ValueChanged<String>?>.has('onTap', onTap));
  }
}

class _ZdsChatLinkPreviewState extends State<ZdsChatLinkPreview> {
  Metadata? _metadata;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    unawaited(getLinkPreview());
  }

  Future<void> getLinkPreview() async {
    final Metadata? metadata = await AnyLinkPreview.getMetadata(link: widget.link);
    if (metadata != null) {
      setState(() => _metadata = metadata);
    } else {
      setState(() => _error = true);
    }
  }

  Widget get buildImage {
    if (_metadata != null && _metadata!.hasData && _metadata?.image != null) {
      final image = _metadata!.image!;
      if (image.endsWith('svg')) {
        return SvgPicture.network(image);
      }
      return Image.network(image);
    }
    return const CircularProgressIndicator();
  }

  Widget get buildTitle {
    if (_metadata != null && _metadata!.hasData && _metadata?.title != null && _metadata!.title!.isNotEmpty) {
      return Text(
        _metadata!.title!,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      );
    }

    return _loadingLine;
  }

  Widget get _loadingLine {
    final colors = Zeta.of(context).colors;

    return Shimmer.fromColors(
      baseColor: colors.warm.shade40,
      highlightColor: colors.warm.shade60,
      child: Container(height: 16, color: colors.white),
    );
  }

  Widget get buildDescription {
    final String text;
    if (_metadata != null && _metadata!.hasData) {
      if (!widget.showDescription && _metadata?.url != null && _metadata!.url!.isNotEmpty) {
        text = _metadata!.url!;
      } else if (widget.showDescription && _metadata?.desc != null && _metadata!.desc!.isNotEmpty) {
        text = _metadata!.desc!;
      } else {
        text = '';
      }
    } else {
      return _loadingLine;
    }
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Zeta.of(context).colors.textSubtle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;

    return _error
        ? const SizedBox()
        : Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InkWell(
                onTap: () => widget.onTap?.call(widget.link),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Zeta.of(context).colors.warm.shade30.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: AbsorbPointer(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: zetaColors.secondary.shade10, shape: BoxShape.circle),
                          child: buildImage,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [buildTitle, const SizedBox(height: 8), buildDescription],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
