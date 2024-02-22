import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../zds_flutter.dart';

/// Reply message body for [ZdsChatMessage].
class ZdsChatReplyMessageBody extends StatelessWidget {
  /// Constructs a [ZdsChatReplyMessageBody].
  const ZdsChatReplyMessageBody({super.key, required this.message, this.onTap});

  /// Message being replied to.
  final ZdsMessage message;

  /// Callback when reply is tapped.
  final ValueChanged<ZdsMessage>? onTap;

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;

    return InkWell(
      onTap: onTap != null ? () => onTap?.call(message) : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ColoredBox(
            color: zetaColors.warm.shade40,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  child: Container(color: zetaColors.iconSubtle, width: 4),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message.senderName, style: Theme.of(context).textTheme.headlineSmall),
                      Text(message.content ?? '', maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ZdsMessage>('message', message))
      ..add(ObjectFlagProperty<ValueChanged<ZdsMessage>>.has('onTap', onTap));
  }
}
