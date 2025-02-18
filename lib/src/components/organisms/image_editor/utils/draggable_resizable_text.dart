import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/text_overlay.dart';

/// A widget that allows a text overlay to be draggable and resizable.
///
/// This widget provides functionality to drag and resize a text overlay on the screen.
/// It also allows the text overlay to be deleted by a long press.
class DraggableResizableText extends StatefulWidget {
  /// Creates a [DraggableResizableText] widget.
  ///
  /// The [textOverlay] parameter is required and represents the text overlay to be manipulated.
  /// The [onDelete] parameter is required and is called when the text overlay is long-pressed.
  const DraggableResizableText({
    super.key,
    required this.textOverlay,
    required this.onDelete,
  });

  /// The text overlay to be displayed and manipulated.
  final TextOverlay textOverlay;

  /// Callback function to handle the deletion of the text overlay.
  final void Function(int id) onDelete;
  @override
  State<DraggableResizableText> createState() => _DraggableResizableTextState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TextOverlay>('textOverlay', textOverlay))
      ..add(ObjectFlagProperty<void Function(int id)>.has('onDelete', onDelete));
  }
}

class _DraggableResizableTextState extends State<DraggableResizableText> {
  /// The current position of the text overlay.
  late Offset _position;
  @override
  void initState() {
    super.initState();
    _position = widget.textOverlay.position;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        onLongPress: () {
          widget.onDelete(widget.textOverlay.id);
        },
        child: widget.textOverlay.text,
      ),
    );
  }
}
