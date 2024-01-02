import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// [ZdsConditionalWrapper] is a widget that conditionally wraps its [child] with a [wrapperBuilder]
/// based on the provided [condition].
///
/// If the [condition] is true, the [child] will be wrapped using [wrapperBuilder].
/// If the [condition] is false, the [child] will be rendered as-is.
class ZdsConditionalWrapper extends StatelessWidget {
  /// Creates an instance of [ZdsConditionalWrapper].
  ///
  /// The [condition], [child], and [wrapperBuilder] arguments must not be null.
  const ZdsConditionalWrapper({
    super.key,
    required this.condition,
    required this.child,
    required this.wrapperBuilder,
  });

  /// Indicates whether to wrap the [child] with the [wrapperBuilder] or not.
  final bool condition;

  /// The primary content of the widget which might be wrapped.
  final Widget child;

  /// A function that returns a widget wrapping the [child].
  ///
  /// This function is only invoked if [condition] is true.
  final Widget Function(Widget child) wrapperBuilder;

  @override
  Widget build(BuildContext context) {
    /// Renders the [child] wrapped by [wrapperBuilder] if [condition] is true.
    /// Otherwise, just renders the [child].
    return condition ? wrapperBuilder(child) : child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('condition', condition))
      ..add(ObjectFlagProperty<Widget Function(Widget child)>.has('wrapperBuilder', wrapperBuilder));
  }
}
