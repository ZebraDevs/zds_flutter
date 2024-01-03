import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../molecules/icon_badge_widget.dart';

/// A widget that shows a badge to display how many unread notifications there are.
///
/// See also:
///
///  * [IconWithBadge], an icon that uses [UnreadBadge].
class UnreadBadge extends StatelessWidget {
  /// Displays the [unread] parameter in a red circle.
  ///
  /// If not null, [semanticsLabel] is read instead of the [unread] amount if given.
  ///
  /// [maximumDigits] represents how many digits will be shown. It must be equal or greater than 1
  /// (if [maximumDigits] is 3, any number over 999 will be shown as 999+).
  ///
  /// [maximumDigits] and [unread] must not be null.
  const UnreadBadge({
    required this.unread,
    super.key,
    this.semanticsLabel,
    this.maximumDigits = 3,
    this.foregroundColor,
    this.backgroundColor,
    this.minWidth = 16,
    this.minHeight = 16,
    this.badgeContainerColor,
  }) : assert(maximumDigits >= 1, 'Maximum digits must be greater than 1');

  /// The number to show in the badge.
  final int unread;

  /// Optional text to replace the default [Semantics] behavior of reading the number in this badge.
  ///
  /// If not null, [Semantics] will ignore [unread], so this parameter can be used for making [Semantics] read "3
  /// unread emails" instead of just "3". If null, [Semantics] will just read [unread].
  final String? semanticsLabel;

  /// How many digits long the unread amount can be. For example, if set to 3, any number over 999 will be shown as
  /// 999+ or +999 depending on the locale used and the text direction.
  ///
  /// Must be equal or greater than 1. Defaults to 3.
  final int maximumDigits;

  /// Foreground color for the text.
  /// Defaults to theme's onError color.
  final Color? foregroundColor;

  /// Background color for the widget
  /// Defaults to theme's error color.
  final Color? backgroundColor;

  /// Min width of the unread bubble.
  /// Defaults to 16.
  final double minWidth;

  /// Min height of the unread bubble.
  /// Defaults to 16.
  final double minHeight;

  /// The color of the surface where this badge is being drawn on. Typically, this will be the surface color. However, in cases
  /// where this widget is used in a context with a different surface color, such as in an AppBar, this value should
  /// be set to the AppBar's background color.
  ///
  /// This color is later used to draw a border around the count bubble.
  final Color? badgeContainerColor;

  @override
  Widget build(BuildContext context) {
    final String maximumNumber = '9' * maximumDigits;
    final ThemeData themeData = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: badgeContainerColor ?? themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(minHeight + 2),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
        decoration: BoxDecoration(
          color: backgroundColor ?? themeData.colorScheme.error,
          borderRadius: BorderRadius.circular(minHeight),
        ),
        child: Center(
          child: Semantics(
            label: semanticsLabel,
            child: ExcludeSemantics(
              excluding: semanticsLabel != null,
              child: Text(
                unread.toString().length <= maximumDigits
                    ? unread.toString()
                    : Directionality.of(context) == TextDirection.ltr
                        ? '$maximumNumber+'
                        : '+$maximumNumber',
                textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.35),
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: foregroundColor ?? (backgroundColor ?? themeData.colorScheme.error).onColor,
                  fontSize: max(themeData.textTheme.bodySmall?.fontSize ?? 0, minHeight * 0.65),
                ),
              ),
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
      ..add(IntProperty('unread', unread))
      ..add(StringProperty('semanticsLabel', semanticsLabel))
      ..add(IntProperty('maximumDigits', maximumDigits))
      ..add(ColorProperty('foregroundColor', foregroundColor))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('minWidth', minWidth))
      ..add(DoubleProperty('minHeight', minHeight))
      ..add(ColorProperty('badgeContainerColor', badgeContainerColor));
  }
}
