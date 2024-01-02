import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A menu for navigation to other parts of the app or to other apps.
///
/// This navigation menu is typically included in the drawer to include links to other section of the app (like
/// settings), or links to other apps.
///
/// See also:
///
///  * [ZdsMenuItem], typically used as the [children] of this widget.
class ZdsNavigationMenu extends StatelessWidget {
  /// Constructs a [ZdsNavigationMenu].
  const ZdsNavigationMenu({
    required this.children,
    super.key,
    this.label,
    this.withDividers = false,
    this.withSpacer = true,
  });

  /// An optional label shown at the start of the menu describing its contents.
  ///
  /// Typically a [Text]
  final Widget? label;

  /// The list of actions in this menu.
  ///
  /// Typically a list of [ZdsMenuItem].
  final List<Widget> children;

  /// Whether to have dividers between the items
  ///
  /// Defaults to false.
  final bool withDividers;

  /// Whether to have a spacer at the end of the menu.
  ///
  /// Defaults to true.
  final bool withSpacer;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (label != null)
            ZdsNavigationMenuLabel(
              child: label!,
            ).paddingInsets(const EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
          Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
                  .divide(
                    withDividers ? const Divider().paddingInsets(kMenuHorizontalPadding) : const SizedBox(height: 6),
                  )
                  .toList(),
            ),
          ),
          if (withSpacer) Container(height: 12, color: Theme.of(context).colorScheme.background),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('withDividers', withDividers))
      ..add(DiagnosticsProperty<bool>('withSpacer', withSpacer));
  }
}

//// Label used above a [ZdsNavigationMenu].
class ZdsNavigationMenuLabel extends StatelessWidget {
  /// Constructs a [ZdsNavigationMenuLabel].
  const ZdsNavigationMenuLabel({required this.child, super.key});

  /// Label to be rendered.
  ///
  /// Typically a [Text].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child.textStyle(
      Theme.of(context).textTheme.titleSmall?.copyWith(color: Zeta.of(context).colors.textSubtle),
    );
  }
}
