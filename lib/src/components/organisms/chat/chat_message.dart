import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';
import 'chat_utils.dart';
import 'message_body/deleted.dart';
import 'message_body/file_preview.dart';
import 'message_body/forwarded.dart';
import 'message_body/info.dart';
import 'message_body/read_receipt.dart';
import 'message_body/reply.dart';
import 'message_body/text.dart';
import 'reacts_tags.dart';

/// Chat message widget.
class ZdsChatMessage extends StatelessWidget {
  /// Constructs a [ZdsChatMessage].
  const ZdsChatMessage({
    super.key,
    required this.message,
    this.isLocalUser = true,
    this.shouldShake = false,
    this.highlight = false,
    this.searchTerm,
    this.onTagTapped,
    this.onReactTapped,
    this.onReplyTap,
    this.onLinkTapped,
    this.onLongPress,
    this.showFilePreview = true,
    this.onFileDownload,
  })  : child = null,
        senderName = null;

  /// Allows for custom child to be passed into a [ZdsChatMessage] body.
  const ZdsChatMessage.wrapper({
    super.key,
    required this.child,
    required this.isLocalUser,
    required this.senderName,
    this.shouldShake = false,
    this.onTagTapped,
    this.onReactTapped,
    this.onLongPress,
  })  : message = const ZdsMessage.blank(),
        highlight = false,
        searchTerm = '',
        onReplyTap = null,
        onLinkTapped = null,
        onFileDownload = null,
        showFilePreview = false;

  /// Information for chat message. See [ZdsMessage].
  final ZdsMessage message;

  /// If message is from local used.
  ///
  /// If false, displays message on leading side.
  /// If true, displays message on trailing side.
  ///
  /// Defaults to false.
  final bool isLocalUser;

  /// If true, whole message will be highlighted to get the users attention.
  ///
  /// Defaults to false.
  final bool highlight;

  /// If message should shake to get the users attention.
  ///
  /// Defaults to false.
  final bool shouldShake;

  /// Used to highlight searched words.
  final String? searchTerm;

  /// Callback for when the tag pill is tapped.
  final VoidCallback? onTagTapped;

  /// Callback for when the react pill is tapped.
  final VoidCallback? onReactTapped;

  /// Callback for when replying message is tapped.
  final ValueChanged<ZdsMessage>? onReplyTap;

  /// Callback for when a link is tapped.
  ///
  /// By default, nothing will happen when a link is tapped.
  final ValueChanged<String>? onLinkTapped;

  /// Callback for when message is long pressed.
  ///
  /// Typically used to open a menu for tags and reacts.
  final VoidCallback? onLongPress;

  /// Callback for user to download attachment.
  ///
  /// This does not trigger a download, but is a callback to start the download.
  final VoidCallback? onFileDownload;

  /// Child widget only used with [ZdsChatMessage.wrapper].
  final Widget? child;

  /// Sender name only used with [ZdsChatMessage.wrapper].
  final String? senderName;

  /// If true, supported file previews will be shown.
  ///
  /// Defaults to true.
  final bool showFilePreview;

  ZetaColorSwatch _getColor(BuildContext context) {
    final colors = Zeta.of(context).colors;
    if (highlight) {
      return colors.yellow;
    } else if (isLocalUser) {
      return colors.secondary;
    } else {
      return colors.cool;
    }
  }

  BorderRadius get _borderRadius {
    return BorderRadius.only(
      topLeft: const Radius.circular(6),
      topRight: const Radius.circular(6),
      bottomLeft: Radius.circular(isLocalUser ? 6 : 0),
      bottomRight: Radius.circular(isLocalUser ? 0 : 6),
    );
  }

  bool get _showReply => message.replyMessageInfo != null && !message.isDeleted;
  bool get _showForwarded => message.isForwarded && !message.isDeleted;

  Widget? get _body {
    if (message.isDeleted) {
      return ZdsChatDeletedText(textContent: message.content);
    } else if (message.type == ZdsChatMessageType.text && message.content != null) {
      return ZdsChatTextMessage(searchTerm: searchTerm, content: message.content!, onLinkTapped: onLinkTapped);
    } else if (message.isPreviewable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.content != null)
            ZdsChatTextMessage(
              searchTerm: searchTerm,
              content: message.content!,
              onLinkTapped: onLinkTapped,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            ),
          if (showFilePreview)
            ZdsChatFilePreview(
              type: message.attachmentType!,
              attachment: message.attachment,
              downloadCallback: onFileDownload,
            ),
        ],
      );
    } else {
      return const Text('TODO: UX-941 Attachment ').paddingAll(12);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.type == ZdsChatMessageType.info && message.content != null) {
      return ZdsChatInfoMessage(content: message.content!);
    }
    final body = _body;

    final ZetaColorSwatch color = _getColor(context);

    final child = Semantics(
      focusable: false,
      child: Column(
        crossAxisAlignment: isLocalUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isLocalUser && message.senderName.isNotEmpty)
            Semantics(
              focusable: true,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                child: Text(
                  message.senderName,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: message.senderColor ?? Zeta.of(context).colors.textDefault),
                ),
              ),
            ),
          Stack(
            children: [
              Semantics(
                focusable: true,
                child: GestureDetector(
                  onLongPress: onLongPress,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      color: color.surface,
                      border: Border.all(color: color.subtle),
                      borderRadius: _borderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_showReply) ZdsChatReplyMessageBody(message: message.replyMessageInfo!, onTap: onReplyTap),
                        if (_showForwarded) const ZdsChatForwarded(),
                        if (body != null) body,
                      ],
                    ),
                  ).paddingOnly(
                    left: isLocalUser ? 40 : 18,
                    right: isLocalUser ? 18 : 40,
                    bottom: (!message.isDeleted && (message.hasReacts || message.tags.isNotEmpty)) ? 18 : 4,
                  ),
                ),
              ),
              if (!message.isDeleted)
                Positioned(
                  bottom: 0,
                  right: isLocalUser ? 24 : null,
                  left: !isLocalUser ? 24 : null,
                  child: ReactTagsRow(
                    reacts: message.reacts,
                    tags: message.tags,
                    reverse: isLocalUser,
                    onTagTapped: onTagTapped,
                    onReactTapped: onReactTapped,
                  ),
                ),
            ],
          ),
          ZdsReadReceipt(
            timeString: message.timeString(context),
            isLocalUser: isLocalUser,
            status: message.status,
            messageDeleted: message.isDeleted,
          ),
        ],
      ),
    );

    return shouldShake ? _ShakeWrapper(child: child) : child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isLocalUser', isLocalUser))
      ..add(DiagnosticsProperty<bool>('highlight', highlight))
      ..add(DiagnosticsProperty<bool>('shouldShake', shouldShake))
      ..add(StringProperty('searchTerm', searchTerm))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTagTapped', onTagTapped))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onReactTapped', onReactTapped))
      ..add(DiagnosticsProperty<ZdsMessage>('message', message))
      ..add(ObjectFlagProperty<void Function(ZdsMessage info)?>.has('onReplyTap', onReplyTap))
      ..add(ObjectFlagProperty<void Function(String link)?>.has('onLinkTapped', onLinkTapped))
      ..add(StringProperty('senderName', senderName))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress))
      ..add(DiagnosticsProperty<bool>('showFilePreview', showFilePreview))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onFileDownload', onFileDownload));
  }
}

class _ShakeWrapper extends StatefulWidget {
  const _ShakeWrapper({required this.child});
  final Widget child;

  @override
  State<_ShakeWrapper> createState() => _ShakeWrapperState();
}

class _ShakeWrapperState extends State<_ShakeWrapper> {
  final GlobalKey<ZdsShakeAnimationState> _shakeKey = GlobalKey<ZdsShakeAnimationState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _shakeKey.currentState?.shake();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZdsShakeAnimation(
      shakeOffset: 6,
      shakeCount: 2,
      shakeDuration: const Duration(milliseconds: 500),
      key: _shakeKey,
      child: widget.child,
    );
  }
}
