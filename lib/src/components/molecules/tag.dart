import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Tag colors
///
/// If `filled`, foreground will always be computed based on background will be the selected color
///
/// Otherwise, the background will the same color, but with 10% opacity.
enum ZdsTagColor {
  /// [ColorScheme.error].
  error,

  /// [ZetaColors.orange].
  alert,

  /// Primary color.
  primary,

  /// Secondary color.
  secondary,

  /// [ZetaColors.green].
  success,

  /// [ZetaColors.warm]
  basic,
}

/// A tag used to show status information or selected options.
///
/// The height of the tag will change depending on the parameters selected. The default height is 24 dp. If [rectangular]
/// is true the height is also 24 dp. If [rounded] is true, the height will be 20 dp. If [onClose] is not null, the
/// height will be 32 dp. The height can be unbounded if [unrestrictedSize] is set to true, but the minimum height will
/// always be of 20 dp at least.
///
/// There are three main styles:
///
///  * Setting [rounded] as true, typically with [prefix], typically used to indicate priority levels.
///  * Setting [rectangular] as true, typically with [prefix], typically used to indicate status, e.g pending, approved and declined.
///  * Setting [rounded] and [rectangular] as false, typically used to indicate status and to allow actions on the tag with [onClose].
class ZdsTag extends StatelessWidget {
  /// Tag item that can have a close/remove button.
  ///
  /// When [unrestrictedSize] is true, the tag will size itself to its child's size. This is useful for bigger fonts
  /// or non-text children like images and such.
  const ZdsTag({
    super.key,
    this.rounded = false,
    this.rectangular = false,
    this.filled = false,
    this.prefix,
    this.color = ZdsTagColor.basic,
    this.customColor,
    this.child,
    this.onClose,
    this.unrestrictedSize = false,
    this.customBackgroundColor,
  })  : assert(
          prefix != null && (rounded || rectangular) || prefix == null,
          'If prefix is not null, rounded must be true',
        ),
        assert(filled && prefix == null || !filled, 'If filled is true, prefix must be null');

  /// Whether to have completely rounded ends (pill shape) or to have a rectangle shape
  ///
  /// If [prefix] is not null, this must be true. Defaults to false
  final bool rounded;

  /// Whether to have a more rectangular shape, with only 2dp border radius
  ///
  /// If [prefix] is not null, this must be true. Defaults to false
  final bool rectangular;

  /// Whether the [color] or [customColor] will act as the background color (with the foreground color being
  /// be computed based on effective background), or as the foreground color (with the background color being the color set to 10% opacity).
  ///
  /// If true, [prefix] must be null. Defaults to false.
  final bool filled;

  /// A prefix shown before the child.
  ///
  /// If this is not null, [rounded] or [rectangular] must be true. If [filled] is true, this must be null.
  final Widget? prefix;

  /// The tag's contents.
  ///
  /// Usually a [Text].
  final Widget? child;

  /// This tag's background color.
  ///
  /// If [customColor] is not null, this parameter will be ignored. Defaults to [ZdsTagColor.basic].
  final ZdsTagColor color;

  /// This tag's foreground color. This will be used as a foreground color or if [filled] as background color.
  ///
  /// If no [customBackgroundColor] is provided, this color will be used as background color with 10% opacity.
  ///
  /// Overrides [color].
  final Color? customColor;

  /// This tag's background color
  ///
  /// Unused if [filled].
  ///
  /// Overrides [color].
  final Color? customBackgroundColor;

  /// A function called whenever the user taps on the closing button of this tag.
  ///
  /// If not null, a closing button will be added added at the end of the tag.
  final VoidCallback? onClose;

  /// Whether the tag's height sizes itself to the child's size. This is useful for bigger fonts or non-text children
  /// like images and such. If false, the tag will have a set height.
  ///
  /// Defaults to false.
  final bool unrestrictedSize;

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;

    Color fgColor = customColor ?? _resolveFgColor(zetaColors, color);
    Color bgColor;

    if (filled) {
      bgColor = fgColor;
      fgColor = fgColor.onColor;
    } else {
      bgColor = customBackgroundColor ?? _resolveBgColor(zetaColors, color);
    }

    final double height = onClose == null
        ? rounded
            ? 20
            : 24
        : 32;

    final EdgeInsets padding =
        onClose == null ? const EdgeInsets.symmetric(horizontal: 8) : const EdgeInsets.only(left: 14);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MergeSemantics(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              constraints: BoxConstraints(minHeight: height, maxHeight: unrestrictedSize ? double.infinity : height),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(
                  rectangular
                      ? rectangularBorderRadius
                      : rounded
                          ? height
                          : kDefaultBorderRadius,
                ),
              ),
              child: Row(
                children: <Widget>[
                  if (prefix != null)
                    ZdsIndex(
                      useBoxDecoration: !rectangular,
                      color: fgColor,
                      child: prefix,
                    ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: fgColor),
                    child: child ?? const SizedBox(),
                  ).paddingInsets(padding),
                  if (onClose != null)
                    Semantics(
                      button: true,
                      onTapHint: ComponentStrings.of(context).get('REMOVE', 'Remove'),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
                        child: InkResponse(
                          highlightColor: bgColor,
                          splashColor: bgColor,
                          radius: height / 1.5,
                          onTap: onClose,
                          child: Icon(
                            ZdsIcons.close,
                            color: fgColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _resolveFgColor(ZetaColors zetaColors, ZdsTagColor tagColor) {
    switch (tagColor) {
      case ZdsTagColor.error:
        return zetaColors.negative;
      case ZdsTagColor.alert:
        return zetaColors.warning;
      case ZdsTagColor.primary:
        return zetaColors.primary;
      case ZdsTagColor.secondary:
        return zetaColors.secondary;
      case ZdsTagColor.success:
        return zetaColors.positive;
      case ZdsTagColor.basic:
        return zetaColors.warm.shade80;
    }
  }

  Color _resolveBgColor(ZetaColors zetaColors, ZdsTagColor tagColor) {
    switch (tagColor) {
      case ZdsTagColor.error:
        return zetaColors.error.surface;
      case ZdsTagColor.alert:
        return zetaColors.orange.surface;
      case ZdsTagColor.primary:
        return zetaColors.primary.surface;
      case ZdsTagColor.secondary:
        return zetaColors.secondary.surface;
      case ZdsTagColor.success:
        return zetaColors.green.surface;
      case ZdsTagColor.basic:
        return zetaColors.warm.shade30;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('rectangular', rectangular))
      ..add(DiagnosticsProperty<bool>('filled', filled))
      ..add(EnumProperty<ZdsTagColor>('color', color))
      ..add(ColorProperty('customColor', customColor))
      ..add(ColorProperty('customBackgroundColor', customBackgroundColor))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onClose', onClose))
      ..add(DiagnosticsProperty<bool>('unrestrictedSize', unrestrictedSize));
  }
}
