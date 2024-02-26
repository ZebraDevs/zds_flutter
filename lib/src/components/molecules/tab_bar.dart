import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/theme/theme.dart';
import '../../utils/tools.dart';
import '../atoms/tab.dart';
import 'responsive_tab_bar.dart';

/// Theme colors for [ZdsTabBar].
enum ZdsTabBarColor {
  /// Primary background color, onPrimary foreground color.
  primary,

  /// Either dark (Zeta) or ThemeData.background color for background, with respective foreground variants.
  basic,

  /// Surface background color, onSurface foreground color, primary indicator color.
  surface,

  /// Color will be adaptive to the AppBar theme. Typically used when [ZdsTabBar] or [ZdsResponsiveTabBar] is used
  /// as toolbar or bottom widget for any [AppBar]
  appBar,
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
    this.topSafeArea = true,
    this.bottomSafeArea = false,
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

  /// Determine's whether component observes safe area at top of the screen.
  ///
  /// Defaults to true.
  ///
  /// See also:
  /// * [SafeArea].
  final bool topSafeArea;

  /// Determine's whether component observes safe area at bottom of the screen.
  ///
  /// Defaults to false.
  ///
  /// See also:
  /// * [SafeArea].
  final bool bottomSafeArea;

  @override
  Widget build(BuildContext context) {
    final customThemeContainer = ZdsTabBar.buildTheme(context, color: color, hasIcons: hasIcons(tabs));
    final ZdsTabBarThemeData customTheme = customThemeContainer.customTheme;

    return DecoratedBox(
      decoration: customTheme.decoration,
      child: SafeArea(
        top: topSafeArea,
        bottom: bottomSafeArea,
        child: Theme(
          data: customThemeContainer.theme,
          child: SizedBox(
            height: customTheme.height,
            child: IconTheme(
              data: IconTheme.of(context).copyWith(size: customTheme.iconSize),
              child: TabBar(
                isScrollable: isScrollable,
                indicatorWeight: 1,
                controller: controller,
                labelPadding: labelPadding,
                labelStyle: labelStyle,
                tabs: tabs,
              ),
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
      ..add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle))
      ..add(DiagnosticsProperty<bool>('topSafeArea', topSafeArea))
      ..add(DiagnosticsProperty<bool>('bottomSafeArea', bottomSafeArea));
  }

  /// Generates theme for [ZdsTabBar].
  static ZdsTabBarStyleContainer buildTheme(
    BuildContext context, {
    required bool hasIcons,
    required ZdsTabBarColor color,
    Color? indicatorColor,
  }) {
    final zetaColors = Zeta.of(context).colors;
    switch (color) {
      case ZdsTabBarColor.primary:
        return _tabBarStyle(
          context,
          hasIcons,
          background: zetaColors.primary,
          indicator: zetaColors.primary.onColor,
          selectedText: zetaColors.primary.onColor,
          unselectedText: zetaColors.primary.onColor.withOpacity(0.7),
        );
      case ZdsTabBarColor.basic:
        return _tabBarStyle(
          context,
          hasIcons,
          background: zetaColors.surfaceTertiary,
          indicator: zetaColors.primary,
          selectedText: zetaColors.textDefault,
          unselectedText: zetaColors.textSubtle,
        );
      case ZdsTabBarColor.surface:
        return _tabBarStyle(
          context,
          hasIcons,
          background: zetaColors.surfacePrimary,
          indicator: zetaColors.primary,
          selectedText: zetaColors.textDefault,
          unselectedText: zetaColors.textSubtle,
        );
      case ZdsTabBarColor.appBar:
        final appBarTheme = Theme.of(context).appBarTheme;
        return _tabBarStyle(
          context,
          hasIcons,
          background: appBarTheme.backgroundColor ?? zetaColors.surfacePrimary,
          indicator: appBarTheme.foregroundColor ?? zetaColors.primary,
          selectedText: appBarTheme.foregroundColor ?? zetaColors.textDefault,
          unselectedText: appBarTheme.foregroundColor?.withOpacity(0.7) ?? zetaColors.textSubtle,
        );
    }
  }

  /// Builds [ZdsTabBarStyleContainer]. Defaults to primary color.
  static ZdsTabBarStyleContainer _tabBarStyle(
    BuildContext context,
    bool hasIcons, {
    required Color selectedText,
    required Color background,
    required Color unselectedText,
    required Color indicator,
  }) {
    final double height = hasIcons ? 56.0 : 48.0;
    final ThemeData theme = Theme.of(context);

    final TabBarTheme tabBarTheme = theme.tabBarTheme.copyWith(indicatorSize: TabBarIndicatorSize.tab);
    final TextStyle? labelStyle = hasIcons ? theme.textTheme.bodySmall : theme.textTheme.bodyLarge;

    return ZdsTabBarStyleContainer(
      customTheme: ZdsTabBarThemeData(
        decoration: BoxDecoration(color: background),
        height: height,
      ),
      theme: theme.copyWith(
        tabBarTheme: tabBarTheme.copyWith(
          labelStyle: labelStyle,
          unselectedLabelStyle: labelStyle,
          unselectedLabelColor: unselectedText,
          labelColor: selectedText,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3,
              color: indicator,
            ),
          ),
        ),
      ),
    );
  }
}
