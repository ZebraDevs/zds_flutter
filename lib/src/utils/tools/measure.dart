import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class _MeasureSizeRenderObject extends RenderProxyBox {
  _MeasureSizeRenderObject(this.onChange);
  Size oldSize = Size.zero;

  final void Function(Size size) onChange;

  @override
  void performLayout() {
    super.performLayout();

    final Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Size>('oldSize', oldSize))
      ..add(ObjectFlagProperty<void Function(Size size)>.has('onChange', onChange));
  }
}

/// Widget to measure size of rendered object.
class MeasureSizeWidget extends SingleChildRenderObjectWidget {
  /// Constructs a [MeasureSizeWidget].
  const MeasureSizeWidget({
    required this.onChange,
    required Widget super.child,
    super.key,
  });

  /// Callback function called whenever the size of the rendered child changes.
  final void Function(Size size) onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MeasureSizeRenderObject(onChange);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function(Size size)>.has('onChange', onChange));
  }
}

/// Widget to measure size of rendered object.
///
/// Measurement is performed after first build, and this value is returned using the builder callback function.
class MeasureSize extends StatefulWidget {
  /// Constructs a [MeasureSize].
  const MeasureSize({required this.builder, super.key, this.child});

  /// Child to be measured.
  final Widget? child;

  /// Builder function with size to be rendered.
  final Widget Function(BuildContext, Size size) builder;

  @override
  MeasureSizeState createState() => MeasureSizeState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Widget Function(BuildContext p1, Size size)>.has('builder', builder));
  }
}

/// State for [MeasureSize].
class MeasureSizeState extends State<MeasureSize> {
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    if (_size != Size.zero) {
      return widget.builder(context, _size);
    }
    return MeasureSizeWidget(
      onChange: (Size newSize) => setState(() => _size = newSize),
      child: widget.child!,
    );
  }
}
