import 'package:flutter/material.dart';

/// A class representing a text overlay.
///
/// This class contains properties for the text overlay, including its ID, text widget,
/// position, and font size.
class TextOverlay {
  /// Creates a [TextOverlay] with the given properties.
  ///
  /// The [id] parameter is required and represents the unique identifier for the text overlay.
  /// The [text] parameter is required and represents the text widget to be displayed.
  /// The [position] parameter is required and represents the position of the text overlay.
  /// The [fontSize] parameter is optional and defaults to 20.0.
  TextOverlay({
    required this.id,
    required this.text,
    required this.position,
    this.fontSize = 20.0,
  });

  /// The unique identifier for the text overlay.
  final int id;

  /// The text widget to be displayed as an overlay.
  Widget text;

  /// The position of the text overlay on the screen.
  Offset position;

  /// The font size of the text overlay.
  double fontSize;
}
