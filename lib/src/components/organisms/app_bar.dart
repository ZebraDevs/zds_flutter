import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../../../zds_flutter.dart';

/// An app bar with Zds styling.
///
/// Typically used in [Scaffold.appBar], placing it at the top of the screen. By using the [bottom] property, another
/// widget can be displayed below this appbar, typically a [ZdsResponsiveTabBar] or a [ZdsTabBar].
///
/// ```dart
/// Scaffold(
///   appBar: ZdsAppBar(
///     title: Text("I'm an appbar!")
///     bottom: ZdsTabBar()
///   ),
/// )
/// ```
///
/// By default, if no [leading] widget is provided, the appbar will provide an [IconButton] to return to the previous
/// page in the [Navigator]'s stack.
///
/// See also:
///
///  * [ZdsResponsiveTabBar] and [ZdsTabBar], typically used to display tabs below this widget.
///  * [ZdsPopupMenu], typically used in [actions] to display a kebab menu for further actions that would pollute
///    the appbar if they were all shown.
class ZdsAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an appbar that is typically shown at the top of the screen.
  const ZdsAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.subtitle,
    this.icon,
    this.bottom,
    this.systemUiOverlayStyle,
    this.applyTopSafeArea = true,
    this.color = ZdsTabBarColor.appBar,
  });

  /// The widget shown at the start of the appbar. Typically an [IconButton].
  ///
  /// If null and the [Navigator]'s stack can pop, a back button will be shown by default.
  final Widget? leading;

  /// The appBar's main text. Typically a [Text] widget, it is usually used to show the page's name.
  final Widget? title;

  /// The widget that will be shown below the [title]. Typically a [Text] widget, it is usually used to display
  /// secondary information about the current page.
  final Widget? subtitle;

  /// A widget that will be shown between the [leading] and [title] widgets.
  final Widget? icon;

  /// Widgets that will be shown at the end  of the appbar. Typically a list of [IconButton].
  ///
  /// The recommended length is 3 items or fewer. If you need to display more actions, consider creating a kebab
  /// [IconButton] menu with [ZdsPopupMenu].
  final List<Widget>? actions;

  /// Specifies a preference for the style of the system's overlays when this appbar is used. If null,
  /// [ThemeData.appBarTheme] will be used. If null, [SystemUiOverlayStyle.dark] will be used by default.
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// This widget appears below the app bar. Typically a [ZdsResponsiveTabBar] or a [ZdsTabBar].
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget? bottom;

  /// Color for app bar. Defaults to primary color.
  ///
  /// See [ZdsTabBarColor].
  final ZdsTabBarColor color;

  /// (`applyTopSafeArea`) Determines if the top safe area should be applied to the `ZdsAppBar` or not.
  ///
  ///  Set to `true` if you want your application to eliminate any disruptive
  ///  elements present at the top of the screen like the notch on the iPhone X
  ///  for the `ZdsAppBar`. It is recommended to leave this as `true` for better UI.
  ///
  ///  If set to `false`, disruptive elements at the top of the screen will not be
  ///  accounted for and you might have some UI elements hidden behind those disruptions.
  ///
  ///  This is a final value, meaning that once set, it cannot be changed.
  ///
  /// Defaults to `true`
  final bool applyTopSafeArea;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = buildTheme(context, color);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle ?? appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.dark,
      sized: false,
      child: Material(
        color: appBarTheme.backgroundColor,
        child: SafeArea(
          top: applyTopSafeArea,
          bottom: false,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: _toolbarHeight,
                child: IconTheme(
                  data: appBarTheme.iconTheme ?? theme.primaryIconTheme,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: icon == null ? 24 : 12),
                    child: Row(
                      children: <Widget>[
                        Semantics(
                          sortKey: const OrdinalSortKey(2),
                          child: _resolvedLeading(context),
                        ),
                        if (icon != null) icon!,
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Semantics(
                              sortKey: const OrdinalSortKey(1),
                              child: DefaultTextStyle(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: theme.textTheme.titleMedium!.copyWith(color: appBarTheme.foregroundColor),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    if (title != null) title!,
                                    if (title != null && subtitle != null) const SizedBox(height: 4),
                                    if (subtitle != null)
                                      DefaultTextStyle.merge(
                                        child: subtitle!,
                                        style: theme.primaryTextTheme.titleSmall
                                            ?.copyWith(color: appBarTheme.foregroundColor?.withOpacity(0.8)),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (actions != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions!,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (bottom != null) bottom!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_toolbarHeight + _bottomHeight);

  double get _bottomHeight => bottom?.preferredSize.height ?? 0;

  double get _toolbarHeight => kZdsToolbarHeight;

  Widget _resolvedLeading(BuildContext context) {
    if (leading != null) return leading!;

    final bool canPop = ModalRoute.of(context)?.canPop ?? false;

    if (canPop) return const ZdsBackButton();

    return const SizedBox();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<SystemUiOverlayStyle?>('systemUiOverlayStyle', systemUiOverlayStyle))
      ..add(EnumProperty<ZdsTabBarColor>('color', color))
      ..add(DiagnosticsProperty<bool>('applyTopSafeArea', applyTopSafeArea));
  }

  /// Builds theme variants for [ZdsAppBar].
  ///
  /// See also
  /// * [ZdsTabBarColor].
  static AppBarTheme buildTheme(BuildContext context, ZdsTabBarColor color) {
    final zetaColors = Zeta.of(context).colors;
    switch (color) {
      case ZdsTabBarColor.appBar:
        return Theme.of(context).appBarTheme;
      case ZdsTabBarColor.primary:
        final fgColor = zetaColors.primary.onColor;
        final bgColor = zetaColors.primary;
        return AppBarTheme(
          systemOverlayStyle: computeSystemOverlayStyle(bgColor),
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0.5,
          iconTheme: IconThemeData(color: fgColor),
          actionsIconTheme: IconThemeData(color: fgColor),
        );
      case ZdsTabBarColor.basic:
        final fgColor = zetaColors.textDefault;
        final bgColor = zetaColors.surfaceTertiary;
        return AppBarTheme(
          systemOverlayStyle: computeSystemOverlayStyle(bgColor),
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0.5,
          iconTheme: IconThemeData(color: fgColor),
          actionsIconTheme: IconThemeData(color: fgColor),
        );
      case ZdsTabBarColor.surface:
        final fgColor = zetaColors.textDefault;
        final bgColor = zetaColors.surfacePrimary;
        return AppBarTheme(
          systemOverlayStyle: computeSystemOverlayStyle(bgColor),
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0.5,
          iconTheme: IconThemeData(color: fgColor),
          actionsIconTheme: IconThemeData(color: fgColor),
        );
    }
  }
}
