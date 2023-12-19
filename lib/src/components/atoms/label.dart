import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A label typically used to showcase status information.
class ZdsLabel extends StatelessWidget {
  /// Creates a label.
  const ZdsLabel({super.key, this.icon, this.child, this.size = 16, this.padding = const EdgeInsets.only(right: 16)})
      : assert(size != null ? size >= 0 : size == null, 'Size must be greater than or equal to 0');

  /// The icon to be shown at the start of this component.
  final IconData? icon;

  /// The icon's size.
  ///
  /// Must be equal or greater than 0. Defaults to 16.
  final double? size;

  /// This label's main content
  ///
  /// Typically a [Text].
  final Widget? child;

  /// Empty space to surround this widget.
  ///
  /// Defaults to EdgeInsets.only(right: 16).
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;

    return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(
              icon,
              size: size,
              color: zetaColors.secondary.icon,
            ),
            const SizedBox(width: 4),
          ],
          if (child != null)
            DefaultTextStyle(
              style: safeTextStyle(Theme.of(context).textTheme.titleSmall).copyWith(
                color: zetaColors.textSubtle,
              ),
              child: child!,
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(DoubleProperty('size', size))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }
}
