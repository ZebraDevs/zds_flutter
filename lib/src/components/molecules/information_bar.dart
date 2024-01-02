import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/tools/modifiers.dart';

/// Sets a [ZdsInformationBar]'s icon and background colors.
enum ZdsInformationBarTheme {
  /// Default theme, used for non-status information, like timestamps, quantity information...
  neutral,

  /// Theme used for positive status, like completed, approved, achieved...
  positive,

  /// Theme used for when the status is not final yet, like pending, in progress, scheduled...
  inProgress,

  /// Theme used for negative status, like declined, removed, failed...
  negative
}

/// A bar used to display status information.
///
/// Typically used at the top of the page, below the appbar, to display status information.
class ZdsInformationBar extends StatelessWidget {
  /// Creates a bar used to display status information.
  const ZdsInformationBar({
    super.key,
    this.color = ZdsInformationBarTheme.neutral,
    this.icon,
    this.label,
    this.customBackground,
    this.customForeground,
    this.zetaColorSwatch,
  });

  /// The color theme used for the bar's background and the [icon]'s color.
  ///
  /// Defaults to [ZdsInformationBarTheme.neutral].
  ///
  /// Will be deprecated and replaced with ZetaColorSwatch in future release.
  final ZdsInformationBarTheme color;

  /// The icon shown before the [label].
  ///
  /// The color used will be determined by [color].
  final IconData? icon;

  /// The label shown after the [icon].
  final String? label;

  /// Custom foreground color.
  ///
  /// Overrides [color].
  final Color? customForeground;

  /// Custom background color.
  ///
  /// Overrides [color].
  final Color? customBackground;

  /// Color for the information bar.
  ///
  /// * Background: `color.surface`.
  /// * Icon: `color.icon`.
  /// * Text: default text color.
  final ZetaColorSwatch? zetaColorSwatch;

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);
    final Color backgroundColor = customBackground ?? zetaColorSwatch?.shade20 ?? _getBarColor(color, zeta.colors);
    final Color foregroundColor = customForeground ?? zetaColorSwatch ?? _getIconColor(color, zeta.colors);
    return Container(
      height: 42,
      width: double.maxFinite,
      color: backgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: foregroundColor,
                size: 24,
              ).paddingOnly(right: 8),
            if (label != null)
              Flexible(
                child: Text(
                  label!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
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
      ..add(EnumProperty<ZdsInformationBarTheme>('color', color))
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(ColorProperty('customForeground', customForeground))
      ..add(ColorProperty('customBackground', customBackground))
      ..add(ColorProperty('zetaColorSwatch', zetaColorSwatch));
  }
}

Color _getBarColor(ZdsInformationBarTheme color, ZetaColors colors) {
  switch (color) {
    case ZdsInformationBarTheme.neutral:
      return colors.cool.surface;
    case ZdsInformationBarTheme.positive:
      return colors.green.surface;
    case ZdsInformationBarTheme.inProgress:
      return colors.secondary.surface;
    case ZdsInformationBarTheme.negative:
      return colors.negative.surface;
  }
}

Color _getIconColor(ZdsInformationBarTheme color, ZetaColors colors) {
  switch (color) {
    case ZdsInformationBarTheme.neutral:
      return colors.cool.icon;
    case ZdsInformationBarTheme.positive:
      return colors.green.icon;
    case ZdsInformationBarTheme.inProgress:
      return colors.secondary.icon;
    case ZdsInformationBarTheme.negative:
      return colors.negative.icon;
  }
}
