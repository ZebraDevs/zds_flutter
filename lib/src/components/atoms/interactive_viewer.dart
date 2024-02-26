import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom interactive viewer widget.
///
/// This widget allows interaction with its child widget, including scaling
/// between a defined minimum and maximum scale.
class ZdsInteractiveViewer extends StatefulWidget {
  /// Creates a new instance of ZdsInteractiveViewer.
  ///
  /// Requires a [child] widget. Optionally, [minScale] and [maxScale] can be
  /// provided to define the scale limits. If not provided, the defaults are
  /// 0.8 and 2.5 respectively.
  const ZdsInteractiveViewer({
    super.key,
    required this.child,
    this.minScale = 0.8,
    this.maxScale = 2.5,
    this.clipBehavior = Clip.hardEdge,
  });

  /// The child widget to be interacted with.
  final Widget child;

  /// The minimum scale to be applied to the child widget.
  ///
  /// Defaults to 0.8.
  final double minScale;

  /// The maximum scale to be applied to the child widget.
  ///
  /// Defaults to 2.5.
  final double maxScale;

  /// The clip behavior of the child widget.
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  @override
  // ignore: library_private_types_in_public_api
  _ZdsInteractiveViewerState createState() => _ZdsInteractiveViewerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('minScale', minScale))
      ..add(DoubleProperty('maxScale', maxScale))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

/// The state associated with a [ZdsInteractiveViewer] widget.
///
/// This class manages the interaction and transformation of the child widget
/// in a [ZdsInteractiveViewer].
class _ZdsInteractiveViewerState extends State<ZdsInteractiveViewer> {
  late TransformationController _transformationController;
  double _scale = 1;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      clipBehavior: widget.clipBehavior,
      transformationController: _transformationController,
      minScale: widget.minScale,
      maxScale: widget.maxScale,
      onInteractionEnd: (details) {
        _scale = _transformationController.value.getMaxScaleOnAxis();
      },
      child: GestureDetector(
        onDoubleTap: _handleDoubleTap,
        child: widget.child,
      ),
    );
  }

  /// Handles the double tap gesture.
  ///
  /// If the current scale is greater than 1.0, it resets the transformation.
  /// Otherwise, it doubles the current scale.
  void _handleDoubleTap() {
    if (_scale == 1.0) {
      _scale = 2.0;
      _transformationController.value = Matrix4.identity()..scale(2.0, 2);
    } else {
      _scale = 1.0;
      _transformationController.value = Matrix4.identity();
    }
  }
}
