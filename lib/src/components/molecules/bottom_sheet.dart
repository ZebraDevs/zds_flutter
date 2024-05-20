import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../zds_flutter.dart';

/// Use [showZdsBottomSheet] to display any bottom sheets instead of using this widget directly.
///
/// Defines the contents to be shown in a bottom sheet.
///
/// See also:
///
///  * [showZdsBottomSheet], which uses this widget for its contents and is the recommended way to show bottom sheets
class ZdsBottomSheet extends StatelessWidget {
  /// Defines the contents of the bottom sheet. It's recommended to not use this widget directly and instead call
  /// [showZdsBottomSheet]
  ///
  /// [child] must not be null.
  const ZdsBottomSheet({
    required this.child,
    super.key,
    this.header,
    this.bottom,
    this.backgroundColor,
    this.maxHeight,
    this.bottomInset,
  }) : assert(maxHeight != null ? maxHeight > 0 : maxHeight == null, 'Max height must be greater than 0');

  /// The widget that contains the main content of this bottom sheet. If [header] and [bottom] are not null, it will be
  /// shown between those two widgets
  final Widget child;

  /// The widget that will be shown at the top of this bottom sheet. Typically a [ZdsSheetHeader]
  final PreferredSizeWidget? header;

  /// The widget that will be shown at the bottom of this bottom sheet. Typically a [ZdsBottomBar]
  final PreferredSizeWidget? bottom;

  /// The background color for this bottom sheet.
  ///
  /// Defaults to [ColorScheme.surface]
  final Color? backgroundColor;

  /// How high this bottom sheet will be allowed to grow. If not null, it must be greater than 0. The bottom sheet will
  /// not grow beyond the screen height excluding the top viewPadding even if a greater maxHeight value is declared.
  ///
  /// Defaults to `MediaQuery.size.height - MediaQuery.viewPadding.top`
  final double? maxHeight;

  /// How much of the bottom part of the display will be avoided when showing this ZdsBottomSheet.
  ///
  /// Defaults to `MediaQuery.viewPadding.bottom`
  final double? bottomInset;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color sheetBackgroundColor = backgroundColor ?? colorScheme.surface;
    final Color headerColor = header != null ? colorScheme.surface : sheetBackgroundColor;
    final _BottomSheetHeader headerWidget = _BottomSheetHeader(bottom: header, backgroundColor: headerColor);
    final MediaQueryData media = MediaQuery.of(context);
    final double maxScreenHeight = media.size.height - media.viewPadding.top;
    final double height =
        maxHeight != null && (maxHeight! > 0 && maxHeight! < maxScreenHeight) ? maxHeight! : maxScreenHeight;
    final double setBottomInset = bottomInset ?? MediaQuery.of(context).viewPadding.bottom;

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Container(
        constraints: BoxConstraints(maxHeight: height),
        color: sheetBackgroundColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: headerWidget.preferredSize.height,
                bottom: (bottom?.preferredSize.height ?? 0) + setBottomInset,
              ),
              child: Semantics(sortKey: const OrdinalSortKey(2), child: child),
            ),
            SizedBox(
              height: headerWidget.preferredSize.height,
              child: Semantics(
                sortKey: const OrdinalSortKey(1),
                child: headerWidget,
              ),
            ),
            if (bottom != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: bottom!.preferredSize.height + setBottomInset,
                child: Semantics(sortKey: const OrdinalSortKey(3), child: bottom),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('maxHeight', maxHeight))
      ..add(DoubleProperty('bottomInset', bottomInset));
  }
}

/// Method to build widgets for headerBuilder & bottomBuilder of showZdsBottomSheet
/// This return an array of widgets which contains first element as ZdsSheetHeader and second element as ZdsBottomBar
/// Here widgets gets computed based on the device(Mobile or Tablet).
///
/// * [primaryActionText] Text for primary button (like Save button)
/// * [primaryActionOnTap] On tap event for primary button
/// * [secondaryActionText] Text for secondary button (like Cancel button)
/// * [secondaryActionOnTap]  On tap event for secondary button
/// * [ternaryActionText] Text for ternary button (like Reset button)
/// * [ternaryActionOnTap]  On tap event for ternary button
/// * [title] Title for the ZdsSheetHeader
/// * [showClose] Close icon button for the ZdsSheetHeader
List<Widget> buildSheetBars({
  required BuildContext context,
  String primaryActionText = '',
  VoidCallback? primaryActionOnTap,
  String secondaryActionText = '',
  VoidCallback? secondaryActionOnTap,
  String ternaryActionText = '',
  VoidCallback? ternaryActionOnTap,
  String? title = '',
  bool showClose = false,
}) {
  final bool isTablet = context.isTablet();
  final num offset = isTablet ? 0 : MediaQuery.of(context).viewPadding.bottom;

  return <Widget>[
    ZdsSheetHeader(
      headerText: title!,
      leading: isTablet && secondaryActionText.isNotEmpty
          ? ZdsButton.text(
              child: Text(secondaryActionText),
            )
          : !isTablet && showClose
              ? IconButton(
                  onPressed: () {
                    secondaryActionOnTap != null ? secondaryActionOnTap() : Navigator.of(context).pop();
                  },
                  icon: const Icon(ZdsIcons.close),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                )
              : null,
      trailing: isTablet && primaryActionText.isNotEmpty
          ? ZdsButton.text(
              onTap: primaryActionOnTap,
              child: Text(primaryActionText),
            )
          : null,
    ),
    if (_isBottomBarRequired(isTablet, primaryActionText, secondaryActionText, ternaryActionText))
      ZdsBottomBar(
        minHeight: kBottomBarHeight + offset,
        child: Row(
          children: <Widget>[
            if (isTablet) ...<Widget>[
              if (ternaryActionText.isNotEmpty)
                ZdsButton.text(
                  onTap: ternaryActionOnTap,
                  child: Text(ternaryActionText),
                ),
            ] else ...<Widget>[
              if (ternaryActionText.isNotEmpty)
                ZdsButton.text(
                  onTap: ternaryActionOnTap,
                  child: Text(ternaryActionText),
                ),
              const Spacer(),
              if (secondaryActionText.isNotEmpty && !showClose)
                ZdsButton.outlined(
                  child: Text(secondaryActionText),
                  onTap: () {
                    secondaryActionOnTap != null ? secondaryActionOnTap() : Navigator.of(context).pop();
                  },
                ),
              const SizedBox(width: 9),
              if (primaryActionText.isNotEmpty)
                ZdsButton.filled(
                  onTap: primaryActionOnTap,
                  child: Text(primaryActionText),
                ),
            ],
          ],
        ),
      ),
  ];
}

bool _isBottomBarRequired(
  bool isTablet,
  String primaryActionText,
  String secondaryActionText,
  String ternaryActionText,
) {
  if (isTablet) {
    return ternaryActionText.isNotEmpty;
  } else if (primaryActionText.isNotEmpty || secondaryActionText.isNotEmpty || ternaryActionText.isNotEmpty) {
    return true;
  }
  return false;
}

/// Shows a bottom sheet with Zds styling.
///
/// Uses a [ZdsBottomSheet] to build the bottom sheet contents. [context] and [builder] must not be null.
///
///  * [builder] creates the [ZdsBottomSheet.child].
///  * [backgroundColor] sets [ZdsBottomSheet.backgroundColor].
///  * [barrierColor] argument is used to specify the color of the modal
///    barrier that darkens everything below the dialog. If `null`, the default
///    color `Colors.black54` is used.
///  * [maxHeight] sets [ZdsBottomSheet.maxHeight]. If not null, it must be greater than 0. The bottom sheet will
///    not grow beyond the screen height excluding the top viewPadding even if a greater maxHeight value is declared.
///    Defaults to `MediaQuery.size.height - MediaQuery.viewPadding.top`.
///  * [maxWidth] sets maxWidth for the dialog.
///  * [bottomInset] sets [ZdsBottomSheet.bottomInset]. Defaults to `MediaQuery.viewPadding.bottom`.
///  * [headerBuilder] creates the [ZdsBottomSheet.header]. Typically a [ZdsSheetHeader].
///  * [bottomBuilder] creates the [ZdsBottomSheet.bottom]. Typically a [ZdsBottomBar].
///  * If [isDismissible] is set to true, then clicking outside the sheet content will close the sheet else nothing
///    happens. Defaults to `true`.
///  * If [enableDrag] is set to true, then sheet could be dragged down to close it, provided that the immediate child
///  * [contentPadding] can be used to apply additional padding to the body
///    is a scrollable content. Defaults to `true`.
///  * [useRootNavigator] The useRootNavigator argument is used to determine whether to push the dialog to the
///    Navigator furthest from or nearest to the given context. By default, useRootNavigator is false and the dialog
///    route created by this method is pushed to the nearest navigator. It can not be null.
///  * [enforceSheet] argument is used to show bottom sheet irrespective of the device type. Defaults to false.
Future<T?> showZdsBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  Color? barrierColor = Colors.black54,
  double? maxHeight,
  double? maxWidth,
  double? bottomInset,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
  bool enforceSheet = false,
  EdgeInsetsGeometry? contentPadding,
  PreferredSizeWidget Function(BuildContext)? headerBuilder,
  PreferredSizeWidget? Function(BuildContext)? bottomBuilder,
}) {
  return enforceSheet || !context.isTablet()
      ? showMaterialModalBottomSheet<T>(
          context: context,
          barrierColor: barrierColor,
          isDismissible: isDismissible,
          closeProgressThreshold: 0.8,
          bounce: true,
          enableDrag: enableDrag,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (BuildContext context) {
            final PreferredSizeWidget? header = headerBuilder?.call(context);
            final PreferredSizeWidget? bottom = bottomBuilder?.call(context);
            final Widget child = builder.call(context);

            return ZdsBottomSheet(
              header: header,
              bottom: bottom,
              maxHeight: maxHeight,
              bottomInset: bottomInset,
              backgroundColor: backgroundColor,
              child: child,
            );
          },
        )
      : showDialog<T>(
          context: context,
          barrierColor: barrierColor,
          barrierDismissible: isDismissible,
          useRootNavigator: useRootNavigator,
          builder: (BuildContext context) {
            final PreferredSizeWidget? header = headerBuilder?.call(context);
            final PreferredSizeWidget? bottom = bottomBuilder?.call(context);
            Widget child = builder.call(context);

            if (contentPadding != null) {
              child = Padding(
                padding: contentPadding,
                child: child,
              );
            }

            final double shortestSide = MediaQuery.of(context).size.shortestSide;

            return Dialog(
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: maxWidth ?? (shortestSide * 0.75),
                  height: maxHeight ?? (shortestSide * 0.70),
                  child: Column(
                    children: <Widget>[
                      if (header != null) header,
                      Expanded(
                        child: child,
                      ),
                      if (bottom != null) bottom,
                    ],
                  ),
                ),
              ),
            );
          },
        );
}

class _BottomSheetHeader extends StatelessWidget implements PreferredSizeWidget {
  const _BottomSheetHeader({this.bottom, this.backgroundColor});

  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  static const double _dragAreaHeight = 20;

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: bottom != null ? Border(bottom: BorderSide(color: zetaColors.shadow)) : null,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _dragAreaHeight,
            alignment: Alignment.center,
            color: backgroundColor ?? Theme.of(context).colorScheme.surface,
            child: Container(
              width: 120,
              height: 4,
              decoration: BoxDecoration(
                color: zetaColors.borderSubtle,
                borderRadius: BorderRadius.circular(19),
              ),
            ),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        _dragAreaHeight + (bottom?.preferredSize.height ?? 0) + kHeaderBoarderSize,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}
