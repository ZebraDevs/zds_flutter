import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// Theme colors for [ZdsTabBar].
enum ZdsTabBarColor {
  /// * Background color: `ZetaColors.primary`.
  /// * Foreground color: `ZetaColors.onPrimary`.
  /// * Unselected foreground color: `ZetaColors.cool.40`.
  /// * Indicator color: `ZetaColors.primary.20`.
  primary,

  /// * Background color: `ZetaColors.cool.90`.
  /// * Foreground color: `ZetaColors.cool.20`.
  /// * Unselected foreground color: `ZetaColors.cool.40`.
  /// * Indicator color: `ZetaColors.primary`.
  basic,

  /// * Background color: `ZetaColors.surface`.
  /// * Foreground color: `ZetaColors.onSurface`.
  /// * Unselected foreground color: `ZetaColors.cool.70`.
  /// * Indicator color: `ZetaColors.primary`.
  surface,
}

/// Returns a [TabBar] with Zds styling. However, this widget has a number of issues that make it less useful in
/// varying screen sizes and resizable screens. It's recommended to instead use [ZdsResponsiveTabBar].
class ZdsTabBar extends StatelessWidget implements PreferredSizeWidget {
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

  /// Makes a [TabBar] with Zds styling applied. It's recommended to instead use [ZdsResponsiveTabBar].
  const ZdsTabBar({
    required this.tabs,
    super.key,
    this.color = ZdsTabBarColor.primary,
    this.controller,
    this.isScrollable = false,
    this.labelPadding = kTabLabelPadding,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final appBar = context.findAncestorWidgetOfExactType<ZdsAppBar>();

    final customThemeContainer = Theme.of(context).zdsTabBarThemeData(
      context,
      hasIcons: hasIcons(tabs),
    )[appBar != null ? appBar.color : color]!;
    final customTheme = customThemeContainer.customTheme;

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
                    (item) => Builder(
                      builder: (context) => IconTheme(
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
    properties.add(EnumProperty<ZdsTabBarColor>('color', color));
    properties.add(DiagnosticsProperty<TabController?>('controller', controller));
    properties.add(DiagnosticsProperty<bool>('isScrollable', isScrollable));
    properties.add(DiagnosticsProperty<EdgeInsets>('labelPadding', labelPadding));
    properties.add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle));
  }
}
