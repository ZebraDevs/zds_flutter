import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A [ListTile] with a [Checkbox]. In other words, a checkbox with a label.
///
/// The entire list tile is interactive: tapping anywhere in the tile toggles
/// the checkbox.
/// e.g.:
///
/// {@tool snippet}
/// ```dart
///  ZdsCheckboxListTile(
///   value: checkBoxListSelected,
///   onChanged: (value) => setState(() {
///     checkBoxListSelected = value!;
///   }),
///   title: Text('Approve'),
///  ),
/// ```
/// {@end-tool}
class ZdsCheckboxListTile extends StatelessWidget {
  /// Creates a combination of a list tile and a checkbox.
  ///
  /// The checkbox tile itself does not maintain any state. Instead, when the
  /// state of the checkbox changes, the widget calls the [onChanged] callback.
  /// Most widgets that use a checkbox will listen for the [onChanged] callback
  /// and rebuild the checkbox tile with a new [value] to update the visual
  /// appearance of the checkbox.
  ///
  /// The following arguments are required:
  ///
  /// * [value], which determines whether the checkbox is checked.
  /// * [onChanged], which is called when the value of the checkbox should
  ///   change. It can be set to null to disable the checkbox.
  /// * [title], which determines primary content of list tile.
  const ZdsCheckboxListTile({
    required this.value,
    required this.onChanged,
    required this.title,
    super.key,
    this.checkColor,
    this.checkboxSemanticLabel,
    this.subtitle,
    this.secondary,
    this.isThreeLine = false,
    this.selected,
    this.contentPadding,
    this.enabled,
    this.label,
  });

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Whether this checkbox is checked.
  final bool value;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox tile with the
  /// new value.
  ///
  /// If null, the checkbox will be displayed as disabled.
  ///
  /// {@tool snippet}
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// CheckboxListTile(
  ///   value: _throwShotAway,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue;
  ///     });
  ///   },
  ///   title: const Text('Throw away your shot'),
  /// )
  /// ```
  /// {@end-tool}
  final ValueChanged<bool?> onChanged;

  /// The color to use for the check icon when this checkbox is checked.
  ///
  /// Defaults to Color(0xFFFFFFFF).
  final Color? checkColor;

  /// {@macro flutter.material.checkbox.semanticLabel}
  final String? checkboxSemanticLabel;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// A widget to display on the opposite side of the tile from the checkbox.
  ///
  /// Typically an [Icon] widget.
  final Widget? secondary;

  /// Whether this list tile is intended to display three lines of text.
  ///
  /// If false, the list tile is treated as having one line if the subtitle is
  /// null and treated as having two lines if the subtitle is non-null.
  final bool isThreeLine;

  /// Whether to render icons and text in the [checkColor].
  ///
  /// No effort is made to automatically coordinate the [selected] state and the
  /// [value] state. To have the list tile appear selected when the checkbox is
  /// checked, pass the same value to both.
  ///
  /// Normally, this property is left to its default value, false.
  final bool? selected;

  /// Defines insets surrounding the tile's contents.
  ///
  /// This value will surround the [Checkbox], [title], [subtitle], and [secondary]
  /// widgets in [CheckboxListTile].
  ///
  /// When the value is null, the [contentPadding] is `EdgeInsets.symmetric(horizontal: 16.0)`.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the CheckboxListTile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [ListTile.onTap] callback is
  /// inoperative.
  final bool? enabled;

  ///Customised Semantic label
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      excludeSemantics: true,
      onTap: () => onChanged(!value),
      checked: value,
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        checkColor: checkColor,
        title: title,
        secondary: secondary,
        subtitle: subtitle,
        enabled: enabled,
        isThreeLine: isThreeLine,
        contentPadding: contentPadding,
        checkboxSemanticLabel: checkboxSemanticLabel,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('checkboxSemanticLabel', checkboxSemanticLabel))
      ..add(ColorProperty('checkColor', checkColor))
      ..add(ObjectFlagProperty<ValueChanged<bool?>?>.has('onChanged', onChanged))
      ..add(DiagnosticsProperty<bool?>('value', value))
      ..add(DiagnosticsProperty<bool>('isThreeLine', isThreeLine))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('contentPadding', contentPadding))
      ..add(DiagnosticsProperty<bool?>('enabled', enabled))
      ..add(StringProperty('label', label));
  }
}
