import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Corner attributes for the [ZdsDashedLine].
class ZdsDashedLineCorner {
  /// Specify the size of each rounded corner.
  const ZdsDashedLineCorner({
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomRight = 0,
    this.bottomLeft = 0,
  });

  /// Set all rounded corners to one size.
  const ZdsDashedLineCorner.all(double radius)
      : topLeft = radius,
        topRight = radius,
        bottomRight = radius,
        bottomLeft = radius;

  /// Corner radius for top left corner.
  final double topLeft;

  /// Corner radius for top right corner.
  final double topRight;

  /// Corner radius for bottom right corner.
  final double bottomRight;

  /// Corner radius for bottom left corner.
  final double bottomLeft;
}

/// A widget for creating dashed line or a container
///
/// [ZdsDashedLine] provides developers with the ability to create dashed lines. It also supports creating a dashed
/// border for a [Widget]. Support for controlling the thickness, spacing, and corners of the dotted border.
///
///  ```dart
/// ZdsDashedLine(
///   corner: const ZdsDashedLineCorner.all(8),
///   color: Colors.green,
///   strokeWidth: 1.5,
///   child: SizedBox(
///     height: 200,
///     width: 200,
///   ),
/// )
/// ```
///
///
/// This widget can be used as dashed line or dashed container. When supplied with [height] or [child] it will be a
/// Container.
class ZdsDashedLine extends StatefulWidget {
  /// A widget for creating dashed line or a container
  ///
  /// [color], [strokeWidth], [dottedLength], and [space] must not be null.
  const ZdsDashedLine({
    super.key,
    this.child,
    this.color,
    this.height,
    this.width,
    this.dottedLength = 5.0,
    this.space = 3.0,
    this.strokeWidth = 1.0,
    this.corner,
  }) : assert(
          width != null || height != null || child != null,
          'Either width, height, or child must not be null else nothing would be rendered.',
        );

  /// Dotted line color.
  ///
  /// Defaults to [ColorScheme.onSurface].
  final Color? color;

  /// Height.
  ///
  /// If there is only [height] and no [width], you will get a dotted line in the vertical direction. If there are both
  /// [width] and [height], you will get a dotted border.
  final double? height;

  /// Width.
  ///
  /// If there is only [width] and no [height], you will get a dotted line in the horizontal direction. If there are
  /// both [width] and [height], you will get a dotted border.
  final double? width;

  /// The thickness of the dotted line.
  ///
  /// Defaults to 1.0.
  final double strokeWidth;

  /// The length of each small segment in the dotted line.
  ///
  /// Defaults to 5.0.
  final double dottedLength;

  /// The distance between each segment in the dotted line.
  ///
  /// Defaults to 3.0.
  final double space;

  /// The corners of the dotted border. See [ZdsDashedLineCorner] for details.
  final ZdsDashedLineCorner? corner;

  /// If [child] is set, [ZdsDashedLine] will serve as the dotted border of [child].
  /// At this time, [width] and [height] will no longer be valid.
  final Widget? child;

  @override
  ZdsDashedLineState createState() => ZdsDashedLineState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('strokeWidth', strokeWidth))
      ..add(DoubleProperty('dottedLength', dottedLength))
      ..add(DoubleProperty('space', space))
      ..add(DiagnosticsProperty<ZdsDashedLineCorner?>('corner', corner));
  }
}

/// State for [ZdsDashedLine].
class ZdsDashedLineState extends State<ZdsDashedLine> {
  static bool _isEmpty(double? d) {
    return d == null || d == 0.0;
  }

  double? _childWidth;
  double? _childHeight;
  final GlobalKey _childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (_isEmpty(widget.width) && _isEmpty(widget.height) && widget.child == null) return const SizedBox();
    if (widget.child != null) {
      tryToGetChildSize();
      final List<Widget> children = <Widget>[
        Container(
          clipBehavior: widget.corner == null ? Clip.none : Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.corner?.topLeft ?? 0.0),
              topRight: Radius.circular(widget.corner?.topRight ?? 0.0),
              bottomLeft: Radius.circular(widget.corner?.bottomLeft ?? 0.0),
              bottomRight: Radius.circular(widget.corner?.bottomRight ?? 0.0),
            ),
          ),
          key: _childKey,
          child: widget.child,
        ),
      ];

      if (_childWidth != null && _childHeight != null) {
        children.add(dashPath(width: _childWidth!, height: _childHeight!));
      }

      return Stack(children: children);
    } else {
      return dashPath(width: widget.width!, height: widget.height!);
    }
  }

  /// Attempts to get the [_childWidth] and [_childHeight] of the child to be wrapped with a dashed line.
  void tryToGetChildSize() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      try {
        final RenderBox? box = _childKey.currentContext?.findRenderObject() as RenderBox?;
        final double tempWidth = box?.size.width ?? 0.0;
        final double tempHeight = box?.size.height ?? 0.0;
        final bool needUpdate = tempWidth != _childWidth || tempHeight != _childHeight;
        if (needUpdate) {
          setState(() {
            _childWidth = tempWidth;
            _childHeight = tempHeight;
          });
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  /// Creates a dashed path line.
  CustomPaint dashPath({required double width, required double height}) {
    return CustomPaint(
      size: Size(_isEmpty(width) ? widget.strokeWidth : width, _isEmpty(height) ? widget.strokeWidth : height),
      foregroundPainter: _DashedLinePainter()
        ..color = widget.color ?? Theme.of(context).colorScheme.onSurface
        ..dottedLength = widget.dottedLength
        ..space = widget.space
        ..strokeWidth = widget.strokeWidth
        ..corner = widget.corner
        ..isShape = !_isEmpty(height) && !_isEmpty(width),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  late Color color;
  double dottedLength = 5;
  double space = 3;
  double strokeWidth = 1;
  bool isShape = false;
  ZdsDashedLineCorner? corner;
  Radius topLeft = Radius.zero;
  Radius topRight = Radius.zero;
  Radius bottomRight = Radius.zero;
  Radius bottomLeft = Radius.zero;

  @override
  void paint(Canvas canvas, Size size) {
    final bool isHorizontal = size.width > size.height;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..filterQuality = FilterQuality.high
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (!isShape) {
      /// line
      final double length = isHorizontal ? size.width : size.height;
      final double count = length / (dottedLength + space);
      if (count < 2.0) return;
      Offset startOffset = Offset.zero;
      for (int i = 0; i < count.toInt(); i++) {
        canvas.drawLine(
          startOffset,
          startOffset.translate(isHorizontal ? dottedLength : 0, isHorizontal ? 0 : dottedLength),
          paint,
        );
        startOffset =
            startOffset.translate(isHorizontal ? (dottedLength + space) : 0, isHorizontal ? 0 : (dottedLength + space));
      }
    } else {
      /// shape
      final Path path = Path()
        ..addRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width,
            size.height,
            topLeft: Radius.circular(corner?.topLeft ?? 0.0),
            topRight: Radius.circular(corner?.topRight ?? 0.0),
            bottomLeft: Radius.circular(corner?.bottomLeft ?? 0.0),
            bottomRight: Radius.circular(corner?.bottomRight ?? 0.0),
          ),
        );

      final Path draw = buildDashPath(path, dottedLength, space);
      canvas.drawPath(draw, paint);
    }
  }

  Path buildDashPath(Path path, double dottedLength, double space) {
    final Path r = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double start = 0;
      while (start < metric.length) {
        final double end = start + dottedLength;
        r.addPath(metric.extractPath(start, end), Offset.zero);
        start = end + space;
      }
    }
    return r;
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) {
    return true;
  }
}
