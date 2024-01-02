import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Defines an item to be used in a [ZdsDropdownList]
class ZdsDropdownListItem<T> {
  /// Creates a new [ZdsDropdownListItem]
  ZdsDropdownListItem({
    required this.value,
    required this.name,
  });

  /// The value of the item
  final T value;

  /// The name of the item
  final String name;
}

/// A [DropdownButtonFormField] with Zds style and behavior.
class ZdsDropdownList<T> extends StatefulWidget {
  /// Constructs a [ZdsDropdownList].
  const ZdsDropdownList({
    this.onChange,
    this.onReset,
    this.value,
    this.label,
    this.onTap,
    this.hint,
    this.labelStyle,
    this.borderColor,
    this.options = const <ZdsDropdownListItem<Never>>[],
    super.key,
  });

  /// The label that will be shown above the dropdown.
  final String? label;

  /// A function called whenever the selected items change.
  final void Function(T selectedValue)? onChange;

  /// A function called whenever no items selected.
  final void Function()? onReset;

  /// A function called whenever the dropdown is tapped.
  ///
  /// This will disable the functionality of the dropdown and the list will no longer open.
  /// You will neeed to manage the state yourself by changing [value].
  final void Function()? onTap;

  /// The list of options for the dropdown.
  final List<ZdsDropdownListItem<T>> options;

  /// The value of the selected item.
  ///
  /// The value must match the value property of one of the [ZdsDropdownListItem]s in [options].
  /// If two options have the same value, the first one in the list will be used.
  final T? value;

  /// The textStyle used for dropdown label.
  ///
  /// Defaults to [TextTheme.headlineSmall].
  final TextStyle? labelStyle;

  /// The hint shown when the dropdown has no value.
  final String? hint;

  /// The border color of the dropdown.
  final Color? borderColor;

  @override
  ZdsDropdownListState<T> createState() => ZdsDropdownListState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(ObjectFlagProperty<void Function(T selectedValue)?>.has('onChange', onChange))
      ..add(ObjectFlagProperty<void Function()?>.has('onReset', onReset))
      ..add(ObjectFlagProperty<void Function()?>.has('onTap', onTap))
      ..add(IterableProperty<ZdsDropdownListItem<T>>('options', options))
      ..add(DiagnosticsProperty<T?>('value', value))
      ..add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle))
      ..add(StringProperty('hint', hint))
      ..add(ColorProperty('borderColor', borderColor));
  }
}

/// State for [ZdsDropdownList].
class ZdsDropdownListState<T> extends State<ZdsDropdownList<T>> {
  ZdsDropdownListItem<T>? _selectedItem;
  final TextEditingController _formFieldController = TextEditingController();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _setValue();
  }

  void _setValue() {
    try {
      _selectedItem = widget.options.where((ZdsDropdownListItem<T> element) => element.value == widget.value).first;
      _formFieldController.text = _selectedItem?.name ?? '';
    } catch (e) {
      _selectedItem = null;
    }
  }

  @override
  void didUpdateWidget(ZdsDropdownList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(_setValue);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _formFieldController.dispose();
  }

  /// Resets the value of the dropdown
  void reset() {
    setState(() {
      _selectedItem = null;
    });
    _formFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ZdsInputBorder? border = widget.borderColor != null
        ? ZdsInputBorder(
            borderSide: BorderSide(color: widget.borderColor!),
            space: 2,
            borderRadius: BorderRadius.circular(6),
          )
        : null;

    final themeData = Theme.of(context);
    final zetaColors = Zeta.of(context).colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.label != null) ...<Widget>[
          Text(
            widget.label!,
            style: widget.labelStyle ??
                themeData.textTheme.headlineSmall?.copyWith(
                  color: zetaColors.textSubtle,
                ),
          ),
          const SizedBox(height: 4),
        ],
        Semantics(
          onTap: widget.onTap != null ? () => widget.onTap : null,
          button: true,
          label: _selectedItem?.name ?? widget.hint,
          enabled: widget.options.isNotEmpty || widget.onTap != null,
          excludeSemantics: true,
          child: GestureDetector(
            onTap: () => widget.onTap?.call(),
            child: DropdownButton2<T>(
              value: _selectedItem?.value,
              onMenuStateChange: (bool isOpen) => setState(() {
                _isOpen = isOpen;
              }),
              customButton: TextFormField(
                controller: _formFieldController,
                decoration: ZdsInputDecoration.withNoLabel(
                  suffixPadding: const EdgeInsets.only(right: 8),
                  suffixIcon: Icon(
                    _isOpen ? ZdsIcons.chevron_up : ZdsIcons.chevron_down,
                    color: zetaColors.iconSubtle,
                  ),
                  border: border,
                  errorBorder: border,
                  focusedBorder: border,
                  disabledBorder: border,
                  hintText: widget.hint,
                  enabled: false,
                ),
              ),
              underline: const SizedBox(),
              items: widget.onTap == null
                  ? widget.options.map(
                      (ZdsDropdownListItem<T> item) {
                        return DropdownMenuItem<T>(
                          value: item.value,
                          child: Text(
                            item.name,
                            style: const TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        );
                      },
                    ).toList()
                  : <DropdownMenuItem<T>>[],
              menuItemStyleData: MenuItemStyleData(
                selectedMenuItemBuilder: (BuildContext context, Widget child) {
                  return ColoredBox(
                    color: themeData.colorScheme.secondary.withOpacity(0.1),
                    child: child,
                  );
                },
              ),
              dropdownStyleData: const DropdownStyleData(elevation: 4),
              onChanged: (T? value) {
                if (value != null && value == _selectedItem?.value) {
                  reset();
                  widget.onReset?.call();
                } else if (value != null) {
                  setState(() {
                    _selectedItem =
                        widget.options.firstWhere((ZdsDropdownListItem<T> element) => element.value == value);
                  });
                  _formFieldController.text = _selectedItem?.name ?? '';
                  widget.onChange?.call(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
