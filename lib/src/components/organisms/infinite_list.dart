import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Wrapper around a ListView.builder with Zds styling and functions for fetching new items when the user scrolls to the bottom of the list.
///
/// * [hasMore] - Whether the list has more items that have not yet been retrieved.
/// * [onLoadMore] - Function to retrieve more data.
///
/// Some variables have changed default values compared to ZdsList / ListView.
///
/// * [padding] - Default value is EdgeInsets.zero.
///
/// The other parameters act the same way as the ones in [ZdsList], which extends [ListView].
///
/// This example is split into state and view code, and shows how the onLoadMore function works with an API call.
///
/// ```dart
/// // In state
/// List items = await service.apiCall();
///
/// // In view
/// ZdsInfiniteListView(
///   itemBuilder: ((_, index) {
///     return ZdsListTileWrapper(
///       top: index == 0,
///       bottom: index == items.length - 1,
///       child: ZdsListTile(
///         title: Text(items[index]),
///       ),
///     );
///   }),
///   itemCount: items.length,
///   hasMore: true,
///   onLoadMore: () async => items += await service.apiCall(),
/// )
/// ```
///
/// See also:
///
///  * [ZdsList], A List with Zds styling.
///  * [ListView],  A scrollable list of widgets arranged linearly.
class ZdsInfiniteListView extends StatefulWidget {
  /// Creates a [ZdsInfiniteListView].
  const ZdsInfiniteListView({
    required this.itemBuilder,
    required this.itemCount,
    super.key,
    this.childKey,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
    this.cacheExtent,
    this.restorationId,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
    this.showEmpty = false,
    this.loadingBuilder,
    this.onLoadMore,
    this.hasMore = false,
    this.compact = false,
  }) : assert(
          onLoadMore != null ? hasMore : true && (hasMore ? onLoadMore != null : onLoadMore == null),
          'If hasMore is true, onLoadMore must not be null; if hasMore is false, onLoadMore must be null.',
        );

  /// Key passed to [ZdsList.builder].
  final Key? childKey;

  /// True to set the list in reverse. Defaults to false.
  final bool reverse;

  /// Direction of scroll. Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// ScrollController passed to [ZdsList.builder].
  ///
  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  final ScrollController? controller;

  /// Primary passed to [ZdsList.builder].
  ///
  /// Whether this is the primary scroll view associated with the parent  [PrimaryScrollController].
  final bool? primary;

  /// ScrollPhysics passed to passed to [ZdsList.builder].
  ///
  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// ShrinkWrap passed to [ZdsList.builder].
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// Default value is EdgeInsets.zero.
  final EdgeInsetsGeometry? padding;

  /// Builds loading widget whilst data is being fetched.
  ///
  /// Displayed as last item in list whilst data is loading.
  final WidgetBuilder? loadingBuilder;

  /// Builds individual items in the list.
  final IndexedWidgetBuilder itemBuilder;

  /// Length of all items in the list.
  final int itemCount;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// AddAutomaticKeepAlives passed to [ZdsList.builder].
  ///
  /// See:
  /// * [SliverChildBuilderDelegate.addAutomaticKeepAlives].
  final bool addAutomaticKeepAlives;

  /// AddRepaintBoundaries passed to [ZdsList.builder].
  ///
  /// See:
  /// * [SliverChildBuilderDelegate.addRepaintBoundaries].
  final bool addRepaintBoundaries;

  /// AddSemanticIndexes passed to [ZdsList.builder].
  ///See:
  /// * [SliverChildBuilderDelegate.addSemanticIndexes].
  final bool addSemanticIndexes;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@macro ZdsList.showEmpty}
  final bool showEmpty;

  /// Callback function that awaits the retrieval of more data items.
  /// Typically used for an API call.
  ///
  /// This must be provided if hasMore is true.
  final Future<void> Function()? onLoadMore;

  /// Whether the list has more items that have not yet been retrieved.
  /// When true, onLoadMore is called once the user scrolls to the bottom of the list.
  ///
  /// If true, onLoadMore must not be null
  ///
  /// Defaults to false.
  final bool hasMore;

  /// Whether the list items should be close together, or separated.
  final bool compact;

  @override
  ZdsInfiniteListViewState createState() => ZdsInfiniteListViewState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Key?>('childKey', childKey))
      ..add(DiagnosticsProperty<bool>('reverse', reverse))
      ..add(EnumProperty<Axis>('scrollDirection', scrollDirection))
      ..add(DiagnosticsProperty<ScrollController?>('controller', controller))
      ..add(DiagnosticsProperty<bool?>('primary', primary))
      ..add(DiagnosticsProperty<ScrollPhysics?>('physics', physics))
      ..add(DiagnosticsProperty<bool>('shrinkWrap', shrinkWrap))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding))
      ..add(ObjectFlagProperty<WidgetBuilder?>.has('loadingBuilder', loadingBuilder))
      ..add(ObjectFlagProperty<IndexedWidgetBuilder>.has('itemBuilder', itemBuilder))
      ..add(IntProperty('itemCount', itemCount))
      ..add(DoubleProperty('cacheExtent', cacheExtent))
      ..add(StringProperty('restorationId', restorationId))
      ..add(DiagnosticsProperty<bool>('addAutomaticKeepAlives', addAutomaticKeepAlives))
      ..add(DiagnosticsProperty<bool>('addRepaintBoundaries', addRepaintBoundaries))
      ..add(DiagnosticsProperty<bool>('addSemanticIndexes', addSemanticIndexes))
      ..add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior))
      ..add(EnumProperty<ScrollViewKeyboardDismissBehavior>('keyboardDismissBehavior', keyboardDismissBehavior))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty<bool>('showEmpty', showEmpty))
      ..add(ObjectFlagProperty<Future<void> Function()?>.has('onLoadMore', onLoadMore))
      ..add(DiagnosticsProperty<bool>('hasMore', hasMore))
      ..add(DiagnosticsProperty<bool>('compact', compact));
  }
}

/// State for [ZdsInfiniteListView].
class ZdsInfiniteListViewState extends State<ZdsInfiniteListView> {
  bool _loadingMore = false;

  @override
  Widget build(BuildContext context) {
    final ZdsList list = ZdsList.builder(
      key: widget.childKey,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      cacheExtent: widget.cacheExtent,
      restorationId: widget.restorationId,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      clipBehavior: widget.clipBehavior,
      showEmpty: widget.showEmpty,
      itemCount: widget.itemCount + (widget.hasMore ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (widget.hasMore && index >= widget.itemCount) {
          if (widget.loadingBuilder != null) {
            return widget.loadingBuilder!.call(context);
          }
          return const SizedBox(
            height: 44,
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          return widget.itemBuilder.call(context, index);
        }
      },
    );
    return NotificationListener<ScrollEndNotification>(
      onNotification: (ScrollEndNotification scrollInfo) {
        if (!widget.hasMore) return true;
        if (scrollInfo.metrics.axisDirection != AxisDirection.down) return true;
        if (widget.onLoadMore == null || _loadingMore) return true;
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadingMore = true;
          unawaited(
            widget.onLoadMore
                ?.call()
                .whenComplete(() => _loadingMore = false)
                .onError((Object? error, StackTrace stackTrace) => _loadingMore = false),
          );
        }
        return true;
      },
      child: widget.compact ? ZdsListGroup(child: list) : list,
    );
  }
}
