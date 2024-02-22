import 'package:flutter/material.dart';

import '../../../../../zds_flutter.dart';

/// Forwarded widget for [ZdsChatMessage].
class ZdsChatForwarded extends StatelessWidget {
  /// Constructs a [ZdsChatForwarded].
  const ZdsChatForwarded({super.key});

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ZdsIcons.email_forward,
            color: zetaColors.iconSubtle,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            ComponentStrings.of(context).get('FORWARDED', 'Forwarded'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: zetaColors.textSubtle),
          ),
        ],
      ),
    );
  }
}
