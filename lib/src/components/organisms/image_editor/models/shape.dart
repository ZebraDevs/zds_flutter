import 'dart:ui';

/// Enum for types of shapes.
///
/// This enum defines the different types of shapes that can be drawn.
enum ShapeType {
  /// A square shape.
  square,

  /// A circle shape.
  circle,

  /// A line shape.
  line,

  /// An arrow shape.
  arrow
}

/// Model class for a shape.
///
/// This class represents a shape with a specific type, start and end points, and color.
class Shape {
  /// Creates a [Shape] with the given type, start and end points, and color.
  ///
  /// The [type] parameter specifies the type of the shape.
  /// The [start] parameter specifies the starting point of the shape.
  /// The [end] parameter specifies the ending point of the shape.
  /// The [color] parameter specifies the color of the shape.
  Shape({
    required this.type,
    required this.start,
    required this.end,
    required this.color,
  });

  /// The type of the shape.
  final ShapeType type;

  /// The starting point of the shape.
  final Offset start;

  /// The ending point of the shape.
  final Offset end;

  /// The color of the shape.
  final Color color;
}
