import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A component used to show a notification with read/unread message details.
///
///
/// ```dart
/// ZdsNotificationTile(
///   onTap: () {},
///   title: getNotificationDate(),
///   subtitle: 'PTO Request approved for Mon, Jan 16 - Tue, Jan 17',
///   isUnread: isUnread,
// ),
///  ```

class ZdsNotificationTile extends StatelessWidget {
  /// Constructs a [ZdsNotificationTile].
  const ZdsNotificationTile({
    required this.dateLabel,
    super.key,
    this.content,
    this.onTap,
    this.isUnread = true,
    this.leadingData,
    this.leadingWidth = 12,
    this.shrinkWrap = true,
  }) : assert(dateLabel.length != 0, 'dateLabel must not be empty');

  /// The text that is header of the notification tile.
  ///
  final String dateLabel;

  /// Additional content displayed below the date label.
  ///
  final String? content;

  /// Whether the notification is unread or read.
  ///
  /// Defaults to true and its unread.
  final bool isUnread;

  /// Called when the user taps this list tile.
  final VoidCallback? onTap;

  /// Widget displayed at the beginning of a title and subTitle like icon.
  final Widget? leadingData;

  /// Whether the notification tiles are closely packed together or separated
  ///
  /// Defaults to true
  ///
  /// It will be used in [ZdsListTile].
  final bool shrinkWrap;

  /// Width of leading widget.
  ///
  /// If set to null, leading widget will determine its own width.
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    return ZdsListTile(
      shrinkWrap: shrinkWrap,
      contentPadding: const EdgeInsets.all(8),
      onTap: onTap,
      title: Text(
        dateLabel,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        content!,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      leading: Container(
        margin: const EdgeInsets.only(bottom: 28),
        width: leadingWidth,
        height: 12,
        child: isUnread && leadingData == null ? const CircleAvatar() : leadingData,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('dateLabel', dateLabel))
      ..add(StringProperty('content', content))
      ..add(DiagnosticsProperty<bool>('isUnread', isUnread))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool?>('shrinkWrap', shrinkWrap))
      ..add(DoubleProperty('leadingWidth', leadingWidth));
  }
}
