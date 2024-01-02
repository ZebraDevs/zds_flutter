import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A text input area with handle icon in the bottom right corner that can be used to resize the typing input area.
class ZdsResizableTextArea extends StatefulWidget {
  /// Constructs a [ZdsResizableTextArea].
  const ZdsResizableTextArea({
    super.key,
    this.textInputAction = TextInputAction.none,
    this.hintText,
    this.label,
    this.maxLines,
    this.height = 100,
    this.maxHeight = double.infinity,
    this.minHeight = 48,
    this.textStyle,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.enabled = true,
    this.footerText,
    this.decoration,
    this.semanticLabel,
  });

  /// The [textInputAction]'s input action button of keyboard of the text field/box
  ///
  /// Defaults to [TextInputAction.none].
  final TextInputAction textInputAction;

  /// The [height]'s height of the text field/box
  ///
  /// Defaults to 100.
  final double height;

  /// This is maximum height of the text field/box
  final double maxHeight;

  /// The minimum height of the text field.
  ///
  /// Defaults to 48 (1 line)
  final double minHeight;

  /// Hint text that will appear when the user hasn't written anything inside text area
  final String? hintText;

  /// The [label] that will be shown at the above of text area.
  final String? label;

  /// The [semanticLabel] that will be shown at the above of text area.
  final String? semanticLabel;

  /// This is the maximum number of lines that user can enter inside text area
  final int? maxLines;

  // The text style used for the text being edited.
  ///
  /// Defaults to [TextTheme.bodyMedium].
  final TextStyle? textStyle;

  /// A controller that can be used to notify listeners when the text changes.
  final TextEditingController? controller;

  /// Callback called whenever the resizable textarea's text changes.
  final ValueChanged<String>? onChanged;

  /// The focus node given to the text area.
  final FocusNode? focusNode;

  /// Whether the text is disabled.
  ///
  /// Defaults to true (editable).
  final bool enabled;

  /// shown at the bottom of the text editor
  final String? footerText;

  /// Input decoration used for underlying TextField.
  final InputDecoration? decoration;

  @override
  State<ZdsResizableTextArea> createState() => _ZdsResizableTextAreaState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<TextInputAction>('textInputAction', textInputAction))
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('maxHeight', maxHeight))
      ..add(DoubleProperty('minHeight', minHeight))
      ..add(StringProperty('hintText', hintText))
      ..add(StringProperty('label', label))
      ..add(StringProperty('semanticLabel', semanticLabel))
      ..add(IntProperty('maxLines', maxLines))
      ..add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle))
      ..add(DiagnosticsProperty<TextEditingController?>('controller', controller))
      ..add(ObjectFlagProperty<ValueChanged<String>?>.has('onChanged', onChanged))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(StringProperty('footerText', footerText))
      ..add(DiagnosticsProperty<InputDecoration?>('decoration', decoration));
  }
}

class _ZdsResizableTextAreaState extends State<ZdsResizableTextArea> {
  late double _height;
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey key = GlobalKey();

  TextEditingController get textEditingController {
    return widget.controller ?? _textEditingController;
  }

  @override
  void initState() {
    super.initState();
    _height = widget.height;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: _height,
              child: Semantics(
                excludeSemantics: true,
                enabled: widget.enabled,
                onSetText: (value) => {
                  textEditingController.text = value,
                  widget.onChanged?.call(value),
                },
                label: '${widget.label ?? widget.semanticLabel} ${textEditingController.text}',
                child: TextField(
                  textInputAction: widget.textInputAction,
                  style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
                  decoration: widget.decoration ??
                      ZdsInputDecoration(
                        labelText: widget.label,
                        hintText: widget.hintText,
                        fillColor: !widget.enabled ? zetaColors.surfaceDisabled : null,
                        filled: !widget.enabled,
                      ),
                  maxLines: widget.maxLines,
                  controller: textEditingController,
                  onChanged: widget.onChanged,
                  focusNode: widget.focusNode,
                  enabled: widget.enabled,
                  key: key,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 4,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.bottomRight,
                  height: 48,
                  width: 48,
                  child: Icon(
                    ZdsIcons.expand,
                    size: 18,
                    color: zetaColors.iconSubtle,
                  ).padding(4),
                ),
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _height += details.delta.dy;
                    // prevent overflow if height is more/less than available space
                    // Min height is 1 line
                    final double minLimit = (widget.minHeight / 2) * MediaQuery.of(context).devicePixelRatio + 24;
                    if (_height > widget.maxHeight) {
                      _height = widget.maxHeight;
                    } else if (_height < minLimit) {
                      _height = minLimit;
                    }
                  });
                },
              ),
            ),
          ],
        ),
        if (widget.footerText != null)
          Transform.translate(
            offset: const Offset(0, -8),
            child: Text(
              widget.footerText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: zetaColors.textDisabled),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GlobalKey<State<StatefulWidget>>>('key', key))
      ..add(DiagnosticsProperty<TextEditingController>('textEditingController', textEditingController));
  }
}
