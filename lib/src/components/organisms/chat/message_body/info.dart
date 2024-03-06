import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../zds_flutter.dart';

/// Info message body for [ZdsChatMessage].
class ZdsChatInfoMessage extends StatelessWidget {
  /// Constructs an [ZdsChatInfoMessage].
  const ZdsChatInfoMessage({super.key, required this.content});

  /// Text content displayed in the center of the chat.
  final String content;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      focusable: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            content,
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('content', content));
  }
}
