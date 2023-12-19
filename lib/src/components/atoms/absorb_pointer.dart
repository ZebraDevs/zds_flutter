import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that absorbs pointers during hit testing.
///
/// When [absorbing] is true, this widget prevents its subtree from receiving
/// pointer events by terminating hit testing at itself. It still consumes space
/// during layout and paints its child as usual. It just prevents its children
/// from being the target of located events, because it returns true from
/// [RenderBox.hitTest].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=65HoWqBboI8}
///
/// {@tool dartpad}
/// The following sample has an [AbsorbPointer] widget wrapping the button on
/// top of the stack, which absorbs pointer events, preventing its child button
/// __and__ the button below it in the stack from receiving the pointer events.
///
/// ** See code in examples/api/lib/widgets/basic/absorb_pointer.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [IgnorePointer], which also prevents its children from receiving pointer
///    events but is itself invisible to hit testing.
class ZdsAbsorbPointer extends StatelessWidget {
  /// Creates a widget that absorbs pointers during hit testing.
  ///
  /// The [absorbing] argument must not be null.
  const ZdsAbsorbPointer({
    required this.child,
    super.key,
    this.absorbing = true,
    this.duration = const Duration(milliseconds: 250),
  });

  /// Whether this widget absorbs pointers during hit testing.
  ///
  /// Regardless of whether this render object absorbs pointers during hit
  /// testing, it will still consume space during layout and be visible during
  /// painting.
  final bool absorbing;

  /// The widget whose events should be prevented
  final Widget child;

  /// Opacity duration
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: absorbing,
      child: AnimatedOpacity(
        duration: duration,
        opacity: absorbing ? 0.4 : 1,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Duration>('duration', duration))
      ..add(DiagnosticsProperty<bool>('absorbing', absorbing));
  }
}
