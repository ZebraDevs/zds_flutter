import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../zds_flutter.dart';

/// Attachment message body for [ZdsChatMessage].
class ZdsChatAttachmentWidget extends StatelessWidget {
  /// Constructs an [ZdsChatAttachmentWidget].
  const ZdsChatAttachmentWidget({super.key, required this.fileName, this.fileType, this.onTap});

  /// Constructs an attachment from a [ZdsChatAttachment] object.
  ZdsChatAttachmentWidget.fromAttachment({super.key, required ZdsChatAttachment attachment, this.onTap})
      : fileName = attachment.name,
        fileType = attachment.fileType;

  /// Name of file to download.
  final String fileName;

  /// File type, used to determine which icon to show.
  final String? fileType;

  /// Callback for when the message is tapped.
  ///
  /// Typically triggers file download.
  final VoidCallback? onTap;

  String get _fileType {
    if (fileType != null) return fileType!;
    return fileName.contains('.') ? fileName.split('.').last : '';
  }

  String get _fileName {
    if (fileName.contains('.')) return fileName;
    return '$fileName.$_fileType';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    final foregroundColor = iconColor(_fileType, context: context);
    final layoutBuilder = LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfacePrimary,
                borderRadius: ZetaRadius.rounded,
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(extensionIcon(_fileType), size: 32, color: foregroundColor),
                  if (_fileType.isNotEmpty)
                    Text(
                      _fileType,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: foregroundColor),
                    ).paddingTop(4),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth - 116),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ComponentStrings.of(context).get('SHARE_FILE', 'Shared a file:'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textSubtle),
                  ),
                  const SizedBox.square(dimension: 2),
                  Text(
                    _fileName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textDefault),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox.square(dimension: 12),
                  Icon(ZdsIcons.download, size: 20, color: colors.iconSubtle),
                ],
              ),
            ),
            const SizedBox.square(dimension: 12),
          ],
        );
      },
    );

    return onTap != null ? InkWell(onTap: onTap, child: layoutBuilder) : layoutBuilder;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap))
      ..add(StringProperty('fileType', fileType))
      ..add(StringProperty('fileName', fileName));
  }
}
