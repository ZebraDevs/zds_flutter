import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// A slider used to quickly scroll through a list of items.
/// The selected item index can be set by attaching a key of type [ZdsSpeedSliderState] to the widget and calling key.currentState.setIndex.
class ZdsSpeedSlider extends StatefulWidget {
  /// Creates a new [ZdsSpeedSlider]
  const ZdsSpeedSlider({
    this.items = _defaultAlphabet,
    this.height = 200,
    this.initialIndex = 0,
    this.controller,
    this.onChange,
    super.key,
  }) : assert(
          initialIndex >= 0 && initialIndex < items.length,
          'The given index should be within the bounds of the given items',
        );

  /// The list of items given to the slider.
  /// Defaults to the uppercase letters of the english alphabet and a '#' symbol.
  final List<String> items;

  /// The function called when the speed slider changes.
  final void Function(int index)? onChange;

  /// The initial selected index from [items].
  final int initialIndex;

  /// The height of the slider.
  /// Defaults to 200
  final double height;

  /// The scroll controller attatched to the slider
  final ScrollController? controller;

  /// The default items for the slider.
  static const defaultItems = _defaultAlphabet;

  @override
  State<ZdsSpeedSlider> createState() => ZdsSpeedSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<String>('items', items))
      ..add(ObjectFlagProperty<void Function(int index)?>.has('onLetterSelected', onChange))
      ..add(IntProperty('initialIndex', initialIndex))
      ..add(DoubleProperty('height', height))
      ..add(DiagnosticsProperty<ScrollController?>('controller', controller));
  }
}

/// The state of the [ZdsSpeedSlider]
class ZdsSpeedSliderState extends State<ZdsSpeedSlider> with FrameCallbackMixin {
  late final ScrollController _scrollController;
  final _scrollableKey = GlobalKey();
  late List<GlobalKey> _itemKeys;

  int _selectedIndex = 0;

  void _scrollListener() {
    setState(() {
      _selectedIndex = _getCenterItemIndex();
    });
    widget.onChange?.call(_selectedIndex);
  }

  @override
  void initState() {
    _generateKeys();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_scrollListener);

    atLast(() {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
      unawaited(_scrollItemIntoView(_selectedIndex));
    });

    super.initState();
  }

  @override
  void didUpdateWidget(ZdsSpeedSlider oldWidget) {
    if (oldWidget.items != widget.items) {
      _generateKeys();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _generateKeys() {
    _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
  }

  /// Moves the slider to the given index.
  void setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Remove the listener so that the onChange function is not called
    _scrollController.removeListener(_scrollListener);
    unawaited(
      _scrollItemIntoView(_selectedIndex).then((_) {
        _scrollController.addListener(_scrollListener);
      }),
    );
  }

  Future<void> _scrollItemIntoView(int index) async {
    final key = _itemKeys[index];
    await Scrollable.ensureVisible(key.currentContext!, alignment: 0.5);
  }

  int _getCenterItemIndex() {
    final viewBox = _scrollableKey.currentContext!.widgetRenderBox!;
    final top = viewBox.localToGlobal(Offset.zero).dy;
    final bottom = top + viewBox.size.height;
    final center = top + viewBox.size.height / 2;

    for (final itemKey in _itemKeys) {
      final itemViewBox = itemKey.currentContext!.widgetRenderBox!;
      final itemTop = itemViewBox.localToGlobal(Offset.zero).dy;
      final itemBottom = itemTop + itemViewBox.size.height;

      if (itemTop > bottom) {
        return 0;
      }

      if (itemTop <= center && itemBottom >= center) {
        return _itemKeys.indexOf(itemKey);
      }
    }

    return _itemKeys.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items.map((letter) {
      final index = widget.items.indexOf(letter);
      final key = _itemKeys[index];
      return GestureDetector(
        onTap: () => unawaited(_scrollItemIntoView(index)),
        child: _Letter(
          letter,
          index: index,
          selectedIndex: _selectedIndex,
          key: key,
        ),
      );
    }).toList();

    return SizedBox(
      height: widget.height,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        key: _scrollableKey,
        child: Column(
          children: [
            SizedBox(
              height: widget.height / 2,
            ),
            ...items,
            SizedBox(
              height: widget.height / 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Letter extends StatelessWidget {
  const _Letter(
    this.letter, {
    required this.index,
    required this.selectedIndex,
    super.key,
  });

  final int index;
  final int selectedIndex;
  final String letter;

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);
    final colors = zeta.colors;

    Color color = colors.textSubtle;
    final diff = (index - selectedIndex).abs();

    if (diff == 0) {
      color = colors.primary;
    } else if (diff == 1) {
      color = colors.textDefault;
    } else if (diff > 1 && diff < 4) {
      color = colors.textSubtle;
    } else {
      color = colors.textDisabled;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        letter,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('index', index))
      ..add(IntProperty('selectedIndex', selectedIndex))
      ..add(StringProperty('letter', letter));
  }
}

const _defaultAlphabet = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '#',
];
