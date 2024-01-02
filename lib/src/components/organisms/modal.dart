import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A widget that can be passed to [showDialog] to warn the user of a potentially destructive action, like deleting a
/// file. Can be used to obtain confirmation that they want to perform said action.
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (BuildContext localContext) {
///     return ZdsModal(
///       child: Text('Do you want to delete this comment?'),
///       actions: [
///         ZdsButton.muted(
///           child: Text('Cancel'),
///           onTap: () => Navigator.of(localContext).pop(),
///         ),
///         ZdsButton(
///           child: Text('Delete'),
///           onTap: () => deleteComment(),
///         ),
///       ],
///     );
///   },
/// );
/// ```
///
/// See also:
///
///  * [ZdsInputDialog], used to retrieve 1 String value with built-in validation.
class ZdsModal extends StatelessWidget {
  /// Creates the contents of a modal.
  const ZdsModal({
    super.key,
    this.child,
    this.actions = const <Widget>[],
    this.padding = const EdgeInsets.all(24),
    this.usesKeyboard = false,
    this.icon,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.actionsPadding = const EdgeInsets.all(24),
  });

  /// The padding that will surround the [child] widget.
  ///
  /// EdgeInsets.all(24) by default.
  final EdgeInsets padding;

  /// The main widget that will be shown within the modal.
  final Widget? child;

  /// Will be displayed at the bottom of the modal.
  ///
  /// Typically is usually a list of [ZdsButton].
  final List<Widget> actions;

  /// Whether a keyboard will be shown at any point of interaction with this modal, enabling the modal to avoid the
  /// keyboard when it shows.
  ///
  /// Defaults to false.
  final bool usesKeyboard;

  /// An optional icon that will be displayed at the top of the modal. Useful for alert modals.
  final IconData? icon;

  /// The alignment in which the [child] will be put along the horizontal axis.
  ///
  /// Defaults to `CrossAxisAlignment.center`.
  final CrossAxisAlignment crossAxisAlignment;

  /// Padding around actions at the bottom of the modal.
  ///
  /// Defaults to `EdgeInsets.all(24)`.
  final EdgeInsets actionsPadding;

  @override
  Widget build(BuildContext context) {
    final Widget modal = SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: IntrinsicHeight(
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: <Widget>[
                ZdsCard(
                  backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: padding,
                        child: child,
                      ),
                      Align(
                        alignment: Directionality.of(context) == TextDirection.ltr
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        // Scrollable to adapt for small screens and users with big font size settings
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: actionsPadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: actions.divide(const SizedBox(width: 16)).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (icon != null)
                  Positioned(
                    top: -20,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    return usesKeyboard ? _KeyboardAvoider(child: modal) : modal;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding))
      ..add(DiagnosticsProperty<bool>('usesKeyboard', usesKeyboard))
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(EnumProperty<CrossAxisAlignment>('crossAxisAlignment', crossAxisAlignment))
      ..add(DiagnosticsProperty<EdgeInsets>('actionsPadding', actionsPadding));
  }
}

class _KeyboardAvoider extends StatelessWidget {
  const _KeyboardAvoider({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Center(
      child: AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
