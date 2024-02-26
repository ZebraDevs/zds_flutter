import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// Defines a button for [ZdsBottomTabBar] or [ZdsVerticalNav]. Used in [ZdsBottomTabBar.items].
class ZdsNavItem {
  /// Creates a button to be used in [ZdsBottomTabBar]
  const ZdsNavItem({
    required this.label,
    required this.icon,
    this.semanticLabel,
    this.semanticState = '',
    this.id,
  });

  /// used for automation purpose
  final String? id;

  /// The label that will appear below the icon for this item.
  final String label;

  /// The icon that will be shown above this item's label. Usually an [Icon] or [IconWithBadge].
  final Widget icon;

  /// Semantic label to wrap the item.
  ///
  /// Defaults to [label].
  final String? semanticLabel;

  /// Semantic label for state of the item e.g. Selected.
  ///
  /// if [ZdsNavItem] state is selected then this get appended to the [semanticLabel].
  final String semanticState;
}

/// A [ZdsBottomBar] used to switch between different views. Typically used as a [Scaffold.bottomNavigationBar] in a
/// [StatefulWidget].
/// ```dart
/// Scaffold(
///   bottomNavigationBar: ZdsBottomTabBar(
///     currentIndex: index,
///     onTap: (i) => setState(() => index = i),
///     items: [ZdsNavItem(), ZdsNavItem()],
///   ),
///   body: index == 0 ? BodyForFirstItem() : BodyForSecondItem(),
/// )
/// ```
class ZdsBottomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a bottom tab navigation bar
  ///
  /// [items] can't be null. [currentIndex]'s value must be equal or greater than 0, and smaller than [items].length.
  const ZdsBottomTabBar({
    required this.items,
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.contentPadding,
    this.minHeight = kBottomBarHeight,
  }) : assert(
          0 <= currentIndex && currentIndex < items.length,
          'currentIndex must not be greater than the number of items',
        );

  /// The [ZdsBottomTabBar] list that will be displayed. Each item should be linked to a separate view.
  final List<ZdsNavItem> items;

  /// The currently selected item index from [items].
  ///
  /// Must not be greater or equal to [items].length.
  final int currentIndex;

  /// The function that will be called whenever the user taps on an item. The parameter is the item index in [items].
  ///
  /// Usually used to call setState and change the [currentIndex]'s value.
  final void Function(int)? onTap;

  /// Empty space to inscribe inside this widget.
  ///
  /// Defaults to the [ZdsBottomBarTheme] value.
  final EdgeInsets? contentPadding;

  /// The height that this bottom bar will be.
  ///
  /// Defaults to [kBottomBarHeight].
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData theme = Theme.of(context).bottomNavigationBarTheme;
    final ZdsBottomBarThemeData zdsBottomBarTheme = ZdsBottomBarTheme.of(context);
    final EdgeInsets tabBarContentPadding = contentPadding ??
        zdsBottomBarTheme.contentPadding.copyWith(
          left: 0,
          right: 0,
        );
    return ZdsBottomBarTheme(
      data: zdsBottomBarTheme.copyWith(contentPadding: tabBarContentPadding),
      child: ZdsBottomBar(
        minHeight: minHeight,
        contentPadding: contentPadding,
        child: DefaultTextStyle.merge(
          overflow: TextOverflow.ellipsis,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (int i = 0; i < items.length; i++)
                () {
                  final bool selected = i == currentIndex;
                  //keeping key empty for other apps should be replaced with proper translation once added in repo.
                  final String finalSemanticLabel = ComponentStrings.of(context)
                      .get('', items[i].semanticLabel ?? items[i].label, args: <String>['${i + 1}', '${items.length}']);
                  return Expanded(
                    child: Semantics(
                      excludeSemantics: true,
                      onTap: () {
                        onTap?.call(i);
                      },
                      label: '$finalSemanticLabel${selected ? ', ${items[i].semanticState}' : ''}',
                      child: _ZdsBottomTabBarTile(
                        id: items[i].id,
                        selected: selected,
                        icon: IconTheme(
                          data: selected ? theme.selectedIconTheme! : theme.unselectedIconTheme!,
                          child: items[i].icon,
                        ),
                        label: items[i].label,
                        labelStyle: selected
                            ? theme.selectedLabelStyle!.copyWith(color: theme.selectedItemColor)
                            : theme.unselectedLabelStyle!.copyWith(color: theme.unselectedItemColor),
                        onTap: () {
                          onTap?.call(i);
                        },
                      ),
                    ),
                  );
                }(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(minHeight);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('currentIndex', currentIndex))
      ..add(IterableProperty<ZdsNavItem>('items', items))
      ..add(ObjectFlagProperty<void Function(int p1)?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<EdgeInsets?>('contentPadding', contentPadding))
      ..add(DoubleProperty('minHeight', minHeight));
  }
}

class _ZdsBottomTabBarTile extends StatelessWidget {
  const _ZdsBottomTabBarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.labelStyle,
    this.id,
    this.onTap,
  });
  final VoidCallback? onTap;
  final Widget icon;
  final String label;
  final bool selected;
  final String? id;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    final String effectiveTooltip = label;
    Widget result = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
      child: InkResponse(
        onTap: onTap,
        enableFeedback: false,
        child: Column(
          key: id != null ? Key(id!) : null,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(height: 4),
            ExcludeSemantics(
              child: Text(
                label,
                style: labelStyle,
                textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.35),
              ),
            ),
          ],
        ),
      ),
    );

    result = Tooltip(
      message: effectiveTooltip,
      preferBelow: false,
      verticalOffset: 50,
      excludeFromSemantics: true,
      child: result,
    );

    return Semantics(
      selected: selected,
      container: true,
      child: result,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(StringProperty('id', id))
      ..add(DiagnosticsProperty<TextStyle>('labelStyle', labelStyle));
  }
}
