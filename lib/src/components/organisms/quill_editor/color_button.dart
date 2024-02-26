// ignore_for_file: strict_raw_type, public_member_api_docs

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';

import '../../../utils/localizations/translation.dart';
import '../../../utils/tools/utils.dart';

/// Controls color styles.
///
/// When pressed, this button displays overlay toolbar with
/// buttons for each color.
class ZdsQuillToolbarColorButton extends StatefulWidget {
  const ZdsQuillToolbarColorButton({
    required this.controller,
    required this.isBackground,
    this.options = const QuillToolbarColorButtonOptions(),
    super.key,
  });

  /// Is this background color button or font color
  final bool isBackground;
  final QuillController controller;
  final QuillToolbarColorButtonOptions options;

  @override
  ZdsQuillToolbarColorButtonState createState() => ZdsQuillToolbarColorButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isBackground', isBackground))
      ..add(DiagnosticsProperty<QuillController>('controller', controller))
      ..add(DiagnosticsProperty<QuillToolbarColorButtonOptions>('options', options));
  }
}

class ZdsQuillToolbarColorButtonState extends State<ZdsQuillToolbarColorButton> {
  late bool _isToggledColor;
  late bool _isToggledBackground;
  late bool _isWhite;
  late bool _isWhiteBackground;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {
      _isToggledColor = _getIsToggledColor(widget.controller.getSelectionStyle().attributes);
      _isToggledBackground = _getIsToggledBackground(widget.controller.getSelectionStyle().attributes);
      _isWhite = _isToggledColor && _selectionStyle.attributes['color']!.value == '#ffffff';
      _isWhiteBackground = _isToggledBackground && _selectionStyle.attributes['background']!.value == '#ffffff';
    });
  }

  @override
  void initState() {
    super.initState();
    _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
    _isToggledBackground = _getIsToggledBackground(_selectionStyle.attributes);
    _isWhite = _isToggledColor && _selectionStyle.attributes['color']!.value == '#ffffff';
    _isWhiteBackground = _isToggledBackground && _selectionStyle.attributes['background']!.value == '#ffffff';
    widget.controller.addListener(_didChangeEditingValue);
  }

  bool _getIsToggledColor(Map<String, Attribute<dynamic>> attrs) {
    return attrs.containsKey(Attribute.color.key);
  }

  bool _getIsToggledBackground(Map<String, Attribute<dynamic>> attrs) {
    return attrs.containsKey(Attribute.background.key);
  }

  @override
  void didUpdateWidget(covariant ZdsQuillToolbarColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
      _isToggledBackground = _getIsToggledBackground(_selectionStyle.attributes);
      _isWhite = _isToggledColor && _selectionStyle.attributes['color']!.value == '#ffffff';
      _isWhiteBackground = _isToggledBackground && _selectionStyle.attributes['background']!.value == '#ffffff';
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  QuillToolbarColorButtonOptions get options {
    return widget.options;
  }

  QuillController get controller {
    return widget.controller;
  }

  double get iconSize {
    final baseFontSize = baseButtonExtraOptions?.iconSize;
    final iconSize = options.iconSize;
    return iconSize ?? baseFontSize ?? kDefaultIconSize;
  }

  double get iconButtonFactor {
    final baseIconFactor = baseButtonExtraOptions?.iconButtonFactor;
    final iconButtonFactor = options.iconButtonFactor;
    return iconButtonFactor ?? baseIconFactor ?? kDefaultIconButtonFactor;
  }

  VoidCallback? get afterButtonPressed {
    return options.afterButtonPressed ?? baseButtonExtraOptions?.afterButtonPressed;
  }

  QuillIconTheme? get iconTheme {
    return options.iconTheme ?? baseButtonExtraOptions?.iconTheme;
  }

  QuillToolbarBaseButtonOptions? get baseButtonExtraOptions {
    return context.quillToolbarBaseButtonOptions;
  }

  IconData get iconData {
    return options.iconData ??
        baseButtonExtraOptions?.iconData ??
        (widget.isBackground ? Icons.format_color_fill : Icons.color_lens);
  }

  String get tooltip {
    return options.tooltip ??
        baseButtonExtraOptions?.tooltip ??
        (widget.isBackground ? context.loc.backgroundColor : context.loc.fontColor);
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _isToggledColor && !widget.isBackground && !_isWhite
        ? _stringToColor(_selectionStyle.attributes['color']?.value as String?)
        : null;

    final iconColorBackground = _isToggledBackground && widget.isBackground && !_isWhiteBackground
        ? _stringToColor(_selectionStyle.attributes['background']?.value as String?)
        : null;

    final fillColor = _isToggledColor && !widget.isBackground && _isWhite ? _stringToColor('#ffffff') : null;
    final fillColorBackground =
        _isToggledBackground && widget.isBackground && _isWhiteBackground ? _stringToColor('#ffffff') : null;

    final childBuilder = options.childBuilder ?? baseButtonExtraOptions?.childBuilder;
    if (childBuilder != null) {
      return childBuilder(
        options,
        QuillToolbarColorButtonExtraOptions(
          controller: controller,
          context: context,
          onPressed: () {
            unawaited(_showColorPicker());
            afterButtonPressed?.call();
          },
          iconColor: null,
          iconColorBackground: iconColorBackground,
          fillColor: fillColor,
          fillColorBackground: fillColorBackground,
        ),
      );
    }

    return QuillToolbarIconButton(
      tooltip: tooltip,
      isSelected: false,
      iconTheme: iconTheme,
      icon: Icon(
        iconData,
        color: widget.isBackground ? iconColorBackground : iconColor,
        size: iconSize * iconButtonFactor,
      ),
      onPressed: _showColorPicker,
    );
  }

  void _changeColor(BuildContext context, Color? color) {
    if (color == null) {
      widget.controller.formatSelection(
        widget.isBackground ? const BackgroundAttribute(null) : const ColorAttribute(null),
      );
      return;
    }
    var hex = _colorToHex(color);
    hex = '#$hex';
    widget.controller.formatSelection(
      widget.isBackground ? BackgroundAttribute(hex) : ColorAttribute(hex),
    );
  }

  Future<void> _showColorPicker() async {
    final customCallback = options.customOnPressedCallback;
    if (customCallback != null) {
      await customCallback(controller, widget.isBackground);
      return;
    }
    unawaited(
      showDialog<String>(
        context: context,
        barrierColor:
            options.dialogBarrierColor ?? context.quillSharedConfigurations?.dialogBarrierColor ?? Colors.black54,
        builder: (_) => _ColorPickerDialog(
          isBackground: widget.isBackground,
          onRequestChangeColor: _changeColor,
          isToggledColor: _isToggledColor,
          selectionStyle: _selectionStyle,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('iconData', iconData))
      ..add(DiagnosticsProperty<QuillToolbarColorButtonOptions>('options', options))
      ..add(DiagnosticsProperty<QuillController>('controller', controller))
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(DoubleProperty('iconButtonFactor', iconButtonFactor))
      ..add(ObjectFlagProperty<VoidCallback?>.has('afterButtonPressed', afterButtonPressed))
      ..add(DiagnosticsProperty<QuillIconTheme?>('iconTheme', iconTheme))
      ..add(DiagnosticsProperty<QuillToolbarBaseButtonOptions?>('baseButtonExtraOptions', baseButtonExtraOptions))
      ..add(StringProperty('tooltip', tooltip));
  }
}

enum _PickerType {
  material,
  color,
}

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({
    required this.isBackground,
    required this.onRequestChangeColor,
    required this.isToggledColor,
    required this.selectionStyle,
  });

  final bool isBackground;

  final bool isToggledColor;
  final void Function(BuildContext context, Color? color) onRequestChangeColor;
  final Style selectionStyle;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<void Function(BuildContext context, Color? color)>.has(
          'onRequestChangeColor',
          onRequestChangeColor,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isBackground', isBackground))
      ..add(DiagnosticsProperty<bool>('isToggledColor', isToggledColor))
      ..add(DiagnosticsProperty<Style>('selectionStyle', selectionStyle));
  }
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  _PickerType pickerType = _PickerType.material;
  Color selectedColor = Colors.black;

  late final TextEditingController hexController;
  late void Function(void Function()) colorBoxSetState;

  @override
  void initState() {
    super.initState();
    hexController = TextEditingController(text: _colorToHex(selectedColor));
    if (widget.isToggledColor) {
      selectedColor = widget.isBackground
          ? _hexToColor(widget.selectionStyle.attributes['background']?.value as String?)
          : _hexToColor(widget.selectionStyle.attributes['color']?.value as String?);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ComponentStrings.of(context);
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            widget.onRequestChangeColor(context, null);
            Navigator.of(context).pop();
          },
          child: Text(strings.get('CLEAR', 'Clear')),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(strings.get('OK', 'Ok')),
        ),
      ],
      backgroundColor: Theme.of(context).canvasColor,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      pickerType = _PickerType.material;
                    });
                  },
                  child: Text(strings.get('MATERIAL', 'Material')),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      pickerType = _PickerType.color;
                    });
                  },
                  child: Text(strings.get('COLOR', 'Color')),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Column(
              children: [
                if (pickerType == _PickerType.material)
                  MaterialPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (color) {
                      widget.onRequestChangeColor(context, color);
                      Navigator.of(context).pop();
                    },
                  ),
                if (pickerType == _PickerType.color)
                  Column(
                    children: [
                      ColorPicker(
                        pickerColor: selectedColor,
                        displayThumbColor: true,
                        onColorChanged: (color) {
                          widget.onRequestChangeColor(context, color);
                          hexController.text = _colorToHex(color);
                          selectedColor = color;
                          colorBoxSetState(() {});
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: hexController,
                              onChanged: (value) {
                                selectedColor = hexToColor(value);
                                widget.onRequestChangeColor(context, selectedColor);
                                colorBoxSetState(() {});
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                                labelText: strings.get('HEX', 'Hex'),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          StatefulBuilder(
                            builder: (context, mcolorBoxSetState) {
                              colorBoxSetState = mcolorBoxSetState;
                              return Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                  color: selectedColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
              ],
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
      ..add(EnumProperty<_PickerType>('pickerType', pickerType))
      ..add(ColorProperty('selectedColor', selectedColor))
      ..add(DiagnosticsProperty<TextEditingController>('hexController', hexController))
      ..add(ObjectFlagProperty<void Function(void Function() p1)>.has('colorBoxSetState', colorBoxSetState));
  }
}

Color _hexToColor(String? hexString) {
  if (hexString == null) {
    return Colors.black;
  }
  final hexRegex = RegExp(r'([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$');

  final effectiveHex = hexString.replaceAll('#', '');
  if (!hexRegex.hasMatch(effectiveHex)) {
    return Colors.black;
  }

  final buffer = StringBuffer();
  if (effectiveHex.length == 6 || effectiveHex.length == 7) buffer.write('ff');
  buffer.write(effectiveHex);
  return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0xFF000000);
}

String _colorToHex(Color color) {
  return color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
}

Color _stringToColor(String? colorString, [Color? originalColor]) {
  if (colorString == null) return originalColor ?? Colors.black;

  switch (colorString) {
    case 'transparent':
      return Colors.transparent;
    case 'black':
      return Colors.black;
    case 'black12':
      return Colors.black12;
    case 'black26':
      return Colors.black26;
    case 'black38':
      return Colors.black38;
    case 'black45':
      return Colors.black45;
    case 'black54':
      return Colors.black54;
    case 'black87':
      return Colors.black87;
    case 'white':
      return Colors.white;
    case 'white10':
      return Colors.white10;
    case 'white12':
      return Colors.white12;
    case 'white24':
      return Colors.white24;
    case 'white30':
      return Colors.white30;
    case 'white38':
      return Colors.white38;
    case 'white54':
      return Colors.white54;
    case 'white60':
      return Colors.white60;
    case 'white70':
      return Colors.white70;
    case 'red':
      return Colors.red;
    case 'redAccent':
      return Colors.redAccent;
    case 'amber':
      return Colors.amber;
    case 'amberAccent':
      return Colors.amberAccent;
    case 'yellow':
      return Colors.yellow;
    case 'yellowAccent':
      return Colors.yellowAccent;
    case 'teal':
      return Colors.teal;
    case 'tealAccent':
      return Colors.tealAccent;
    case 'purple':
      return Colors.purple;
    case 'purpleAccent':
      return Colors.purpleAccent;
    case 'pink':
      return Colors.pink;
    case 'pinkAccent':
      return Colors.pinkAccent;
    case 'orange':
      return Colors.orange;
    case 'orangeAccent':
      return Colors.orangeAccent;
    case 'deepOrange':
      return Colors.deepOrange;
    case 'deepOrangeAccent':
      return Colors.deepOrangeAccent;
    case 'indigo':
      return Colors.indigo;
    case 'indigoAccent':
      return Colors.indigoAccent;
    case 'lime':
      return Colors.lime;
    case 'limeAccent':
      return Colors.limeAccent;
    case 'grey':
      return Colors.grey;
    case 'blueGrey':
      return Colors.blueGrey;
    case 'green':
      return Colors.green;
    case 'greenAccent':
      return Colors.greenAccent;
    case 'lightGreen':
      return Colors.lightGreen;
    case 'lightGreenAccent':
      return Colors.lightGreenAccent;
    case 'blue':
      return Colors.blue;
    case 'blueAccent':
      return Colors.blueAccent;
    case 'lightBlue':
      return Colors.lightBlue;
    case 'lightBlueAccent':
      return Colors.lightBlueAccent;
    case 'cyan':
      return Colors.cyan;
    case 'cyanAccent':
      return Colors.cyanAccent;
    case 'brown':
      return Colors.brown;
  }

  if (colorString.startsWith('rgba')) {
    var effectiveColor = colorString.substring(5); // trim left 'rgba('
    effectiveColor = effectiveColor.substring(0, effectiveColor.length - 1); // trim right ')'
    final arr = effectiveColor.split(',').map((e) => e.trim()).toList();
    return Color.fromRGBO(int.parse(arr[0]), int.parse(arr[1]), int.parse(arr[2]), double.parse(arr[3]));
  }

  if (colorString.startsWith('inherit')) {
    return originalColor ?? Colors.black;
  }

  if (!colorString.startsWith('#')) {
    throw UnsupportedError('Color code not supported');
  }

  return colorString.toColor() ?? originalColor ?? Colors.black;
}
