import 'package:flutter/material.dart';

import '../models/shape.dart';

/// A custom painter class for drawing various shapes on a canvas.
///
/// This class extends [CustomPainter] and is used to draw shapes such as squares,
/// circles, lines, and arrows on a canvas. It takes a list of [Shape] objects and
/// an image as input and draws the shapes on the canvas.
///
/// The shapes are drawn based on their type and properties such as start and end
/// points, and color.
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   painter: ShapePainter(
///     shapes: shapesList,
///     image: backgroundImage,
///   ),
/// )
/// ```
///
/// See also:
/// - [Shape], which defines the properties of a shape.
/// - [ShapeType], which defines the types of shapes that can be drawn.
class ShapePainter extends CustomPainter {
  /// Creates a [ShapePainter] with the given list of shapes and background image.
  ShapePainter({required this.shapes, this.previewShape});

  /// A list of shapes to be drawn on the canvas.
  final List<Shape> shapes;

  /// The shape being previewed during interaction.
  final Shape? previewShape;

  /// Paints the shapes on the given canvas.
  ///
  /// This method is called whenever the custom painter needs to paint.
  /// It iterates through the list of shapes and draws each shape based on its type.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final shape in shapes) {
      paint.color = shape.color;
      _drawShape(canvas, paint, shape);
    }

    // Draw the preview shape if it exists
    if (previewShape != null) {
      paint.color = previewShape!.color.withValues(alpha: 0.5); // Semi-transparent preview
      _drawShape(canvas, paint, previewShape!);
    }
  }

  /// Draws a shape on the canvas based on its type.
  void _drawShape(Canvas canvas, Paint paint, Shape shape) {
    switch (shape.type) {
      case ShapeType.square:
        canvas.drawRect(Rect.fromPoints(shape.start, shape.end), paint);
      case ShapeType.circle:
        final radius = (shape.end - shape.start).distance / 2;
        final center = Offset(
          (shape.start.dx + shape.end.dx) / 2,
          (shape.start.dy + shape.end.dy) / 2,
        );
        canvas.drawCircle(center, radius, paint);
      case ShapeType.line:
        canvas.drawLine(shape.start, shape.end, paint);
      case ShapeType.arrow:
        _drawArrow(canvas, paint, shape.start, shape.end);
    }
  }

  /// Draws an arrow from the start point to the end point on the canvas.
  ///
  /// This method is used internally to draw arrows. It calculates the direction
  /// and the points for the arrowhead and draws the arrow on the canvas.
  void _drawArrow(Canvas canvas, Paint paint, Offset start, Offset end) {
    canvas.drawLine(start, end, paint);
    const arrowLength = 20.0;
    const arrowAngle = 25 * 3.14159 / 180;

    final angle = (end - start).direction;
    final arrowPoint1 = end - Offset.fromDirection(angle + arrowAngle, arrowLength);
    final arrowPoint2 = end - Offset.fromDirection(angle - arrowAngle, arrowLength);

    canvas
      ..drawLine(end, arrowPoint1, paint)
      ..drawLine(end, arrowPoint2, paint);
  }

  /// Determines whether the custom painter should repaint.
  ///
  /// This method is called to determine whether the custom painter should repaint
  /// when the widget is rebuilt. It returns true to indicate that the painter should repaint.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
