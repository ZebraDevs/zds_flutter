import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../zds_flutter.dart';

/// Deleted message body for [ZdsChatMessage].
class ZdsChatDeletedText extends StatelessWidget {
  /// Constructs a [ZdsChatDeletedText].
  const ZdsChatDeletedText({super.key, this.textContent});

  /// Optional text content.
  ///
  /// If null, displays 'This message was deleted' ('THIS_MSG_DELETED' from [ComponentStrings]).
  final String? textContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        textContent != null && textContent!.isNotEmpty
            ? textContent!
            : ComponentStrings.of(context).get('MSG_DELETED', 'This message was deleted'),
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontStyle: FontStyle.italic, color: Zeta.of(context).colors.textSubtle),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('textContent', textContent));
  }
}
