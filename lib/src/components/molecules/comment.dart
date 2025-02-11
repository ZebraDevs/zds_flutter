import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../zds_flutter.dart';

/// Displays a comment with an optional attachment and delete and reply swipeable actions.
class ZdsComment extends StatelessWidget {
  /// Constructs a [ZdsComment] widget.
  const ZdsComment({
    this.author,
    this.comment,
    this.isReply = false,
    this.avatar,
    this.timeStamp,
    this.onDelete,
    this.onReply,
    super.key,
    this.attachment,
    this.downloadCallback,
    this.deleteSemanticLabel,
    this.replySemanticLabel,
    this.attachmentThumbnail,
    this.menuItems,
    this.menuPosition = ZdsPopupMenuPosition.bottomRight,
    this.onMenuItemSelected,
  })  : assert(
          onReply != null && replySemanticLabel != null || onReply == null && replySemanticLabel == null,
          'replySemanticLabel must be not null if onReply is defined',
        ),
        assert(
          onDelete != null && deleteSemanticLabel != null || onDelete == null && deleteSemanticLabel == null,
          'deleteSemanticLabel must be not null if onDelete is defined',
        );

  /// The comment text.
  final String? comment;

  /// The avatar widget to display.
  /// Should be a [ZetaAvatar]
  final Widget? avatar;

  /// The timestamp of the comment.
  final String? timeStamp;

  /// The author of the comment.
  final String? author;

  /// Whether the comment is a reply.
  /// If this is true, the reply action will automatically be hidden.
  final bool isReply;

  /// The callback to be called when the delete action is tapped.
  /// If this is null, the delete action will be hidden.
  /// If this is not null, [deleteSemanticLabel] must also be not null.
  final VoidCallback? onDelete;

  /// The semantic label for the delete action.
  final String? deleteSemanticLabel;

  /// The callback to be called when the reply action is tapped.
  /// If this is null, the reply action will be hidden.
  /// If this is not null, [replySemanticLabel] must also be not null.
  final VoidCallback? onReply;

  /// The semantic label for the reply action.
  final String? replySemanticLabel;

  /// The attachment to display.
  final ZdsChatAttachment? attachment;

  /// The callback to be called when the attachment is tapped.
  final VoidCallback? downloadCallback;

  /// The custom thumbnail to display for the attachment.
  final Widget? attachmentThumbnail;

  /// The menu items to display in the popup menu.
  /// If defined, the pouup menu will be shown when the user taps on the comment.
  final List<ZdsPopupMenuItem<int>>? menuItems;

  /// The popup menu position to display in the popup menu items.
  final ZdsPopupMenuPosition? menuPosition;

  /// The callback to be called when a menu item is selected.
  /// Menu items must be given a value for the callback to trigger.
  final ValueChanged<int>? onMenuItemSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    final spacing = Zeta.of(context).spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isReply)
          Padding(
            padding: EdgeInsets.only(
              left: spacing.large,
              right: spacing.minimum,
              top: spacing.minimum,
            ),
            child: const ZetaIcon(
              ZetaIcons.reply,
              size: 24,
              applyTextScaling: true,
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ZdsSlidableListTile(
                width: constraints.maxWidth,
                elevation: 0,
                actions: [
                  if (!isReply && onReply != null && replySemanticLabel != null)
                    ZdsSlidableAction(
                      icon: ZetaIcons.reply,
                      semanticLabel: replySemanticLabel,
                      foregroundColor: colors.primary,
                      backgroundColor: colors.surfacePrimarySubtle,
                      onPressed: (_) => onReply!(),
                    ),
                  if (onDelete != null && deleteSemanticLabel != null)
                    ZdsSlidableAction(
                      icon: ZetaIcons.delete,
                      semanticLabel: deleteSemanticLabel,
                      onPressed: (_) => onDelete!(),
                      backgroundColor: colors.surfaceNegativeSubtle,
                      foregroundColor: colors.error,
                    ),
                ],
                child: Builder(
                  builder: (context) {
                    final child = Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: colors.borderSubtle,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: spacing.large,
                        horizontal: spacing.medium,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: spacing.minimum),
                            child: Row(
                              children: [
                                if (avatar != null)
                                  Padding(
                                    padding: EdgeInsets.only(right: spacing.small),
                                    child: avatar,
                                  ),
                                if (author != null)
                                  Expanded(
                                    child: Text(
                                      author!,
                                      style: ZetaTextStyles.labelLarge.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (timeStamp != null)
                                  Padding(
                                    padding: EdgeInsets.only(left: spacing.small),
                                    child: Text(
                                      timeStamp!,
                                      style: ZetaTextStyles.bodyXSmall.copyWith(color: colors.textSubtle),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (comment != null)
                            Padding(
                              padding: EdgeInsets.only(
                                top: spacing.small,
                                left: spacing.minimum,
                                right: spacing.minimum,
                              ),
                              child: Text(
                                comment!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          if (attachment != null)
                            Padding(
                              padding: EdgeInsets.only(top: spacing.medium),
                              child: _AttachmentRow(
                                attachment: attachment!,
                                downloadCallback: downloadCallback,
                                customThumbnail: attachmentThumbnail,
                              ),
                            ),
                        ],
                      ),
                    );
                    if (menuItems != null) {
                      return ZdsPopupMenu<int>(
                        menuPosition: menuPosition ?? ZdsPopupMenuPosition.topRight,
                        verticalOffset: spacing.small,
                        items: menuItems ?? [],
                        onSelected: onMenuItemSelected,
                        builder: (context, open) {
                          return Material(
                            color: colors.surfacePrimary,
                            child: InkWell(
                              onTap: open,
                              child: child,
                            ),
                          );
                        },
                      );
                    }
                    return ColoredBox(color: colors.surfacePrimary, child: child);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('comment', comment))
      ..add(StringProperty('timeStamp', timeStamp))
      ..add(StringProperty('author', author))
      ..add(DiagnosticsProperty<bool>('isReply', isReply))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onDelete', onDelete))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onReply', onReply))
      ..add(DiagnosticsProperty<ZdsChatAttachment?>('attachment', attachment))
      ..add(ObjectFlagProperty<VoidCallback?>.has('downloadCallback', downloadCallback))
      ..add(StringProperty('deleteSemanticLabel', deleteSemanticLabel))
      ..add(StringProperty('replySemanticLabel', replySemanticLabel))
      ..add(EnumProperty<ZdsPopupMenuPosition>('menuPosition', menuPosition))
      ..add(ObjectFlagProperty<ValueChanged<int>?>.has('onMenuItemSelected', onMenuItemSelected));
  }
}

class _AttachmentRow extends StatelessWidget {
  const _AttachmentRow({
    required this.attachment,
    this.customThumbnail,
    this.downloadCallback,
  });

  final ZdsChatAttachment attachment;
  final VoidCallback? downloadCallback;
  final Widget? customThumbnail;

  @override
  Widget build(BuildContext context) {
    final spacing = Zeta.of(context).spacing;
    final colors = Zeta.of(context).colors;
    final radius = Zeta.of(context).radius;

    return Material(
      child: InkWell(
        borderRadius: radius.minimal,
        onTap: downloadCallback,
        child: Padding(
          padding: EdgeInsets.all(spacing.minimum),
          child: Row(
            children: [
              if (customThumbnail != null)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: customThumbnail,
                )
              else
                ZetaIcon(
                  extensionIcon('.${attachment.fileType}'),
                  color: iconColor('.${attachment.fileType}'),
                  size: 40,
                ),
              SizedBox(width: spacing.small),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      attachment.name,
                      style: ZetaTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (attachment.size != null)
                      Text(
                        attachment.size!,
                        style: ZetaTextStyles.bodySmall.copyWith(color: colors.textSubtle),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ZdsChatAttachment>('attachment', attachment))
      ..add(ObjectFlagProperty<VoidCallback?>.has('downloadCallback', downloadCallback));
  }
}
