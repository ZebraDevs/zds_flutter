import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A container typically used with [Scaffold.bottomNavigationBar], in [showZdsBottomSheet].bottomBuilder, or as the
/// last child of a [Column] that contains an [Expanded] to ensure [ZdsBottomBar] stays at the bottom.
///
/// Typically used with a [Scaffold]:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: ZdsBottomBar(
///     child: bottomBarContents,
///   ),
/// )
/// ```
///
/// The following example shows how it can be used in a [ZdsBottomSheet] as a bottom action bar:
/// ```dart
/// showZdsBottomSheet(
///   bottomBuilder: (context) => ZdsBottomBar(
///     child: Row(
///       children: [Spacer(), ZdsButton(), ZdsButton()]
///     ),
///   ),
/// );
/// ```
///
/// Alternatively, it may be used as a [Column]'s last child to support a wider variety of actions. If this is the case,
/// ensure that the ZdsBottomBar covers the entire width of the screen, and that it is not used anywhere but in the
/// bottom of the screen.
class ZdsBottomBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a bottom bar that can be used as a bottom application bar, or as a bottom action bar
  ///
  /// If [color], [shadows], and [contentPadding] are null, their [ZdsBottomBarTheme] values will be used instead.
  const ZdsBottomBar({
    super.key,
    this.child,
    this.color,
    this.shadows,
    this.minHeight = kBottomBarHeight,
    this.contentPadding,
  });

  /// The widget that will be below this widget in the widget tree, typically a [Row].
  final Widget? child;

  /// The background color of this bottom bar. Defaults to the [ZdsBottomBarTheme] value.
  final Color? color;

  /// The shadows behind bottom bar. Defaults to the [ZdsBottomBarTheme] value.
  final List<BoxShadow>? shadows;

  /// The height that this bottom bar will be. Defaults to [kBottomBarHeight].
  final double minHeight;

  /// Empty space to inscribe inside this widget. The [child], if any, is placed inside this padding.
  /// Defaults to the [ZdsBottomBarTheme] value.
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    final ZdsBottomBarThemeData customTheme = ZdsBottomBarTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? customTheme.backgroundColor,
        boxShadow: shadows ?? customTheme.shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          top: false,
          child: Container(
            height: minHeight,
            padding: contentPadding ?? customTheme.contentPadding,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(0, minHeight);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(IterableProperty<BoxShadow>('shadows', shadows))
      ..add(DoubleProperty('minHeight', minHeight))
      ..add(DiagnosticsProperty<EdgeInsets?>('contentPadding', contentPadding));
  }
}
