import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter/painter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../zds_flutter.dart';

import '../utils/editor_icon.dart';
import '../utils/utils.dart';

///
enum DrawOptions {
  ///
  pen,

  ///
  highlight,
}

/// A page that allows users to draw on an image.
///
/// This page provides tools for drawing and highlighting on an image.
/// Users can select colors and apply their drawings to the image.
class DrawPage extends StatefulWidget {
  /// Creates a [DrawPage] with the given image.
  ///
  /// The [image] parameter is required and represents the image to be edited.
  const DrawPage({super.key, required this.image});

  /// The image to be edited.
  final Image image;

  @override
  State<DrawPage> createState() => _DrawPageState();
}

/// The state class for [DrawPage].
///
/// This class manages the state of the drawing page, including the painter
/// controller and screenshot controller.
class _DrawPageState extends State<DrawPage> {
  /// Controller for capturing screenshots.
  ScreenshotController screenshotController = ScreenshotController();

  /// Controller for managing the painter.
  final PainterController _painterController = PainterController();

  late DrawOptions selectedTab;

  @override
  void initState() {
    selectedTab = DrawOptions.pen;
    _painterController
      ..thickness = 5.0
      ..backgroundColor = Colors.transparent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ComponentStrings.of(context);
    return PopScope(
      canPop: false,
      child: Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(strings.get('DRAW', 'Draw')),
            actions: appBarActions(
              undo: _painterController.undo,
            ),
          ),
          body: Center(
            child: Screenshot(
              controller: screenshotController,
              child: Stack(
                children: [
                  widget.image,
                  Positioned.fill(child: Painter(_painterController)),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(strings),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: colorPickerButton(strings),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        ),
      ),
    );
  }

  /// Builds the color picker button.
  ///
  /// This method returns a widget that allows users to select a color for drawing.
  Widget colorPickerButton(ComponentStrings strings) {
    return IconButton(
      onPressed: () {
        unawaited(
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(strings.get('SELECT_COLOR', 'Select Color')),
              content: BlockPicker(
                pickerColor: selectedTab == DrawOptions.pen
                    ? _painterController.drawColor
                    : _painterController.drawColor.withAlpha(100),
                onColorChanged: (value) {
                  _painterController.drawColor = selectedTab == DrawOptions.pen ? value : value.withAlpha(100);
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ),
          ),
        );
      },
      icon: Stack(
        children: [
          Icon(
            Icons.circle,
            size: 48,
            color: selectedTab == DrawOptions.pen
                ? _painterController.drawColor
                : _painterController.drawColor.withAlpha(100),
          ),
          const Icon(
            Icons.circle_outlined,
            size: 48,
          ),
        ],
      ),
    );
  }

  /// Builds the bottom navigation bar with drawing tools.
  ///
  /// This method returns a widget that contains buttons for different drawing tools.
  Widget _buildBottomNavigationBar(ComponentStrings strings) {
    final zetaColors = Zeta.of(context).colors;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EditorIcon(
                  isSelected: selectedTab == DrawOptions.pen,
                  icon: Icon(
                    Icons.edit,
                    color: selectedTab == DrawOptions.pen ? zetaColors.mainPrimary : null,
                  ),
                  label: strings.get('PEN', 'Pen'),
                  onPressed: () {
                    setState(() {
                      selectedTab = DrawOptions.pen;
                    });
                    _painterController
                      ..drawColor = _painterController.drawColor.withAlpha(255)
                      ..thickness = 5.0
                      ..backgroundColor = Colors.transparent;
                  },
                ),
                EditorIcon(
                  isSelected: selectedTab == DrawOptions.highlight,
                  icon: Icon(
                    Icons.highlight,
                    color: selectedTab == DrawOptions.highlight ? zetaColors.mainPrimary : null,
                  ),
                  label: strings.get('HIGHLIGHT', 'Highlight'),
                  onPressed: () {
                    setState(() {
                      selectedTab = DrawOptions.highlight;
                    });
                    _painterController
                      ..thickness = 20
                      ..drawColor = _painterController.drawColor.withAlpha(100);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
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
                      screenshotController.capture().then(
                        (value) {
                          if (value != null) {
                            final image = Image.memory(value);
                            Navigator.pop(context, image);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ScreenshotController>('screenshotController', screenshotController))
      ..add(EnumProperty<DrawOptions>('selectedTab', selectedTab));
  }
}
