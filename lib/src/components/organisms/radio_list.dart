import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// A class that [ZdsRadioList.items] must extend.
///
/// View [ZdsRadioList] for more details.
@immutable
abstract class ZdsRadioItem<T> {
  /// The label that will be shown for this item in the ZdsRadioList.
  final String label;

  /// The associated value to this item.
  final T value;

  /// Constructs a [ZdsRadioItem].
  const ZdsRadioItem(this.label, this.value);

  @override
  bool operator ==(Object other) {
    if (other is ZdsRadioItem<T>) {
      return value == other.value;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => value.hashCode;
}

/// Creates a list of radio buttons with labels. Tapping anywhere on the list tile selects the item.
///
/// The items used in the widget must extend [ZdsRadioItem].
///
/// ```dart
/// ZdsRadioList(
///   initialValue: DateValue('Current Month', DateRange.currentMonth),
///   items: [
///     WalkDate('Current Week', DateRange.currentWeek),
///     WalkDate('Last Week', DateRange.lastWeek),
///     WalkDate('Current Month', DateRange.currentMonth),
///   ],
/// )
/// // Class definitions
/// class DateValue extends ZdsRadioItem<WalkDateRange> {
///   DateValue(String label, DateRange value) : super(label, value);
/// }
///
/// enum DateRange {currentWeek,lastWeek, currentMonth,}
/// ```
class ZdsRadioList<U extends ZdsRadioItem<dynamic>> extends StatefulWidget {
  /// Primary content of the list, typically a [Text] widget.
  final Widget? title;

  /// List of items in the radio list.
  final List<U> items;

  /// Initial value of the radio button.
  final U? initialValue;

  /// Callback to update item state.
  final void Function(U? item)? onChange;

  /// Create a list of items with a radio button and a label.
  ///
  /// [items] can't be null.
  const ZdsRadioList({
    super.key,
    this.title,
    this.items = const [],
    this.onChange,
    this.initialValue,
  });

  @override
  ZdsRadioListState<U> createState() => ZdsRadioListState<U>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<U>('items', items))
      ..add(DiagnosticsProperty<U?>('initialValue', initialValue))
      ..add(ObjectFlagProperty<void Function(U? item)?>.has('onChange', onChange));
  }
}

/// State for [ZdsRadioList].
class ZdsRadioListState<U extends ZdsRadioItem<dynamic>> extends State<ZdsRadioList<U>> {
  U? _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.initialValue;
  }

  void _handleChange(U? value) {
    setState(() {
      _groupValue = value;
    });
    widget.onChange?.call(_groupValue);
  }

  bool get _isInExpansionTile => context.findAncestorWidgetOfExactType<ZdsExpansionTile>() != null;

  Widget _paddingWrapper({required Widget child}) {
    if (_isInExpansionTile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _isInExpansionTile ? const EdgeInsets.only(bottom: 14) : EdgeInsets.zero,
      child: Column(
        children: widget.items.map((item) {
          return Material(
            color: ZdsColors.transparent,
            // The list tile wraps its children with a MergeSemantics. This attempts to merge its descendant Semantics
            // nodes into one node in the semantics tree.
            child: MergeSemantics(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: InkWell(
                  onTap: () => _handleChange(item),
                  child: _paddingWrapper(
                    child: IgnorePointer(
                      child: Row(
                        children: [
                          Radio<U>(
                            value: item,
                            groupValue: _groupValue,
                            // Empty void function to allow touch events to be handled by the larger container
                            onChanged: (_) {},
                          ),
                          Text(item.label, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
