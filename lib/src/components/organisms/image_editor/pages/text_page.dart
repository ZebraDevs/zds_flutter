import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:text_editor/text_editor.dart';
import '../../../../../zds_flutter.dart';
import '../models/text_overlay.dart';
import '../utils/draggable_resizable_text.dart';
import '../utils/utils.dart';

/// A page that allows users to add and edit text overlays on an image.
///
/// This page provides tools for adding, editing, and positioning text overlays
/// on an image. Users can apply their changes and save the edited image.
class TextPage extends StatefulWidget {
  /// Creates a [TextPage] with the given image.
  ///
  /// The [image] parameter is required and represents the image to be edited.
  const TextPage({super.key, required this.image});

  /// The image to be edited.
  final Image image;
  @override
  State<TextPage> createState() => _TextPageState();
}

/// The state class for [TextPage].
///
/// This class manages the state of the text editing page, including the list
/// of text overlays and the screenshot controller.
class _TextPageState extends State<TextPage> {
  /// Indicates whether the user is currently editing text.
  bool isEditing = true;

  /// List of text overlays added to the image.
  final List<TextOverlay> _textOverlays = [];

  /// Counter for generating unique IDs for text overlays.
  int _overlayIdCounter = 0;

  /// Controller for capturing screenshots.
  final _screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ComponentStrings.of(context);
    final zetaColors = Zeta.of(context).colors;
    final backgroundColor = widget.image.color ?? zetaColors.primitives.pure.shade1000.withAlpha(110);

    return PopScope(
      canPop: false,
      child: Theme(
        data: ThemeData.dark(),
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(strings.get('TEXT', 'Text')),
                actions: appBarActions(
                  undo: () {
                    setState(_textOverlays.removeLast);
                  },
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                child: Center(
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Stack(
                      children: [
                        widget.image,
                        ..._textOverlays.map(
                          (overlay) => DraggableResizableText(
                            key: ValueKey(overlay.id),
                            textOverlay: overlay,
                            onDelete: _deleteText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Row(
                children: [
                  const Spacer(),
                  ZdsButton.text(
                    child: Text(strings.get('CANCEL', 'Cancel')),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ZdsButton(
                    child: Text(strings.get('APPLY', 'Apply')),
                    onTap: () {
                      unawaited(
                        _screenshotController.capture().then((value) {
                          if (value != null) {
                            Navigator.pop(context, value);
                          }
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (isEditing)
              Scaffold(
                backgroundColor: backgroundColor,
                body: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SafeArea(
                    child: TextEditor(
                      fonts: const [''],
                      onEditCompleted: (style, align, text) {
                        if (text.isNotEmpty) {
                          _addText(
                            Text(
                              text,
                              style: style,
                              textAlign: align,
                            ),
                          );
                        }
                        setState(() {
                          isEditing = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Adds a new text overlay to the image.
  ///
  /// The [text] parameter represents the text widget to be added as an overlay.
  void _addText(Widget text) {
    setState(() {
      _textOverlays.add(
        TextOverlay(
          id: _overlayIdCounter++,
          text: text,
          position: const Offset(50, 50),
        ),
      );
    });
  }

  /// Deletes a text overlay with the given [id].
  ///
  /// The [id] parameter represents the unique ID of the text overlay to be deleted.
  void _deleteText(int id) {
    setState(() {
      _textOverlays.removeWhere((overlay) => overlay.id == id);
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isEditing', isEditing));
  }
}
