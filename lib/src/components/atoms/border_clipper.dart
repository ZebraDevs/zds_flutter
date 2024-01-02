import 'package:flutter/material.dart';

/// A custom clipper that allows you to clip with different offsets on each side.
///
/// This `ZdsBorderClipper` class extends `CustomClipper<Path>` and
/// can be used to create a custom [Path] for a `ClipPath` widget with distinct border clip lengths.
///
/// All the four sides (parameters: `top`, `bottom`, `left`, `right`) have to be provided upon creating an object.
/// These parameters represent the offsets from the corresponding sides.
///
/// If any of the insets (parameters) change, the clipping area will be recalculated.
///
/// # Example
/// ```
/// ZdsBorderClipper clipper = ZdsBorderClipper(
///   top: 10,
///   bottom: 10,
///   left: 10,
///   right: 10,
/// );
/// ClipPath(
///   clipper: clipper,
///   child: YourChildWidget(),
/// );
/// ```
@immutable
class ZdsBorderClipper extends CustomClipper<Path> {
  /// Constructor for ZdsBorderClipper.
  const ZdsBorderClipper({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  /// Top border clip length.
  final double top;

  /// Bottom border clip length.
  final double bottom;

  /// Left border clip length.
  final double left;

  /// Right border clip length.
  final double right;

  /// Create a new path using the parameters provided in the constructor.
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(left, top)
      ..lineTo(size.width - right, top)
      ..lineTo(size.width - right, size.height - bottom)
      ..lineTo(left, size.height - bottom)
      ..close();
  }

  /// Reclip only if any of the inset parameters have changed.
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper is! ZdsBorderClipper ||
        oldClipper.top != top ||
        oldClipper.bottom != bottom ||
        oldClipper.left != left ||
        oldClipper.right != right;
  }
}
