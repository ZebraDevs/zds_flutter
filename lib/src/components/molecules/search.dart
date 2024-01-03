import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../zds_flutter.dart';

/// Variants of [ZdsSearchField].
enum ZdsSearchFieldVariant {
  /// Creates a Search field with a border on all edges of color `ZetaColors.warm.60`.
  outlined,

  /// Creates a Search field with a box shadow around the edges with a radius of 4.
  ///
  ///  Shadow color defaults to [CardTheme.shadowColor] which can be changed in [ThemeData].
  elevated,
}

/// A search field that can be used in a Form.
///
/// This component can be used to update search results in two ways. [onChange] can be used to update the search
/// results as the user types their query without needing to be submitted through the press of a button. If the search
/// requires a lookup that will take time, you can instead only use [onSubmit] to only query results when the user
/// presses the search button on their keyboard.
///
/// See also:
///
///  * [ZdsSearchAppBar], an appBar that uses this component.
///  * [ZdsEmpty], which can be used to show a no results message.
class ZdsSearchField extends StatelessWidget {
  /// A search field that can be used in a form.
  const ZdsSearchField({
    super.key,
    this.textFormFieldKey,
    this.variant = ZdsSearchFieldVariant.elevated,
    this.onChange,
    this.initValue,
    this.hintText,
    this.onSubmit,
    this.focusNode,
    this.padding = const EdgeInsets.all(12),
    this.suffixIcon,
    this.controller,
    this.inputAction = TextInputAction.search,
  });

  /// The Key to use for the underlying [TextFormField].
  final Key? textFormFieldKey;

  /// Which variant to use.
  ///
  /// Defaults to [ZdsSearchFieldVariant.elevated].
  final ZdsSearchFieldVariant variant;

  /// Optional pre-filled text.
  ///
  /// If null, [hintText] will be shown instead.
  final String? initValue;

  /// Hint text that will appear when the user hasn't written anything in the search field.
  final String? hintText;

  /// Callback called whenever the search field's text changes.
  final void Function(String value)? onChange;

  /// Callback called whenever the user presses the 'Search' button on their keyboard.
  final void Function(String value)? onSubmit;

  /// The focusNode for the search field.
  final FocusNode? focusNode;

  /// Empty space to inscribe around this widget.
  ///
  /// Defaults to EdgeInsets.all(12).
  final EdgeInsets padding;

  /// A widget to show at the end of the search field, after the editable text area.
  ///
  /// Typically an [Icon] or an [IconButton].
  final Widget? suffixIcon;

  /// The input action that will be shown on the keyboard when the user interacts with this search field.
  ///
  /// Defaults to [TextInputAction.search].
  final TextInputAction inputAction;

  /// A controller that can be used to notify listeners when the text changes.
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData defaultTheme = Theme.of(context);
    final zetaColors = Zeta.of(context).colors;
    final ThemeData effectiveTheme = defaultTheme.zdsSearchThemeData(defaultTheme, variant, zetaColors);
    return Theme(
      data: effectiveTheme,
      child: Padding(
        padding: padding,
        child: ZdsCard(
          padding: EdgeInsets.zero,
          backgroundColor: effectiveTheme.colorScheme.surface,
          child: Semantics(
            excludeSemantics: true,
            onSetText: (value) => {
              controller?.text = value,
              onChange?.call(value),
            },
            label: (controller != null && controller!.text.isNotEmpty) ? controller!.text : hintText,
            child: TextFormField(
              style: effectiveTheme.textTheme.bodyLarge?.copyWith(color: effectiveTheme.colorScheme.onSurface),
              autocorrect: false,
              textInputAction: inputAction,
              focusNode: focusNode,
              controller: controller,
              initialValue: controller == null ? initValue : null,
              onChanged: onChange,
              onFieldSubmitted: onSubmit,
              decoration: InputDecoration(
                constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
                hintText: hintText,
                prefixIcon: effectiveTheme.prefixIcon,
                contentPadding: EdgeInsets.zero,
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Key?>('textFormFieldKey', textFormFieldKey))
      ..add(EnumProperty<ZdsSearchFieldVariant>('variant', variant))
      ..add(StringProperty('initValue', initValue))
      ..add(StringProperty('hintText', hintText))
      ..add(ObjectFlagProperty<void Function(String value)?>.has('onChange', onChange))
      ..add(ObjectFlagProperty<void Function(String value)?>.has('onSubmit', onSubmit))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding))
      ..add(EnumProperty<TextInputAction>('inputAction', inputAction))
      ..add(DiagnosticsProperty<TextEditingController?>('controller', controller));
  }
}
