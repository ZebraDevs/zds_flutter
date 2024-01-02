import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A widget that creates a Large icon button with text.
///
/// ```dart
/// ZdsIconTextButton(
///   onTap: () => {onButtonTapped(context)},
///   icon: ZdsIcons.timecard,
///   label: 'Timecard',
///   iconColor: ZdsColors.white,
///   labelColor: ZdsColors.white,
///   backgroundColor: Theme.of(context).primaryColor,
/// ),
///
/// ```
class ZdsIconTextButton extends StatelessWidget with Diagnosticable {
  /// Constructs a [ZdsIconTextButton].
  const ZdsIconTextButton({
    required this.label,
    super.key,
    this.icon,
    this.iconColor,
    this.labelColor,
    this.onTap,
    this.backgroundColor,
  }) : assert(label.length != 0, 'label must not be empty');

  /// The icon to be shown above the label
  final IconData? icon;

  /// The background color of the [icon].
  final Color? iconColor;

  /// Function called whenever the user taps anywhere on the button
  final VoidCallback? onTap;

  /// The label that will be shown at the below of the icon.
  ///
  /// If not null, it can't be empty.
  final String label;

  /// The text color is used for [label].
  final Color? labelColor;

  /// The background color for this button.
  ///
  /// Defaults to [ColorScheme.primary]
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final zetaColors = Zeta.of(context).colors;

    final BorderRadiusGeometry? borderRadius = (themeData.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius;

    return Container(
      height: 112,
      width: 112,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor ?? zetaColors.primary,
        boxShadow: <BoxShadow>[
          BoxShadow(blurRadius: 4, color: zetaColors.shadow.withOpacity(0.5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Semantics(
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 56,
                  color: iconColor ?? (backgroundColor ?? zetaColors.primary).onColor,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: themeData.textTheme.titleSmall?.copyWith(
                    color: labelColor ?? (backgroundColor ?? zetaColors.primary).onColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(ColorProperty('iconColor', iconColor))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(StringProperty('label', label))
      ..add(ColorProperty('labelColor', labelColor))
      ..add(ColorProperty('backgroundColor', backgroundColor));
  }
}
