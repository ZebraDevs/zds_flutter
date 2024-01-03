import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A list tile with circular edges that can be toggled between a selected and unselected state.
///
/// There are two variants:
/// * [ZdsSelectableListTile], which returns a list tile that changes its color when selected.
///   When a listTile is marked as selected, its background will be colored with the [ColorScheme.secondary] at 10%
///   opacity. When it's unselected, the background will use [ColorScheme.surface]
/// * [ZdsSelectableListTile.checkable], which returns a list tile that adds a check at the end of the tile when selected.
///
/// This widget does not manage its own state, but should rather be rebuilt by the parent widget's state through
/// [onTap].
class ZdsSelectableListTile extends StatelessWidget {
  /// A tile with rounded edges that can be toggled as selected or unselected.
  const ZdsSelectableListTile({
    super.key,
    this.leading,
    this.title,
    this.subTitle,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.semanticLabel,
  }) : _checkable = false;

  /// A tile with rounded edges that can be toggled as selected or unselected and shows a check icon when selected.
  const ZdsSelectableListTile.checkable({
    super.key,
    this.leading,
    this.title,
    this.subTitle,
    this.selected = false,
    this.onTap,
    this.semanticLabel,
  })  : trailing = const Icon(ZdsIcons.check),
        _checkable = true;

  /// A widget shown before the title.
  ///
  /// Usually an indicator of whether the tile is selected or not.
  final Widget? leading;

  /// The tile's title.
  ///
  /// Typically a [Text].
  final Widget? title;

  /// The tile's subTitle.
  ///
  /// Typically a [Text].
  final Widget? subTitle;

  /// A widget shown at the end of the tile.
  ///
  /// Usually an indicator of whether the tile is selected or not.
  final Widget? trailing;

  /// Whether the tile is selected.
  ///
  /// Defaults to false.
  final bool selected;

  /// A function called whenever the user taps on this tile.
  ///
  /// Used to set the parent's state and update [selected].
  final VoidCallback? onTap;

  final bool _checkable;

  /// this is for talk back text
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    const EdgeInsets innerPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 12);

    final bool showSelected = (_checkable && selected) || (!_checkable && selected);

    final themeData = Theme.of(context);
    final zetaColors = Zeta.of(context).colors;

    return IconTheme(
      data: themeData.iconTheme.copyWith(size: 24, color: zetaColors.secondary.icon),
      child: Padding(
        padding: kZdsSelectableListTilePadding,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(kZdsSelectableListTileBorderRadius)),
          child: Material(
            color: showSelected ? zetaColors.secondary.surface : themeData.colorScheme.surface,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: showSelected
                    ? Border.all(color: zetaColors.secondary.border)
                    : Border.all(color: zetaColors.borderSubtle),
                borderRadius: const BorderRadius.all(Radius.circular(kZdsSelectableListTileBorderRadius)),
              ),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(kZdsSelectableListTileBorderRadius)),
                onTap: onTap,
                child: Semantics(
                  selected: selected,
                  enabled: onTap != null,
                  onTap: onTap,
                  label: semanticLabel,
                  excludeSemantics: semanticLabel != null,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: padding.copyWith(
                        top: 0,
                        left: leading == null ? 0 : null,
                        right: trailing == null ? 0 : null,
                        bottom: 0,
                      ),
                      child: Row(
                        children: <Widget>[
                          if (leading != null) leading!,
                          if (title != null)
                            Expanded(
                              child: Padding(
                                padding: padding.copyWith(
                                  left: leading != null ? innerPadding.left : null,
                                  right: trailing != null ? innerPadding.right : null,
                                  top: subTitle != null ? 14 : innerPadding.top,
                                  bottom: subTitle != null ? 14 : innerPadding.bottom,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    title!,
                                    if (subTitle != null)
                                      Container(child: subTitle).textStyle(
                                        themeData.textTheme.titleSmall!
                                            .copyWith(color: zetaColors.textSubtle, fontSize: 12),
                                      ),
                                  ],
                                ),
                              ).textStyle(themeData.textTheme.titleSmall),
                            ),
                          if ((trailing != null && !_checkable) || (_checkable && selected)) trailing!,
                        ],
                      ),
                    ),
                  ),
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
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(StringProperty('semanticLabel', semanticLabel));
  }
}
