import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A component that groups items within a ZdsList, eliminating padding between them.
///
/// This component can be utilized with a predefined list of items or with a dynamic builder for its children.
///
/// It is not advisable to use this for lists whose length might change dynamically. This component attempts to
/// construct all its children at once, which could degrade performance with a long list of children.
/// For such cases, consider using a [ListView.builder] and enclosing each [ZdsListTile] within a [ZdsListTileWrapper].
///
/// Note: You cannot specify both a child and items simultaneously.
class ZdsListGroup extends StatelessWidget {
  /// Constructs a [ZdsListGroup].
  const ZdsListGroup({
    super.key,
    this.items,
    this.itemsBackgroundColor,
    this.child,
    this.headerLabel,
    this.headerActions,
    this.cardVariant = ZdsCardVariant.elevated,
    this.padding,
  }) : assert(
          (items != null && child == null) || (items == null && child != null),
          'Provide only 1 of either items or child',
        );

  /// A label that goes in the header of this component above the list aligned to the start.
  final Text? headerLabel;

  /// A list of widgets that are displayed in the header of the list aligned to the end.
  final List<Widget>? headerActions;

  /// Items in the list.
  ///
  /// When items are provided they are built in a ZdsList.
  ///
  /// When items are provided, a child can not be provided, as they are alternate ways of implementing the same part of the component.
  final List<Widget>? items;

  /// A [ZdsList] child that can be a ZdsList.builder.
  ///
  /// When a child is provided, items can not be provided, as they are alternate ways of implementing the same part of the component.
  final Widget? child;

  /// Padding around the outside of the list group.
  ///
  /// Defaults to ```EdgeInsets.only( bottom: tileTheme.tileMargin,top: tileTheme.tileMargin + additionalMargin);```
  final EdgeInsets? padding;

  /// {@macro card-variant}
  final ZdsCardVariant cardVariant;

  /// Background color.
  ///
  /// Defaults to `[ColorScheme.surface].
  final Color? itemsBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cardMargin = themeData.cardTheme.margin as EdgeInsets? ?? EdgeInsets.zero;
    final labelDistance = cardMargin.top + kZdsListTileTheme.tileMargin;
    final hasHeader = headerLabel != null;
    final additionalMargin = hasHeader ? kZdsListTileTheme.labelAdditionalMargin : 0;
    final zetaColors = Zeta.of(context).colors;

    return Padding(
      padding: padding ??
          EdgeInsets.only(
            bottom: kZdsListTileTheme.tileMargin,
            top: kZdsListTileTheme.tileMargin + additionalMargin,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (hasHeader)
            Padding(
              padding: EdgeInsets.only(left: cardMargin.left, right: cardMargin.right),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DefaultTextStyle(
                      style: safeTextStyle(themeData.textTheme.titleSmall).copyWith(color: zetaColors.textSubtle),
                      child: headerLabel != null ? headerLabel! : const SizedBox(),
                    ),
                  ),
                  if (headerActions?.isNotEmpty ?? false)
                    IconTheme.merge(
                      data: IconThemeData(color: zetaColors.secondary.icon, size: 20),
                      child: DefaultTextStyle(
                        style: safeTextStyle(themeData.textTheme.titleSmall).copyWith(color: zetaColors.secondary.text),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: headerActions!,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          SizedBox(height: hasHeader ? labelDistance : 0),
          if (child != null)
            Expanded(
              child: ZdsCard(
                variant: cardVariant,
                backgroundColor: itemsBackgroundColor ?? themeData.colorScheme.surface,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: child,
              ),
            )
          else
            ZdsCard(
              variant: cardVariant,
              backgroundColor: itemsBackgroundColor ?? themeData.colorScheme.surface,
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: (items ?? []).divide(const Divider()).toList(),
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
      ..add(DiagnosticsProperty<EdgeInsets?>('padding', padding))
      ..add(EnumProperty<ZdsCardVariant>('cardVariant', cardVariant))
      ..add(ColorProperty('itemsBackgroundColor', itemsBackgroundColor));
  }
}
