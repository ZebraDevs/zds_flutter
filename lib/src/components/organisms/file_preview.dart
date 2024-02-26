import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/assets/icons.dart';
import '../../utils/localizations/translation.dart';
import '../../utils/tools/utils.dart';
import '../atoms/card.dart';
import '../atoms/ximage.dart';
import 'file_picker/file_picker.dart';

/// Creates a preview of a file.
///
/// If the file is an image, a image preview will be shown. If not, an icon representing the filetype will be shown.
/// When [useCard] is true, the extension's name will also be shown if the file is not an image.
///
/// When [useCard] is true, the user will be able to interact with the preview through [onTap] and [onDelete].
///
/// See also:
///
///  * [ZdsFilePicker], which uses this component to show previews of chosen files.
class ZdsFilePreview extends StatelessWidget {
  /// Constructs a [ZdsFilePreview].
  const ZdsFilePreview({
    required this.file,
    super.key,
    this.useCard = true,
    this.size = 80.0,
    this.onDelete,
    this.onTap,
  });

  /// The file that needs to be previewed.
  final FileWrapper file;

  /// The maximum preview size.
  ///
  /// If [useCard] is true, the size will be respected on both sides. If false, and the file is an image, the image
  /// ratio will affect the size, with the longest side taking this size.
  ///
  /// Defaults to 80.
  final double size;

  /// Whether to use a card-like preview that can also be removed and tapped on. If false,
  ///
  /// Defaults to true.
  final bool useCard;

  /// A function called whenever [useCard] is true and the user taps on the remove button.
  final VoidCallback? onDelete;

  /// A function called whenever [useCard] is true and the user taps on the preview.
  ///
  /// Typically used to edit or view the file.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        SizedBox(
          height: size,
          width: size,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: useCard
                ? Semantics(
                    button: true,
                    label: ComponentStrings.of(context).get('ATTACHED_FILE', 'Attached file'),
                    onTapHint: ComponentStrings.of(context).get('VIEW', 'View'),
                    child: ZdsCard(onTap: onTap, padding: EdgeInsets.zero, child: _getPreview(size)),
                  )
                : Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
                    child: Center(child: _getPreview(size)),
                  ),
          ),
        ),
        if (onDelete != null)
          Positioned(
            top: -15,
            right: -15,
            child: SizedBox(
              height: 46,
              width: 44,
              child: IconButton(
                tooltip: ComponentStrings.of(context).get('DELETE_ATTACHMENT', 'Delete attachment'),
                padding: EdgeInsets.zero,
                splashRadius: 24,
                visualDensity: VisualDensity.compact,
                icon: Icon(ZdsIcons.close_circle, size: 24, color: Zeta.of(context).colors.error),
                onPressed: onDelete,
              ),
            ),
          ),
      ],
    );
  }

  Widget _getPreview(double size) {
    return file.content is GiphyGif
        // ignore: avoid_dynamic_calls
        ? _getImage(Uri.parse(file.content.images!.previewGif.url as String), size)
        : file.isImage()
            ? _getImage(file.content, size)
            : _getFile(file);
  }

  Widget _getImage(dynamic file, double size) {
    return file is Uri
        ? Image.network(file.toString(), fit: BoxFit.cover, height: size, width: size)
        : file is XFile
            ? XImage.file(file, height: size, width: size)
            : const SizedBox();
  }

  Widget _getFile(FileWrapper file) {
    return Builder(
      builder: (BuildContext context) {
        final bool isUrl = file.type == FilePickerOptions.LINK;
        final themeData = Theme.of(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              isUrl ? ZdsIcons.sphere : file.name?.fileIcon(),
              size: 18,
              color: themeData.colorScheme.secondary,
            ),
            if (size >= 80) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                isUrl ? file.name ?? '' : (path.extension(file.name ?? 'file.file').replaceAll('.', '')),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: themeData.textTheme.bodyMedium?.copyWith(color: themeData.colorScheme.secondary),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FileWrapper>('file', file))
      ..add(DoubleProperty('size', size))
      ..add(DiagnosticsProperty<bool>('useCard', useCard))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onDelete', onDelete))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}

/// [Text] widget showing size of the [file]
///
/// The file size is read asynchronously and shown in readable format.
class ZdsFileSize extends StatelessWidget {
  /// Default constructor
  const ZdsFileSize({super.key, this.file, this.fileSize})
      : assert(file != null || fileSize != null, 'Either file or fileSize is required');

  /// File input to show file size
  final XFile? file;

  /// File size
  final int? fileSize;

  Widget _sizeText(BuildContext context, int size) {
    return Text(
      fileSizeWithUnit(size),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Zeta.of(context).colors.textSubtle),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return FutureBuilder<int>(
        // ignore: discarded_futures
        future: file!.length(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.data != null) {
            return _sizeText(context, snapshot.data ?? 0);
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    } else {
      return _sizeText(context, fileSize ?? 0);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<XFile?>('file', file))
      ..add(IntProperty('fileSize', fileSize));
  }
}
