import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';
import '../../utils/tools/measure.dart';

const int _emptyChildLength = 30;

final List<Widget> _emptyChildren =
    List<Widget>.generate(_emptyChildLength, (_) => _emptyChild).divide(const Divider()).toList();

const Widget _emptyChild = SizedBox(height: 60, width: double.infinity);

Widget _emptyBuilder(_, __) => _emptyChild;

/// Creates a [ListView] with predefined parameters that match Zds styling and behavior.
///
/// See also:
///
///  * [ListView].
class ZdsList extends ListView {
  /// Creates a [ZdsList].
  ZdsList({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    ScrollPhysics? physics,
    super.shrinkWrap,
    super.padding = const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: kDefaultVerticalPadding,
    ),
    super.itemExtent,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.cacheExtent,
    List<Widget> children = const <Widget>[],
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    this.showEmpty = false,
  }) : super(
          physics: showEmpty && children.isEmpty ? const NeverScrollableScrollPhysics() : physics,
          children: showEmpty && children.isEmpty ? _emptyChildren : children,
        );

  // TODO(thelukewalton): Add prop for seperated list with divider

  /// Creates a ZdsList with an itemBuilder.
  ///
  /// Extends [ListView.builder] with Zds styling and behavior.
  ///
  /// To create a list builder with the items compacted together:
  /// ```dart
  ///ZdsListGroup(
  ///  child: ZdsList.builder(
  ///    padding: EdgeInsets.zero,
  ///    itemBuilder: (context, index) {
  ///      return ZdsListTile(
  ///        title: Text(index.toString()),
  ///        onTap: () {},
  ///      );
  ///    },
  ///    itemCount: 10,
  /// ),
  /// ```
  ZdsList.builder({
    required IndexedWidgetBuilder itemBuilder,
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    ScrollPhysics? physics,
    super.shrinkWrap,
    super.padding = const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
    int? itemCount,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.cacheExtent,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    this.showEmpty = false,
  }) : super.separated(
          physics: showEmpty && (itemCount == null || itemCount == 0) ? const NeverScrollableScrollPhysics() : physics,
          itemBuilder: showEmpty && (itemCount == null || itemCount == 0) ? _emptyBuilder : itemBuilder,
          itemCount: showEmpty && (itemCount == null || itemCount == 0) ? _emptyChildLength : itemCount ?? 0,
          separatorBuilder: (_, __) {
            if (showEmpty && !(itemCount == null || itemCount == 0)) {
              return const Divider(height: 1);
            }
            return const SizedBox.shrink();
          },
        );

  /// {@template ZdsList.showEmpty}
  /// Whether to show an empty list with a divider if the `children` list is empty.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool showEmpty;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('showEmpty', showEmpty));
  }
}

/// Makes a horizontal [ListView] that sizes itself to its children.
class ZdsHorizontalList extends _ZdsHorizontalList {
  /// Creates a [ZdsHorizontalList].
  ZdsHorizontalList({super.key, List<Widget>? children, super.caption, super.isReducedHeight})
      : super(
          delegate: _ZdsHorizontalListChildrenDelegate(children),
        );

  /// Makes a horizontal [ListView.builder] that sizes itself to its children.
  ZdsHorizontalList.builder({
    super.key,
    BuilderCallback? itemBuilder,
    int? itemCount,
    super.caption,
    super.isReducedHeight,
  }) : super(
          delegate: _ZdsHorizontalListBuilderDelegate(itemBuilder, itemCount),
        );
}

class _ZdsHorizontalList extends StatelessWidget {
  const _ZdsHorizontalList({super.key, this.delegate, this.caption, this.isReducedHeight = false});
  final Widget? caption;
  final _ZdsHorizontalChildDelegate? delegate;
  final bool isReducedHeight;

  @override
  Widget build(BuildContext context) {
    final Widget firstItem = delegate!.build(context, 0);

    return MeasureSize(
      child: firstItem,
      builder: (BuildContext context, Size size) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DefaultTextStyle(
              style: Theme.of(context).textTheme.displayMedium!,
              child: caption != null ? caption!.paddingOnly(top: 20, left: 20, right: 20) : const SizedBox(),
            ),
            SizedBox(
              width: double.infinity,
              height: isReducedHeight ? size.height : size.height + 20,
              child: CustomScrollView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        delegate!.build,
                        childCount: delegate!.estimatedChildCount,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<_ZdsHorizontalChildDelegate?>('delegate', delegate))
      ..add(DiagnosticsProperty<bool>('isReducedHeight', isReducedHeight));
  }
}

class _ZdsHorizontalListChildrenDelegate extends _ZdsHorizontalChildDelegate {
  _ZdsHorizontalListChildrenDelegate(this.children) : super();
  final List<Widget>? children;

  @override
  int get estimatedChildCount => children!.length;

  @override
  Widget build(BuildContext context, int index) {
    return children![index];
  }
}

class _ZdsHorizontalListBuilderDelegate extends _ZdsHorizontalChildDelegate {
  _ZdsHorizontalListBuilderDelegate(this.builder, this.itemCount) : super();
  final int? itemCount;
  final BuilderCallback? builder;

  @override
  int? get estimatedChildCount => itemCount;

  @override
  Widget build(BuildContext context, int index) {
    return builder!(context, index);
  }
}

abstract class _ZdsHorizontalChildDelegate {
  const _ZdsHorizontalChildDelegate();

  int? get estimatedChildCount => null;

  Widget build(BuildContext context, int index);
}

/// Callback function for [ZdsHorizontalList.builder] method.
typedef BuilderCallback = Widget Function(BuildContext context, int index);
