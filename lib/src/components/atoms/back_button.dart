import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A back button that will, by default, call [Navigator.maybePop] when pressed.
class ZdsBackButton extends StatelessWidget {
  /// A back button that will, by default, call [Navigator.maybePop] when pressed.
  const ZdsBackButton({super.key, this.onPressed});

  /// The function to be called whenever the user presses this button.
  ///
  /// Calls [Navigator.maybePop] by default.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context), 'Localizations must be initialized');

    return IconButton(
      icon: const Icon(ZdsIcons.back),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          unawaited(Navigator.maybePop(context));
        }
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}
