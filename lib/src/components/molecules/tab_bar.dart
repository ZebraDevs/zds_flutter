import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Theme colors for [ZdsTabBar].
enum ZdsTabBarColor {
  /// Primary background color, onPrimary foreground color.
  primary,

  /// Either dark (Zeta) or ThemeData.background color for background, with respective foreground variants.
  basic,

  /// Surface background color, onSurface foreground color, primary indicator color.
  surface,
}

/// Returns a [TabBar] with Zds styling. However, this widget has a number of issues that make it less useful in
/// varying screen sizes and resizable screens. It's recommended to instead use [ZdsResponsiveTabBar].
class ZdsTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Makes a [TabBar] with Zds styling applied. It's recommended to instead use [ZdsResponsiveTabBar].
  const ZdsTabBar({
    this.tabs = const <ZdsTab>[],
    super.key,
    this.color = ZdsTabBarColor.basic,
    this.controller,
    this.isScrollable = false,
    this.labelPadding = kTabLabelPadding,
    this.labelStyle,
  });

  /// Sets the color scheme for each of the tabs and the tab bar itself.
  ///
  /// Defaults to [ZdsTabBarColor.basic].
  final ZdsTabBarColor color;

  /// Typically a list of two or more [ZdsTab] widgets.
  ///
  /// The length of this list must match the [controller]'s [TabController.length]
  /// and the length of the [TabBarView.children] list.
  final List<ZdsTab> tabs;

  /// Optional [TabController]
  final TabController? controller;

  /// True if the tab list should be scrollable in the horizontal axis.
  ///
  /// In many situations it is preferable to use [ZdsResponsiveTabBar].
  ///
  /// Defaults to false.
  final bool isScrollable;

  /// Padding applied within each tab around the label.
  ///
  /// Defaults to [kTabLabelPadding].
  final EdgeInsets labelPadding;

  /// Text style for the labels of the tabs.
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final ZdsAppBar? appBar = context.findAncestorWidgetOfExactType<ZdsAppBar>();

    final ZdsTabBarStyleContainer customThemeContainer = Theme.of(context).zdsTabBarThemeData(
      context,
      hasIcons: hasIcons(tabs),
    )[appBar != null ? appBar.color : color]!;
    final ZdsTabBarThemeData customTheme = customThemeContainer.customTheme;

    return Container(
      color: (customThemeContainer.customTheme.decoration as BoxDecoration).color,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: customTheme.height,
          decoration: customTheme.decoration,
          child: Theme(
            data: customThemeContainer.theme,
            child: TabBar(
              isScrollable: isScrollable,
              controller: controller,
              labelPadding: labelPadding,
              labelStyle: labelStyle,
              tabs: tabs
                  .map(
                    (ZdsTab item) => Builder(
                      builder: (BuildContext context) => IconTheme(
                        data: IconTheme.of(context).copyWith(
                          size: customTheme.iconSize,
                        ),
                        child: item,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return hasIcons(tabs) ? const Size(0, 56) : const Size(0, 48);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZdsTabBarColor>('color', color))
      ..add(DiagnosticsProperty<TabController?>('controller', controller))
      ..add(DiagnosticsProperty<bool>('isScrollable', isScrollable))
      ..add(DiagnosticsProperty<EdgeInsets>('labelPadding', labelPadding))
      ..add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle));
  }
}
