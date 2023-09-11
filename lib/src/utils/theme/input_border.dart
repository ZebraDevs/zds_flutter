import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// An extension of [InputDecoration] that applies Zds styling.
///
/// This can be passed to [TextField] and [TextFormField] to apply Zds styling to these widgets.
///
/// See also:
///
///  * [InputDecoration], which ZdsInputDecoration extends.
///  * [ZdsDateTimePicker], which should use ZdsInputDecoration.
class ZdsInputDecoration extends InputDecoration {
  /// An extension of [InputDecoration] that applies Zds styling.
  ZdsInputDecoration({
    super.icon,
    String? labelText,
    super.labelStyle,
    super.helperText,
    super.helperStyle,
    super.helperMaxLines,
    super.hintText,
    super.hintStyle,
    super.hintTextDirection,
    super.hintMaxLines,
    super.errorText,
    super.errorStyle,
    super.errorMaxLines,
    super.floatingLabelBehavior,
    super.isCollapsed,
    super.isDense,
    super.contentPadding,
    super.prefixIcon,
    super.prefixIconConstraints,
    Widget? prefix,
    super.prefixText,
    super.prefixStyle,
    Widget? suffixIcon,
    Widget? suffix,
    super.suffixText,
    super.suffixStyle,
    super.suffixIconConstraints,
    super.counter,
    super.counterText,
    super.counterStyle,
    super.filled,
    super.fillColor,
    super.focusColor,
    super.hoverColor,
    super.errorBorder,
    super.focusedBorder,
    super.focusedErrorBorder,
    super.disabledBorder,
    super.enabledBorder,
    super.border,
    super.enabled,
    super.semanticCounterText,
    super.alignLabelWithHint,
    bool? mandatory,
    String? semanticsLabel,
    EdgeInsets suffixPadding = const EdgeInsets.only(left: 16),
    EdgeInsets prefixPadding = const EdgeInsets.only(right: 16),
  }) : super(
          label: (labelText?.isNotEmpty ?? false)
              ? (mandatory ?? false)
                  ? Row(
                      children: [
                        Text(
                          labelText ?? '',
                          style: labelStyle,
                          semanticsLabel: semanticsLabel,
                        ),
                        Text(
                          ' *',
                          style: TextStyle(color: ZdsColors.red),
                        ).excludeSemantics(),
                      ],
                    )
                  : Text(
                      labelText ?? '',
                      style: labelStyle,
                      semanticsLabel: semanticsLabel,
                    )
              : null,
          prefix: prefixText == null && prefixIcon == null ? Padding(padding: prefixPadding, child: prefix) : null,
          suffixIcon: suffixIcon != null ? Padding(padding: suffixPadding, child: suffixIcon) : null,
          suffix: suffixText == null && suffixIcon == null ? Padding(padding: suffixPadding, child: suffix) : null,
        );

  /// An extension of [InputDecoration] that applies Zds styling with no label.
  factory ZdsInputDecoration.withNoLabel({
    Widget? icon,
    String? helperText,
    TextStyle? helperStyle,
    int? helperMaxLines,
    String? hintText,
    TextStyle? hintStyle,
    TextDirection? hintTextDirection,
    int? hintMaxLines,
    String? errorText,
    TextStyle? errorStyle,
    int? errorMaxLines,
    FloatingLabelBehavior? floatingLabelBehavior,
    bool isCollapsed = false,
    bool? isDense,
    Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
    Widget? prefix,
    String? prefixText,
    TextStyle? prefixStyle,
    Widget? suffixIcon,
    Widget? suffix,
    String? suffixText,
    TextStyle? suffixStyle,
    BoxConstraints? suffixIconConstraints,
    Widget? counter,
    String? counterText,
    TextStyle? counterStyle,
    bool? filled,
    Color? fillColor,
    Color? focusColor,
    Color? hoverColor,
    InputBorder? errorBorder,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? border,
    bool enabled = true,
    String? semanticCounterText,
    bool? alignLabelWithHint,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsets suffixPadding = const EdgeInsets.only(left: 16),
    EdgeInsets prefixPadding = const EdgeInsets.only(right: 16),
  }) {
    return ZdsInputDecoration(
      icon: icon,
      helperText: helperText,
      helperStyle: helperStyle,
      helperMaxLines: helperMaxLines,
      hintText: hintText,
      hintStyle: hintStyle,
      hintTextDirection: hintTextDirection,
      hintMaxLines: hintMaxLines,
      errorText: errorText,
      errorStyle: errorText != null && errorText.isEmpty ? const TextStyle(fontSize: 0, height: 0) : errorStyle,
      errorMaxLines: errorMaxLines,
      floatingLabelBehavior: floatingLabelBehavior,
      isCollapsed: isCollapsed,
      isDense: isDense,
      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixIconConstraints,
      prefix: prefix,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefixPadding: prefixPadding,
      suffixIcon: suffixIcon,
      suffix: suffix,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      suffixPadding: suffixPadding,
      suffixIconConstraints: suffixIconConstraints,
      counter: counter,
      counterText: counterText,
      counterStyle: counterStyle,
      filled: filled,
      fillColor: fillColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      enabled: enabled,
      semanticCounterText: semanticCounterText,
      alignLabelWithHint: alignLabelWithHint,
      disabledBorder: disabledBorder ??
          const ZdsInputBorder(
            space: 2,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      border: border ??
          const ZdsInputBorder(
            space: 2,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      focusedBorder: focusedBorder ??
          const ZdsInputBorder(
            space: 2,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      enabledBorder: enabledBorder ??
          const ZdsInputBorder(
            space: 2,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      errorBorder: errorBorder ??
          ZdsInputBorder(
            space: 2,
            borderSide: BorderSide(color: ZdsColors.red),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
      focusedErrorBorder: focusedErrorBorder ??
          ZdsInputBorder(
            space: 2,
            borderSide: BorderSide(color: ZdsColors.red),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 19),
    );
  }
}
