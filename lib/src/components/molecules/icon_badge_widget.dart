import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import '../../../../zds_flutter.dart';

/// Shows an icon with an unread badge.
///
/// Typically used as a way of indicating how many unread messages/notifications an app section has.
///
/// See also:
///
///  * [UnreadBadge], used to show the unread badge in this
///  * [ZdsNavItem], where this widget can be used as the icon.
class IconWithBadge extends StatelessWidget {
  /// Displays an icon with an optional unread badge if the [unread] parameter is given. The optional [semanticsLabel]
  /// parameter is used by the unreadBadge child.
  ///
  /// No badge will show if [unread] is 0.
  ///
  /// All parameters except [semanticsLabel] must not be null.
  const IconWithBadge(
    this.icon, {
    super.key,
    this.color,
    this.fill,
    this.grade,
    this.maximumDigits = 3,
    this.opticalSize,
    this.semanticLabel,
    this.semanticsLabel,
    this.shadows,
    this.size = 24,
    this.textDirection,
    this.unread = 0,
    this.weight,
    this.iconContainerColor,
  }) : assert(maximumDigits >= 1, 'maximumDigits must be greater than or equal to 1.');

  /// The number to show in the badge. If it's equal to 0, only the icon will be shown and no badge will show.
  ///
  /// Defaults to 0.
  final int unread;

  /// The icon to display. The available icons are described in [Icons].
  ///
  /// The icon can be null, in which case the widget will render as an empty
  /// space of the specified [size].
  final IconData? icon;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.size].
  ///
  /// If this [Icon] is being placed inside an [IconButton], then use
  /// [IconButton.iconSize] instead, so that the [IconButton] can make the splash
  /// area the appropriate size as well. The [IconButton] uses an [IconTheme] to
  /// pass down the size to the [Icon].
  /// Defaults to 24.
  final double size;

  /// The fill for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `FILL` `FontVariation`
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be between 0.0 (unfilled) and 1.0 (filled),
  /// inclusive.
  ///
  /// Can be used to convey a state transition for animation or interaction.
  ///
  /// Defaults to nearest [IconTheme]'s [IconThemeData.fill].
  ///
  /// See also:
  ///  * [weight], for controlling stroke weight.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * [opticalSize], for controlling optical size.
  final double? fill;

  /// The stroke weight for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `weight` `FontVariation`
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be greater than 0.
  ///
  /// Defaults to nearest [IconTheme]'s [IconThemeData.weight].
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * [opticalSize], for controlling optical size.
  ///  * https://fonts.google.com/knowledge/glossary/weight_axis.
  final double? weight;

  /// The grade (granular stroke weight) for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `GRAD` `FontVariation`
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Can be negative.
  ///
  /// Grade and [weight] both affect a symbol's stroke weight (thickness), but
  /// grade has a smaller impact on the size of the symbol.
  ///
  /// Grade is also available in some text fonts. One can match grade levels
  /// between text and symbols for a harmonious visual effect. For example, if
  /// the text font has a -25 grade value, the symbols can match it with a
  /// suitable value, say -25.
  ///
  /// Defaults to nearest [IconTheme]'s [IconThemeData.grade].
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [weight], for controlling stroke weight in a less granular way.
  ///  * [opticalSize], for controlling optical size.
  ///  * https://fonts.google.com/knowledge/glossary/grade_axis.
  final double? grade;

  /// The optical size for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `optical size` `FontVariation`
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be greater than 0.
  ///
  /// For an icon to look the same at different sizes, the stroke weight
  /// (thickness) must change as the icon size scales. Optical size offers a way
  /// to automatically adjust the stroke weight as icon size changes.
  ///
  /// Defaults to nearest [IconTheme]'s [IconThemeData.opticalSize].
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [weight], for controlling stroke weight.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * https://fonts.google.com/knowledge/glossary/optical_size_axis.
  final double? opticalSize;

  /// The color to use when drawing the icon.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.color].
  ///
  /// The color (whether specified explicitly here or obtained from the
  /// [IconTheme]) will be further adjusted by the nearest [IconTheme]'s
  /// [IconThemeData.opacity].
  ///
  /// {@tool snippet}
  /// Typically, a Material Design color will be used, as follows:
  ///
  /// ```dart
  /// Icon(
  ///   Icons.widgets,
  ///   color: Colors.blue.shade400,
  /// )
  /// ```
  /// {@end-tool}
  final Color? color;

  /// A list of [Shadow]s that will be painted underneath the icon.
  ///
  /// Multiple shadows are supported to replicate lighting from multiple light
  /// sources.
  ///
  /// Shadows must be in the same order for [Icon] to be considered as
  /// equivalent as order produces differing transparency.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.shadows].
  final List<Shadow>? shadows;

  /// Semantic label for the icon.
  ///
  /// Announced in accessibility modes (e.g TalkBack/VoiceOver).
  /// This label does not show in the UI.
  ///
  ///  * [SemanticsProperties.label], which is set to [semanticLabel] in the
  ///    underlying	 [Semantics] widget.
  final String? semanticLabel;

  /// The text direction to use for rendering the icon.
  ///
  /// If this is null, the ambient [Directionality] is used instead.
  ///
  /// Some icons follow the reading direction. For example, "back" buttons point
  /// left in left-to-right environments and right in right-to-left
  /// environments. Such icons have their [IconData.matchTextDirection] field
  /// set to true, and the [Icon] widget uses the [textDirection] to determine
  /// the orientation in which to draw the icon.
  ///
  /// This property has no effect if the [icon]'s [IconData.matchTextDirection]
  /// field is false, but for consistency a text direction value must always be
  /// specified, either directly using this property or using [Directionality].
  final TextDirection? textDirection;

  /// Optional text to replace the default [Semantics] behavior of reading the number in this badge.
  /// Can be used for making [Semantics] read "3 unread emails" instead of just "3"
  ///
  /// See [UnreadBadge.semanticsLabel] for more details.
  final String? semanticsLabel;

  /// How many digits long the unread amount can be. For example, if set to 3, any number over 999 will be shown as
  /// 999+ or +999 depending on the locale used and the text direction.
  ///
  /// Must be equal or greater than 1. Defaults to 3.
  final int maximumDigits;

  /// The color of the surface where this icon is being drawn on. Typically, this will be the surface color. However, in cases
  /// where this widget is used in a context with a different surface color, such as in an AppBar, this value should
  /// be set to the AppBar's background color.
  ///
  /// This color is later used to draw a border around the [UnreadBadge].
  final Color? iconContainerColor;

  @override
  Widget build(BuildContext context) {
    final double badgeSize = size * 0.6;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          Icon(
            icon,
            size: size,
            fill: fill,
            weight: weight,
            grade: grade,
            opticalSize: opticalSize,
            color: color,
            shadows: shadows,
            semanticLabel: semanticLabel,
            textDirection: textDirection,
          ),
          if (unread > 0)
            Positioned(
              top: -badgeSize * 0.4,
              left: badgeSize * 0.75,
              child: ExcludeSemantics(
                child: UnreadBadge(
                  unread: unread,
                  minWidth: badgeSize,
                  minHeight: badgeSize,
                  badgeContainerColor: iconContainerColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('unread', unread))
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(DoubleProperty('size', size))
      ..add(DoubleProperty('fill', fill))
      ..add(DoubleProperty('weight', weight))
      ..add(DoubleProperty('grade', grade))
      ..add(DoubleProperty('opticalSize', opticalSize))
      ..add(ColorProperty('color', color))
      ..add(IterableProperty<Shadow>('shadows', shadows))
      ..add(StringProperty('semanticLabel', semanticLabel))
      ..add(EnumProperty<TextDirection?>('textDirection', textDirection))
      ..add(StringProperty('semanticsLabel', semanticsLabel))
      ..add(IntProperty('maximumDigits', maximumDigits))
      ..add(ColorProperty('iconContainerColor', iconContainerColor));
  }
}
