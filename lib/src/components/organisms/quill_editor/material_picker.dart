/// Material Color Picker

library material_colorpicker;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// The Color Picker which contains Material Design Color Palette.
class ZdsMaterialPicker extends StatefulWidget {
  /// Constructs a ZdsMaterialPicker.
  const ZdsMaterialPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.onPrimaryChanged,
    this.enableLabel = false,
    this.portraitOnly = false,
    this.height = 500,
    this.width = 300,
  });

  /// The height of the color picker.
  ///
  /// Defaults to 500.
  final double height;

  /// The width of the color picker.
  ///
  /// Defaults to 300.
  final double width;

  /// The color that is currently selected.
  final Color pickerColor;

  /// Called when the color is changed.
  final ValueChanged<Color> onColorChanged;

  /// Called when the primary color is changed.
  final ValueChanged<Color>? onPrimaryChanged;

  /// Whether to enable the label.
  final bool enableLabel;

  /// Whether to enable portrait mode only.
  final bool portraitOnly;

  @override
  State<StatefulWidget> createState() => _ZdsMaterialPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('width', width))
      ..add(ColorProperty('pickerColor', pickerColor))
      ..add(ObjectFlagProperty<ValueChanged<Color>>.has('onColorChanged', onColorChanged))
      ..add(ObjectFlagProperty<ValueChanged<Color>?>.has('onPrimaryChanged', onPrimaryChanged))
      ..add(DiagnosticsProperty<bool>('enableLabel', enableLabel))
      ..add(DiagnosticsProperty<bool>('portraitOnly', portraitOnly));
  }
}

class _ZdsMaterialPickerState extends State<ZdsMaterialPicker> {
  final List<List<Color>> _colorTypes = [
    [Colors.red, Colors.redAccent],
    [Colors.pink, Colors.pinkAccent],
    [Colors.purple, Colors.purpleAccent],
    [Colors.deepPurple, Colors.deepPurpleAccent],
    [Colors.indigo, Colors.indigoAccent],
    [Colors.blue, Colors.blueAccent],
    [Colors.lightBlue, Colors.lightBlueAccent],
    [Colors.cyan, Colors.cyanAccent],
    [Colors.teal, Colors.tealAccent],
    [Colors.green, Colors.greenAccent],
    [Colors.lightGreen, Colors.lightGreenAccent],
    [Colors.lime, Colors.limeAccent],
    [Colors.yellow, Colors.yellowAccent],
    [Colors.amber, Colors.amberAccent],
    [Colors.orange, Colors.orangeAccent],
    [Colors.deepOrange, Colors.deepOrangeAccent],
    [Colors.brown],
    [Colors.grey],
    [Colors.blueGrey],
    [Colors.black],
  ];

  List<Color> _currentColorType = [Colors.red, Colors.redAccent];
  Color _currentShading = Colors.transparent;

  List<Map<Color, String>> _shadingTypes(List<Color> colors) {
    final List<Map<Color, String>> result = [];

    for (final Color colorType in colors) {
      if (colorType == Colors.grey) {
        result.addAll(
          [50, 100, 200, 300, 350, 400, 500, 600, 700, 800, 850, 900]
              .map((int shade) => {Colors.grey[shade]!: shade.toString()})
              .toList(),
        );
      } else if (colorType == Colors.black || colorType == Colors.white) {
        result.addAll([
          {Colors.black: ''},
          {Colors.white: ''},
        ]);
      } else if (colorType is MaterialAccentColor) {
        result.addAll([100, 200, 400, 700].map((int shade) => {colorType[shade]!: 'A$shade'}).toList());
      } else if (colorType is MaterialColor) {
        result.addAll(
          [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]
              .map((int shade) => {colorType[shade]!: shade.toString()})
              .toList(),
        );
      } else {
        result.add({const Color(0x00000000): ''});
      }
    }

    return result;
  }

  @override
  void initState() {
    for (final List<Color> colors in _colorTypes) {
      _shadingTypes(colors).forEach((Map<Color, String> color) {
        if (widget.pickerColor.value == color.keys.first.value) {
          return setState(() {
            _currentColorType = colors;
            _currentShading = color.keys.first;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait || widget.portraitOnly;

    Widget colorList() {
      return Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        child: Container(
          margin: isPortrait ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(bottom: 10),
          width: isPortrait ? 60 : null,
          height: isPortrait ? null : 60,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? (Theme.of(context).brightness == Brightness.light)
                        ? Colors.grey[300]!
                        : Colors.black38
                    : Colors.black38,
                blurRadius: 10,
              ),
            ],
            border: isPortrait
                ? Border(
                    right: BorderSide(
                      color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey[300]! : Colors.black38,
                    ),
                  )
                : Border(
                    top: BorderSide(
                      color: (Theme.of(context).brightness == Brightness.light) ? Colors.grey[300]! : Colors.black38,
                    ),
                  ),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
            child: ListView(
              scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
              children: [
                if (isPortrait)
                  const Padding(padding: EdgeInsets.only(top: 7))
                else
                  const Padding(padding: EdgeInsets.only(left: 7)),
                ..._colorTypes.map((List<Color> colors) {
                  final Color colorType = colors[0];
                  return GestureDetector(
                    onTap: () {
                      widget.onPrimaryChanged?.call(colorType);
                      setState(() => _currentColorType = colors);
                    },
                    child: Container(
                      color: const Color(0x00000000),
                      padding:
                          isPortrait ? const EdgeInsets.fromLTRB(0, 7, 0, 7) : const EdgeInsets.fromLTRB(7, 0, 7, 0),
                      child: Align(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: colorType,
                            shape: BoxShape.circle,
                            boxShadow: _currentColorType == colors
                                ? [
                                    if (colorType == Theme.of(context).cardColor)
                                      BoxShadow(
                                        color: (Theme.of(context).brightness == Brightness.light)
                                            ? Colors.grey[300]!
                                            : Colors.black38,
                                        blurRadius: 10,
                                      )
                                    else
                                      BoxShadow(
                                        color: colorType,
                                        blurRadius: 10,
                                      ),
                                  ]
                                : null,
                            border: colorType == Theme.of(context).cardColor
                                ? Border.all(
                                    color: (Theme.of(context).brightness == Brightness.light)
                                        ? Colors.grey[300]!
                                        : Colors.black38,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (isPortrait)
                  const Padding(padding: EdgeInsets.only(top: 5))
                else
                  const Padding(padding: EdgeInsets.only(left: 5)),
              ],
            ),
          ),
        ),
      );
    }

    Widget shadingList() {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
        child: ListView(
          scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
          children: [
            if (isPortrait)
              const Padding(padding: EdgeInsets.only(top: 15))
            else
              const Padding(padding: EdgeInsets.only(left: 15)),
            ..._shadingTypes(_currentColorType).map((Map<Color, String> color) {
              final Color effectiveColor = color.keys.first;
              return GestureDetector(
                onTap: () {
                  setState(() => _currentShading = effectiveColor);
                  widget.onColorChanged(effectiveColor);
                },
                child: Container(
                  color: const Color(0x00000000),
                  margin: isPortrait ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(bottom: 10),
                  padding: isPortrait ? const EdgeInsets.fromLTRB(0, 7, 0, 7) : const EdgeInsets.fromLTRB(7, 0, 7, 0),
                  child: Align(
                    child: AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 500),
                      width: isPortrait
                          ? (_currentShading == effectiveColor ? 250 : 230)
                          : (_currentShading == effectiveColor ? 50 : 30),
                      height: isPortrait ? 50 : 220,
                      decoration: BoxDecoration(
                        color: effectiveColor,
                        boxShadow: _currentShading == effectiveColor
                            ? [
                                if ((effectiveColor == Colors.white) || (effectiveColor == Colors.black))
                                  BoxShadow(
                                    color: (Theme.of(context).brightness == Brightness.light)
                                        ? Colors.grey[300]!
                                        : Colors.black38,
                                    blurRadius: 10,
                                  )
                                else
                                  BoxShadow(
                                    color: effectiveColor,
                                    blurRadius: 10,
                                  ),
                              ]
                            : null,
                        border: (effectiveColor == Colors.white) || (effectiveColor == Colors.black)
                            ? Border.all(
                                color: (Theme.of(context).brightness == Brightness.light)
                                    ? Colors.grey[300]!
                                    : Colors.black38,
                              )
                            : null,
                      ),
                      child: widget.enableLabel
                          ? isPortrait
                              ? Row(
                                  children: [
                                    Text(
                                      '  ${color.values.first}',
                                      style: TextStyle(
                                        color: useWhiteForeground(effectiveColor) ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '#${effectiveColor.toString().replaceFirst('Color(0xff', '').replaceFirst(')', '').toUpperCase()}  ',
                                          style: TextStyle(
                                            color: useWhiteForeground(effectiveColor) ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: _currentShading == effectiveColor ? 1 : 0,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 16),
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      color.values.first,
                                      style: TextStyle(
                                        color: useWhiteForeground(effectiveColor) ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                )
                          : const SizedBox(),
                    ),
                  ),
                ),
              );
            }),
            if (isPortrait)
              const Padding(padding: EdgeInsets.only(top: 15))
            else
              const Padding(padding: EdgeInsets.only(left: 15)),
          ],
        ),
      );
    }

    if (isPortrait) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Row(
          children: <Widget>[
            colorList(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: shadingList(),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: widget.height,
        height: widget.width,
        child: Column(
          children: <Widget>[
            colorList(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: shadingList(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
