import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides functionality so that by tapping on descendant widgets (except textfields) the keyboard is dismissed.
///
/// This functionality replicates that of Android apps, where the keyboard can be dismissed by either tapping outside
/// of the keyboard or sometimes on another interactable element, like a button.
///
/// However, on iOS this behaviour is not common. Typically, the keyboard is dismissed when:
///  * The page is scrolled up/down (like in Android, typically)
///  * The user interacts with another interactable element (e.g., a toggle button)
///  * The user slides down on the text input on a messaging app (e.g., iMessage)
///
/// Tapping on non-interactable elements does not bring the keyboard down on iOS. As such, when implementing this
/// functionality, you must take care that the methods used to dismiss the keyboard are familiar to each platforms'
/// users if possible.
class KeyboardDismiss extends StatelessWidget {
  /// Provides functionality so that by tapping on descendant widgets (except textfields) the keyboard is dismissed.
  const KeyboardDismiss({
    required this.child,
    super.key,
    this.onDismissed,
    this.shouldDismiss = true,
  });

  /// The widget that will have this functionality implemented.
  final Widget child;

  /// A function called whenever the keyboard is dismissed.
  final VoidCallback? onDismissed;

  /// Whether the keyboard should be dismissed.
  ///
  /// Defaults to true.
  final bool shouldDismiss;

  @override
  Widget build(BuildContext context) {
    void dismiss() {
      _maybeDismissKeyboard(context);
      onDismissed?.call();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: shouldDismiss ? dismiss : null,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onDismissed', onDismissed))
      ..add(DiagnosticsProperty<bool>('shouldDismiss', shouldDismiss));
  }
}

void _maybeDismissKeyboard(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.focusedChild!.unfocus();
  }
}
