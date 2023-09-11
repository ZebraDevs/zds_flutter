import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// A component that groups together items in a ZdsList so that they have no padding between items.
///
/// Can either be used with a list of items, or with a dynamic builder as child.
///
/// You can not have both a child and items.
class ZdsListGroup extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final cardMargin = Theme.of(context).cardTheme.margin as EdgeInsets? ?? EdgeInsets.zero;
    final tileTheme = Theme.of(context).zdsListTileThemeData;
    final labelDistance = cardMargin.top + tileTheme.tileMargin;
    final hasHeader = headerLabel != null;
    final additionalMargin = hasHeader ? tileTheme.labelAdditionalMargin : 0;

    return Padding(
      padding: padding ??
          EdgeInsets.only(
            bottom: tileTheme.tileMargin,
            top: tileTheme.tileMargin + additionalMargin,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHeader)
            Padding(
              padding: EdgeInsets.only(left: cardMargin.left, right: cardMargin.right),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ZdsColors.blueGrey),
                      child: headerLabel != null ? headerLabel! : const SizedBox(),
                    ),
                  ),
                  if (headerActions != null && headerActions!.isNotEmpty)
                    IconTheme.merge(
                      data: IconThemeData(color: Theme.of(context).colorScheme.primaryContainer, size: 20),
                      child: DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Theme.of(context).colorScheme.primaryContainer),
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
                backgroundColor: itemsBackgroundColor ?? Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: child,
              ),
            )
          else
            // ZdsCard(
            // variant: cardVariant,
            // backgroundColor: itemsBackgroundColor ?? Theme.of(context).colorScheme.surface,
            // padding: EdgeInsets.zero,
            // child:
            Column(
              mainAxisSize: MainAxisSize.min,
              children: items!.divide(const Divider()).toList(),
              // ),
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
