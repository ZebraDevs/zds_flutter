import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// A [ZdsVerticalNav] used to switch between different views. Should primarily be used for tablet views and larger screens.
///
/// Actions are shown at the **top**, items are shown at the **bottom**.
///
/// ```dart
/// Row(
///   children: [
///     ZdsVerticalNav(
///       currentIndex: index,
///       onTap: (i) => setState(() => index = i),
///       items: [ZdsVerticalNavItem(), ZdsVerticalNavItem()],
///     ),
///     index == 0 ? BodyForFirstItem() : BodyForSecondItem(),
///   ],
/// )
/// ```
class ZdsVerticalNav extends StatefulWidget {
  /// The [ZdsNavItem] list that will be displayed at the **bottom** of the component. Each item should be linked to a separate view.
  final List<ZdsNavItem> items;

  /// The currently selected item index from [items].
  ///
  /// Must not be greater or equal to [items].length.
  final int currentIndex;

  /// The function that will be called whenever the user taps on an item. The parameter is the item index in [items].
  ///
  /// Usually used to call setState and change the [currentIndex]'s value.
  final void Function(int)? onTap;

  /// Widgets that will be shown at the **top** of the nav bar. Typically a list of [IconButton].
  final List<Widget>? actions;

  /// Width of the navigation bar.
  ///
  /// Defaults to 48
  final double barWidth;

  /// Height of the navigation item.
  ///
  /// Defaults to 53
  final double itemHeight;

  /// Creates a vertical navigation bar
  ///
  /// [items] can't be null. [currentIndex]'s value must be equal or greater than 0, and smaller than [items].length.
  const ZdsVerticalNav({
    required this.items,
    required this.currentIndex,
    this.actions,
    this.barWidth = 48,
    this.itemHeight = 53,
    super.key,
    this.onTap,
  }) : assert(
          0 <= currentIndex && currentIndex < items.length,
          'currentIndex must not be greater than the number of items',
        );

  @override
  State<ZdsVerticalNav> createState() => _ZdsVerticalNavState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<ZdsNavItem>('items', items));
    properties.add(IntProperty('currentIndex', currentIndex));
    properties.add(ObjectFlagProperty<void Function(int p1)?>.has('onTap', onTap));
    properties.add(DoubleProperty('barWidth', barWidth));
    properties.add(DoubleProperty('itemHeight', itemHeight));
  }
}

class _ZdsVerticalNavState extends State<ZdsVerticalNav> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsWidget = Stack(
      children: [
        if (!isExpanded)
          AnimatedPositioned(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 200),
            left: 0,
            right: 0,
            top: widget.currentIndex * widget.itemHeight,
            child: _SelectedBackground(width: widget.barWidth, height: widget.itemHeight),
          ),
        Column(
          children: widget.items.map(
            (item) {
              final bool selected = widget.currentIndex == widget.items.indexOf(item);
              return MergeSemantics(
                child: Semantics(
                  label: '${item.semanticLabel ?? ''} tab ${widget.items.indexOf(item) + 1} of ${widget.items.length}',
                  child: Semantics(
                    selected: selected,
                    container: true,
                    child: SizedBox(
                      width: widget.barWidth,
                      height: widget.itemHeight,
                      child: Tooltip(
                        message: item.semanticLabel ?? '',
                        child: InkWell(
                          radius: widget.barWidth,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                          onTap: () => widget.onTap?.call(widget.items.indexOf(item)),
                          child: IconTheme(
                            data: IconThemeData(
                              color: selected
                                  ? Theme.of(context).colorScheme.secondary
                                  : ZdsColors.greySwatch(context)[1000],
                              size: 24,
                            ),
                            child: item.icon,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTooShort =
            (((widget.actions?.length ?? 0) + widget.items.length) * widget.itemHeight) + (2 * widget.itemHeight) + 4 >=
                (constraints.minHeight != 0 ? constraints.minHeight : constraints.maxHeight);

        final actionsWidget = widget.actions != null
            ? IconTheme(
                data: IconThemeData(color: Theme.of(context).colorScheme.secondary, size: 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.actions!
                        .map(
                          (action) => Column(
                            children: [
                              action,
                              if (widget.actions!.indexOf(action) != widget.actions!.length - 1)
                                Divider(color: ZdsColors.greySwatch(context)[100]),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            : const SizedBox.shrink();

        return Container(
          width: widget.barWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
                blurRadius: 2,
                offset: const Offset(-1, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.only(bottom: 4),
          child: Material(
            child: Stack(
              children: [
                if (isTooShort)
                  Positioned(
                    top: 0,
                    child: IconTheme(
                      data: IconThemeData(color: Theme.of(context).colorScheme.secondary, size: 24),
                      child: IconButton(
                        onPressed: () => setState(() => isExpanded = !isExpanded),
                        icon: Icon(isExpanded ? ZdsIcons.back : ZdsIcons.more_vert),
                      ),
                    ),
                  ),
                if (!isTooShort || (isTooShort && isExpanded))
                  Positioned(
                    top: !isTooShort ? 0 : widget.itemHeight,
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 150),
                      child: SizedBox(
                        height: !isTooShort
                            ? constraints.maxHeight - (widget.items.length * widget.itemHeight)
                            : constraints.maxHeight - widget.itemHeight,
                        child: actionsWidget,
                      ),
                    ),
                  ),
                if (!isTooShort || (isTooShort && !isExpanded)) Positioned(bottom: 0, child: itemsWidget),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
  }
}

class _SelectedBackground extends StatelessWidget {
  final double width;
  final double height;

  const _SelectedBackground({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        margin: const EdgeInsets.fromLTRB(2, 2, 0, 2),
        padding: const EdgeInsets.only(left: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.surface],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 2,
              offset: const Offset(-2, 1),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
  }
}
