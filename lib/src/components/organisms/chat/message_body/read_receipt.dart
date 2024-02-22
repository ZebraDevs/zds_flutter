import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../zds_flutter.dart';
import '../chat_utils.dart';

/// Read Receipt component for [ZdsChatMessage].
class ZdsReadReceipt extends StatelessWidget {
  /// Constructs a [ZdsReadReceipt].
  const ZdsReadReceipt({
    super.key,
    required this.isLocalUser,
    required this.status,
    required this.timeString,
    required this.messageDeleted,
  });

  /// Formatted string of when the message was sent.
  final String timeString;

  /// If the message was sent by the local user.
  final bool isLocalUser;

  /// Status of the message. See [ZdsChatMessageStatus].
  final ZdsChatMessageStatus status;

  /// Whether or not the associated message has been deleted.
  final bool messageDeleted;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final zetaColors = Zeta.of(context).colors;

    return Semantics(
      focusable: true,
      label: timeString + (!messageDeleted ? status.label(context) : ''),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20, top: 2),
        child: Row(
          mainAxisAlignment: isLocalUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              timeString,
              style: themeData.textTheme.bodySmall?.copyWith(color: zetaColors.textSubtle, fontWeight: FontWeight.w500),
            ),
            if (isLocalUser) const SizedBox(width: 6),
            if (isLocalUser && status != ZdsChatMessageStatus.notSent && !messageDeleted)
              Icon(
                (status == ZdsChatMessageStatus.read || status == ZdsChatMessageStatus.delivered)
                    ? Icons.done_all
                    : Icons.done,
                size: 16,
                color: status == ZdsChatMessageStatus.read ? themeData.colorScheme.secondary : zetaColors.iconSubtle,
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
      ..add(DiagnosticsProperty<String>('timeString', timeString))
      ..add(DiagnosticsProperty<bool>('isLocalUser', isLocalUser))
      ..add(EnumProperty<ZdsChatMessageStatus>('status', status))
      ..add(DiagnosticsProperty<bool>('messageDeleted', messageDeleted));
  }
}
