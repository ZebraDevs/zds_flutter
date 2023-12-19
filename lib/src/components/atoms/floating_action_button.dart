import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum _FloatingActionButtonType { regular, extended }

/// Widget that creates an FAB following Zds theming.
/// Note that MD3 introduced a new FAB not yet implemented in Flutter, so this integration might change in the future
///
/// A regular FAB will always require an [icon] to be given, while this is optional for extended FABs.
/// This is because extended FABs require a `label` to be given and make the icon optional
///
/// Flutter does not currently support shrinking or extending an extended FAB with integrated functions as is possible
/// on Android. It is possible that those functions will be integrated when Flutter FABs are updated to MD3. Until then,
/// an example of how to shrink on scroll is given in the example button.dart page. I do not recommend doing this
/// alternative method as, visually speaking, the result is not optimal (might be achievable with further fine tuning).
class ZdsFloatingActionButton extends StatelessWidget {
  /// Creates a circular floating action button.
  ///
  /// The [icon] argument must not be null.
  const ZdsFloatingActionButton({
    required this.icon,
    super.key,
    this.tooltip,
    this.onPressed,
  })  : _floatingActionButtonType = _FloatingActionButtonType.regular,
        _extendedLabel = null,
        _extendedIconLabelSpacing = null,
        _extendedPadding = null;

  /// Creates a wider [StadiumBorder]-shaped floating action button with a [label] and an optional [icon].
  ///
  /// The [label] argument, usually a [Text], must not be null.
  const ZdsFloatingActionButton.extended({
    required Widget label,
    super.key,
    this.icon,
    this.tooltip,
    double? extendedIconLabelSpacing,
    EdgeInsetsGeometry? extendedPadding,
    this.onPressed,
  })  : _floatingActionButtonType = _FloatingActionButtonType.extended,
        _extendedLabel = label,
        _extendedIconLabelSpacing = extendedIconLabelSpacing,
        _extendedPadding = extendedPadding;

  /// An icon to show in the FAB.
  ///
  /// If using [ZdsFloatingActionButton] this is required.
  final Widget? icon;

  /// A function called whenever the user taps on the FAB.
  final VoidCallback? onPressed;

  /// Text that describes what will occur when the button is pressed, displayed when the user long-presses
  /// on the button or is using Talkback or VoiceOver.
  ///
  /// For more information, see [Semantics].
  final String? tooltip;

  final Widget? _extendedLabel;

  final double? _extendedIconLabelSpacing;

  final EdgeInsetsGeometry? _extendedPadding;

  final _FloatingActionButtonType _floatingActionButtonType;

  @override
  Widget build(BuildContext context) {
    switch (_floatingActionButtonType) {
      case _FloatingActionButtonType.regular:
        return FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          tooltip: tooltip,
          child: icon,
        );
      case _FloatingActionButtonType.extended:
        return FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          label: _extendedLabel!,
          icon: icon,
          tooltip: tooltip,
          extendedIconLabelSpacing: _extendedIconLabelSpacing,
          extendedPadding: _extendedPadding,
          extendedTextStyle: Theme.of(context).textTheme.bodyMedium,
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed))
      ..add(StringProperty('tooltip', tooltip));
  }
}
