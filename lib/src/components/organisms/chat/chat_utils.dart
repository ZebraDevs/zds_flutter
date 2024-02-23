import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:validators/validators.dart';

import '../../../../zds_flutter.dart';

/// Type of message for [ZdsChatMessage].
enum ZdsChatMessageType {
  /// Text only message.
  text,

  /// Attachment only message.
  attachment,

  /// Information message. Not from a user.
  info,
}

/// Status of message for [ZdsChatMessage].
enum ZdsChatMessageStatus {
  /// Message not yet sent.
  notSent,

  /// Message sent, not yet delivered.
  sent,

  /// Message delivered, not yet read.
  delivered,

  /// Message read.
  read,

  /// Message status unknown.
  unknown
}

/// Message model for [ZdsChatMessage].
class ZdsMessage {
  /// Constructs a [ZdsMessage].
  ///
  /// For data safety, please use a named constructor: [ZdsMessage.text], [ZdsMessage.attachment] or [ZdsMessage.info].
  const ZdsMessage({
    required this.time,
    this.status = ZdsChatMessageStatus.unknown,
    this.senderName = '',
    this.content,
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.attachment,
    this.isInfo = false,
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
    this.attachmentType,
  });

  /// Constructs a Text only message.
  const ZdsMessage.text({
    required this.status,
    required this.time,
    required this.content,
    this.senderName = '',
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
  })  : attachment = null,
        isInfo = false,
        attachmentType = null;

  /// Constructs a message with an image attachment as a base64 image.
  const ZdsMessage.imageBase64({
    required this.status,
    required this.time,
    required String image,
    String? text,
    this.senderName = '',
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
  })  : content = text,
        attachment = image,
        isInfo = false,
        attachmentType = AttachmentType.imageBase64;

  /// Constructs a message with an image attachment with a local file path.
  const ZdsMessage.imageLocal({
    required this.status,
    required this.time,
    required String filePath,
    String? text,
    this.senderName = '',
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
  })  : content = text,
        attachment = filePath,
        isInfo = false,
        attachmentType = AttachmentType.imageNetwork;

  /// Constructs a message with an image attachment with a network url.
  const ZdsMessage.imageNetwork({
    required this.status,
    required this.time,
    required String url,
    String? text,
    this.senderName = '',
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
  })  : content = text,
        attachment = url,
        isInfo = false,
        attachmentType = AttachmentType.imageNetwork;

  /// Constructs a message with a video attachment with a network url.
  const ZdsMessage.videoNetwork({
    required this.status,
    required this.time,
    required String url,
    String? text,
    this.senderName = '',
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
  })  : content = text,
        attachment = url,
        isInfo = false,
        attachmentType = AttachmentType.videoNetwork;

  /// Constructs a message with a video attachment with a local file path.
  const ZdsMessage.videoLocal({
    required this.status,
    required this.time,
    required String filePath,
    String? text,
    this.senderName = '',
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
  })  : content = text,
        attachment = filePath,
        isInfo = false,
        attachmentType = AttachmentType.videoLocal;

  /// Constructs a message with a video attachment with a network url.
  const ZdsMessage.audioNetwork({
    required this.status,
    required this.time,
    required String url,
    String? text,
    this.senderName = '',
    this.isDeleted = false,
    this.reacts = const {},
    this.senderColor,
    this.tags = const [],
    this.isForwarded = false,
    this.replyMessageInfo,
    this.id = '',
  })  : content = text,
        attachment = url,
        isInfo = false,
        attachmentType = AttachmentType.audioNetwork;

  // TODO(thelukewalton): UX-940 Add constructors for messages with audio.

  /// Constructs an info message used to display updates to user. Message not from another user.
  const ZdsMessage.info({
    required this.content,
    this.time,
    this.id = '',
  })  : attachment = null,
        replyMessageInfo = null,
        reacts = const {},
        senderColor = null,
        isDeleted = false,
        senderName = '',
        isForwarded = false,
        isInfo = true,
        tags = const [],
        status = ZdsChatMessageStatus.notSent,
        attachmentType = null;

  /// Constructs a blank message. Should not normally be used.
  ///
  /// Used for [ZdsChatMessage.wrapper].
  const ZdsMessage.blank()
      : attachment = null,
        content = null,
        senderColor = null,
        time = null,
        isDeleted = false,
        reacts = const {},
        senderName = '',
        status = ZdsChatMessageStatus.unknown,
        tags = const [],
        isInfo = false,
        isForwarded = false,
        replyMessageInfo = null,
        id = '',
        attachmentType = null;

  /// Text content of message.
  final String? content;

  /// True if message has been deleted.
  final bool isDeleted;

  /// Map of reactions to number of times received.
  final Map<String, int> reacts;

  /// Name to display for sender.
  final String senderName;

  /// Optional custom color used to display sender name.
  ///
  /// Defaults to using [ZetaColors.textDefault].
  final Color? senderColor;

  /// [ZdsChatMessageStatus] of message.
  final ZdsChatMessageStatus status;

  /// Time message was sent.
  final DateTime? time;

  /// List of tags.
  final List<String> tags;

  /// Attachment. Typically a document, image, video or voice note. //TODO(thelukwalton): UX-941
  final dynamic attachment;

  /// True if message is an information message, not a chat message.
  final bool isInfo;

  /// True if message has been forwarded.
  final bool isForwarded;

  /// Contents of message that is being replied to.
  final ZdsMessage? replyMessageInfo;

  /// Unique ID of message.
  final String id;

  /// Type of file attached to message.
  final AttachmentType? attachmentType;

  /// [ZdsChatMessageType] of message.
  ZdsChatMessageType get type => attachment != null
      ? ZdsChatMessageType.attachment
      : isInfo
          ? ZdsChatMessageType.info
          : ZdsChatMessageType.text;

  /// True if message has any reacts.
  bool get hasReacts => reacts.isNotEmpty && reacts.values.any((element) => element > 0);

  /// Returns formatted Date / Time string based on device preference.
  String timeString(BuildContext context) {
    if (time != null) {
      if (MediaQuery.of(context).alwaysUse24HourFormat) {
        return DateFormat('HH:mm').format(time!);
      } else {
        return DateFormat('hh:mm a').format(time!);
      }
    }
    return '';
  }

  /// Returns true if the attachment can be previewed inline, or if it must be downloaded.
  bool get isPreviewable {
    if (attachmentType == AttachmentType.imageBase64) {
      return (attachment as String).base64 != null;
    }
    if (attachmentType == AttachmentType.imageNetwork) {
      return Uri.tryParse(attachment as String) != null;
    }

    if (attachmentType == AttachmentType.imageLocal) {
      final File file = attachment as File;
      final String? mime = lookupMimeType(file.path);

      return file.existsSync() && mime != null && mime.contains('image');
    }

    return false;
  }
}

/// Extension on [String] for [ZdsChatMessage].
extension ZdsChatString on String {
  /// Gets all URLs from a string.
  List<String> get urls {
    final RegExp exp = RegExp(
      r'(\b(((https?|ftp|file|):\/\/)|www[.])[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])',
      caseSensitive: false,
    );

    final List<String> urls = [];
    replaceAllMapped(exp, (Match match) {
      final urlMatch = match.group(0);

      if (urlMatch != null && isURL(urlMatch)) {
        urls.add(urlMatch);
      }
      return urlMatch ?? '';
    });

    return urls;
  }

  /// Returns base64 string formatted.
  String? get base64 {
    if (isBase64(this)) return this;
    final splitContentOnly = split(',').last;
    if (isBase64(splitContentOnly)) return splitContentOnly;

    return null;
  }

  /// Tries to retrieve extension of base64 file.
  String? get base64Extension {
    final splitContentOnly = split(',').last;
    if (isBase64(splitContentOnly)) {
      return split(';').first.split('/').last;
    }

    return null;
  }
}

/// Extension on [ZdsChatMessageStatus].
extension ZdsMessageStatusExtension on ZdsChatMessageStatus {
  /// Returns localized semantic label for message status.
  String label(BuildContext context) {
    switch (this) {
      case ZdsChatMessageStatus.notSent:
        return ComponentStrings.of(context).get('MSG_NOT_SENT', 'Message not sent');
      case ZdsChatMessageStatus.sent:
        return ComponentStrings.of(context).get('MSG_SENT', 'Message sent');
      case ZdsChatMessageStatus.delivered:
        return ComponentStrings.of(context).get('MSG_DELIVERED', 'Message delivered');
      case ZdsChatMessageStatus.read:
        return ComponentStrings.of(context).get('MSG_READ', 'Message read');
      case ZdsChatMessageStatus.unknown:
        return ComponentStrings.of(context).get('MSG_ERR', 'Message status unknown');
    }
  }
}

/// Type of attachment provided.
enum AttachmentType {
  /// Image string formatted as Base64.
  imageBase64,

  /// Url of image.
  imageNetwork,

  /// File directory where image is saved.
  imageLocal,

  /// Url of video
  videoNetwork,

  /// File directory where video is saved.
  videoLocal,

  /// Url of audio file.
  audioNetwork,

  /// File directory where audio is saved.
  audioLocal,

  /// Url of file.
  ///
  /// In this case, doc refers to any file that is not image, video or audio.
  docNetwork,

  /// File directory where doc is saved.
  ///
  /// In this case, doc refers to any file that is not image, video or audio.
  docLocal
}
