import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A widget used to create header in a [ZdsCard].
///
/// This is typically used to create a title. The [leading], [child], and [trailing] widget are displayed in a [Row] in
/// that order. [child] can't be null.
///
/// See also:
///
///  * [ZdsCard] where this widget is typically used.
///  * [ZdsCardWithActions], a [ZdsCard] variant with a bottom status/information bar.
class ZdsCardHeader extends StatelessWidget {
  /// Creates a card header.
  ///
  /// [child] can't be null.
  const ZdsCardHeader({
    required this.child,
    super.key,
    this.leading,
    this.trailing,
  });

  /// An optional widget that will be placed before [child].
  ///
  /// Typically an [Icon].
  final Widget? leading;

  /// An optional widget that will be placed after [child].
  ///
  /// Typically an [IconButton] used to create a [ZdsPopupMenu] to display more options.
  final Widget? trailing;

  /// The main widget of this header. Can't be null.
  ///
  /// Typically a [Text]. If [leading] and [trailing] are not null, this widget will be set between them.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
          child: Row(
            children: <Widget>[
              ...<Widget>[
                if (leading != null) leading!,
                child.textStyle(Theme.of(context).textTheme.headlineMedium),
              ].divide(const SizedBox(width: 8)),
              const Spacer(),
            ],
          ),
        ),
        if (trailing != null)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 5, top: 5),
              child: trailing,
            ),
          ),
      ],
    );
  }
}
