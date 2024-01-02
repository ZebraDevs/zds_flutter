import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/theme.dart';
import '../atoms/border_clipper.dart';
import '../organisms/list_tile.dart';

/// This Widget takes in the following parameters:
///
/// [key] : Key to assign to the widget.
///
/// [child] : The Widget that will be wrapped by [ZdsListTileWrapper]. Typically a [ZdsListTile] for the styling to be applied to.
///
/// [top] : A boolean value to indicate whether to add custom styling to the top part of the widget. Default value is `false`.
///
/// [bottom] : A boolean value to indicate whether to add custom styling to the bottom part of the widget. Default value is `false`.
///
/// [dividers] : A boolean value to indicate whether to add divider below the child. Default value is `true`.
///
/// Here is an example of how to use this class:
///
/// ```dart
///   static const tileCount = 6;
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: ListView.separated(
///         itemCount: tileCount,
///         padding: const EdgeInsets.all(14),
///         separatorBuilder: (context, index) => const Divider(),
///         itemBuilder: (context, index) {
///           return ZdsListTileWrapper(
///             top: index == 0,
///             bottom: index == (tileCount - 1),
///             child: ZdsListTile(
///               title: Text('Title $index'),
///               subtitle: Text('Subtitle $index'),
///             ),
///           );
///         },
///       ),
///     );
///   }
/// ```
///
/// Note: You should specify [key] value if you need to reference this particular widget
/// later on, you can leave it otherwise.
///
class ZdsListTileWrapper extends StatelessWidget {
  /// Constructs a [ZdsListTileWrapper].
  const ZdsListTileWrapper({
    super.key,
    required this.child,
    this.top = false,
    this.bottom = false,
    this.dividers = true,
    this.backgroundColor,
  });

  /// The Widget that will be wrapped by `ZdsListTileWrapper`.
  ///
  /// Typically a ZdsListTile for the styling to be applied to.
  final Widget child;

  /// Whether the tile is the first (at the top) of the list.
  ///
  /// Defaults to false.
  final bool top;

  /// Whether the tile is the last (at the bottom) of the list.
  ///
  /// Defaults to false.
  final bool bottom;

  /// Whether the divider should be added at the bottom of the tile.
  ///
  /// Defaults to true.
  final bool dividers;

  /// Background Color of the wrapper
  ///
  /// Useful when child is [ListTile] which does not have any inherent background color
  ///
  /// When not given then defaulted to the [ColorScheme.surface]
  final Color? backgroundColor;

  static const _topClipper = ZdsBorderClipper(top: -4, bottom: 0, left: -4, right: -4);
  static const _bottomClipper = ZdsBorderClipper(top: 0, bottom: -4, left: -4, right: -4);
  static const _middleClipper = ZdsBorderClipper(top: 0, bottom: 0, left: -4, right: -4);

  @override
  Widget build(BuildContext context) {
    // Gets the theme data
    final themeData = Theme.of(context);

    // Gets card theme data
    final cardTheme = themeData.cardTheme;

    // Regular border radius
    BorderRadius borderRadius = BorderRadius.circular(kZdsCardRadius);

    // Check if the card shape is Rounded Rectangle and accordingly set its borderRadius
    if (cardTheme.shape != null && cardTheme.shape is RoundedRectangleBorder) {
      final cardShape = cardTheme.shape as RoundedRectangleBorder?;
      if (cardShape != null && cardShape.borderRadius is BorderRadius) {
        borderRadius = cardShape.borderRadius as BorderRadius;
      }
    }

    // Custom border radius and box shadow
    BorderRadius customBorderRadius;

    // Shadow color
    final shadowColor = cardTheme.shadowColor ?? Colors.black38;
    List<BoxShadow> customBoxShadow;

    // Depending on the top and bottom properties, set customBorderRadius and customBoxShadow
    if (top && bottom) {
      customBorderRadius = borderRadius;
      customBoxShadow = [BoxShadow(blurRadius: 1, color: shadowColor)];
    } else if (top) {
      customBorderRadius = BorderRadius.only(
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
      );
      customBoxShadow = [
        BoxShadow(color: shadowColor, blurRadius: 0.5, offset: const Offset(0, -1)),
        BoxShadow(color: shadowColor, blurRadius: 0.5, offset: const Offset(1, 0)),
        BoxShadow(color: shadowColor, blurRadius: 0.5, offset: const Offset(-1, 0)),
      ];
    } else if (bottom) {
      customBorderRadius = BorderRadius.only(
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );
      customBoxShadow = [
        BoxShadow(color: shadowColor, blurRadius: 0.5, offset: const Offset(0, 1)),
        BoxShadow(color: shadowColor, blurRadius: 0.5, offset: const Offset(1, 0)),
        BoxShadow(color: shadowColor, blurRadius: 0.5, offset: const Offset(-1, 0)),
      ];
    } else {
      customBorderRadius = BorderRadius.zero;
      customBoxShadow = [
        BoxShadow(color: shadowColor, blurRadius: 0.5, offset: const Offset(1, 0)),
        BoxShadow(color: shadowColor, blurRadius: 0.5, offset: const Offset(-1, 0)),
      ];
    }

    Widget widget = Material(
      color: backgroundColor ?? themeData.colorScheme.surface,
      child: child,
    );

    // Returns the customized widget
    widget = Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: customBorderRadius,
        boxShadow: customBoxShadow,
      ),
      child: dividers && !bottom
          ? Column(
              children: [
                widget,
                const Divider(),
              ],
            )
          : widget,
    );

    if (!(top && bottom)) {
      widget = ClipPath(
        clipper: top
            ? _topClipper
            : bottom
                ? _bottomClipper
                : _middleClipper,
        child: widget,
      );
    }

    return widget;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('top', top))
      ..add(DiagnosticsProperty<bool>('bottom', bottom))
      ..add(DiagnosticsProperty<bool>('addDivider', dividers))
      ..add(ColorProperty('backgroundColor', backgroundColor));
  }
}
