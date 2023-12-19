import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../../zds_flutter.dart';

/// A bar used to display status information.
///
/// Typically used at the top of the page, below the appbar, to display status information.
class ZdsInformationBar extends StatelessWidget {
  /// Creates a bar used to display status information.
  const ZdsInformationBar({
    super.key,
    this.icon,
    this.label,
    this.customBackground,
    this.customForeground,
    this.zetaColorSwatch,
  });

  /// The icon shown before the [label].
  ///
  /// The color used will be determined by [zetaColorSwatch].
  final IconData? icon;

  /// The label shown after the [icon].
  final String? label;

  /// Custom foreground color.
  ///
  /// Overrides [zetaColorSwatch].
  ///
  /// Will be deprecated and replaced with ZetaColorSwatch in future release.
  final Color? customForeground;

  /// Custom background color.
  ///
  /// Overrides [zetaColorSwatch].
  ///
  /// Will be deprecated and replaced with ZetaColorSwatch in future release.
  final Color? customBackground;

  /// Color for the information bar.
  ///
  /// * Background: `color.surface`.
  /// * Icon: `color.icon`.
  /// * Text: default text color.
  final ZetaColorSwatch? zetaColorSwatch;

  @override
  Widget build(BuildContext context) {
    final ZetaColorSwatch zetaColor = zetaColorSwatch ?? ZetaColors.of(context).primary;

    final Color bg = customBackground ?? zetaColor.shade20;
    return Container(
      height: 42,
      width: double.maxFinite,
      color: bg,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null)
              Icon(
                icon,
                color: customForeground ?? zetaColor.icon,
                size: 24,
              ).paddingOnly(right: 8),
            if (label != null)
              Flexible(
                child: Text(
                  label!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ZetaColors.computeForeground(input: bg),
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(ColorProperty('customForeground', customForeground))
      ..add(ColorProperty('customBackground', customBackground))
      ..add(ColorProperty('zetaColorSwatch', zetaColorSwatch));
  }
}
