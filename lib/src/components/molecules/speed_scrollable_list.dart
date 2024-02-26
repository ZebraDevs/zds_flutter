import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// Used to define an item in a [ZdsSpeedScrollableList]
class ZdsSpeedScrollableListItemGroup {
  /// Creates a new [ZdsSpeedScrollableListItemGroup]
  ZdsSpeedScrollableListItemGroup({
    required this.itemGroup,
    required this.children,
  });

  /// The value that appears on the speed slider that, when scrolled to, will scroll to the list of given children.
  final String itemGroup;

  /// The list of children to be found under the given value for [itemGroup]
  final List<Widget> children;
}

/// A list that implements a [ZdsSpeedSlider] which allows the user to quickly scroll between groupings of items.
class ZdsSpeedScrollableList extends StatefulWidget {
  /// Creates a new [ZdsSpeedScrollableList]
  const ZdsSpeedScrollableList({
    required this.items,
    required this.itemGroups,
    this.headerBuilder,
    super.key,
  });

  /// The items displayed in the list.
  /// If a [ZdsSpeedScrollableListItemGroup] has an itemGroup value which is not present in [itemGroups], the [ZdsSpeedScrollableListItemGroup] will not be shown on the list.
  final List<ZdsSpeedScrollableListItemGroup> items;

  /// Builds the headers above each grouping. Accepts a build context and the value of the group  E.g. 'A'.
  final Widget Function(BuildContext context, String value)? headerBuilder;

  /// The list of items given to the speed slider.
  /// Scrolling to one of these will scroll the [ZdsSpeedScrollableListItemGroup] with the corresponding itemGroup value.
  final List<String> itemGroups;

  @override
  State<ZdsSpeedScrollableList> createState() => _ZdsSpeedScrollableListState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ZdsSpeedScrollableListItemGroup>('items', items))
      ..add(
        ObjectFlagProperty<Widget Function(BuildContext context, String value)?>.has(
          'headerBuilder',
          headerBuilder,
        ),
      )
      ..add(IterableProperty<String>('itemGroups', itemGroups));
  }
}

class _ZdsSpeedScrollableListState extends State<ZdsSpeedScrollableList> {
  // Maps an item group to its corresponding key
  final Map<String, GlobalKey> _keyMap = {};
  final _scrollContentKey = GlobalKey();
  final _scrollController = ScrollController();

  final _sliderKey = GlobalKey<ZdsSpeedSliderState>();

  int sliderIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateKeys();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrollableBox = _scrollContentKey.currentContext!.findRenderObject()! as RenderBox;
    final bounds = scrollableBox.localToGlobal(Offset.zero);
    final top = bounds.dy + (scrollableBox.size.height * 0.2);

    for (final key in _keyMap.values) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final itemTop = renderBox.localToGlobal(Offset.zero).dy;
        final itemBottom = itemTop + renderBox.size.height;

        final index = _keyMap.values.toList().indexOf(key);
        if (itemTop < top && itemBottom > top) {
          sliderIndex = index;
          _sliderKey.currentState!.setIndex(sliderIndex);
          break;
        }
      }
    }
  }

  void _generateKeys() {
    _keyMap
      ..clear()
      ..addEntries(
        widget.itemGroups.map((group) => MapEntry(group, GlobalKey())),
      );
  }

  @override
  void didUpdateWidget(ZdsSpeedScrollableList oldWidget) {
    if (widget.items != oldWidget.items) {
      _generateKeys();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              key: _scrollContentKey,
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _keyMap.keys.map(
                  (key) {
                    final itemGroup = widget.items.firstWhereOrNull((group) => group.itemGroup == key);
                    if (itemGroup != null) {
                      return _ItemGroup(
                        itemGroup,
                        key: _keyMap[key],
                        headerBuilder: widget.headerBuilder,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ZdsSpeedSlider(
            key: _sliderKey,
            items: widget.itemGroups,
            onChange: (index) async {
              final context = _keyMap[widget.itemGroups[index]]?.currentContext;
              if (context != null) {
                _scrollController.removeListener(_onScroll);
                await Scrollable.ensureVisible(context, alignment: 0.5);
                _scrollController.addListener(_onScroll);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('sliderIndex', sliderIndex))
      ..add(IntProperty('sliderIndex', sliderIndex));
  }
}

class _ItemGroup extends StatelessWidget {
  const _ItemGroup(this.group, {this.headerBuilder, super.key});

  final ZdsSpeedScrollableListItemGroup group;
  final Widget Function(BuildContext context, String value)? headerBuilder;

  @override
  Widget build(BuildContext context) {
    final header = headerBuilder != null
        ? headerBuilder!(context, group.itemGroup)
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              group.itemGroup,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          const SizedBox(height: 4),
          ...group.children,
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ZdsSpeedScrollableListItemGroup>('group', group))
      ..add(
        ObjectFlagProperty<Widget Function(BuildContext context, String value)?>.has(
          'headerBuilder',
          headerBuilder,
        ),
      )
      ..add(
        ObjectFlagProperty<Widget Function(BuildContext context, String value)?>.has(
          'headerBuilder',
          headerBuilder,
        ),
      );
  }
}
