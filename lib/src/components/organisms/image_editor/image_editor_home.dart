import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../zds_flutter.dart';
import 'pages/crop_page.dart';
import 'pages/draw_page.dart';
import 'pages/draw_shape_page.dart';
import 'pages/text_page.dart';
import 'utils/editor_icon.dart';
import 'utils/utils.dart';

/// A stateful widget that represents the home screen of the image editor.
///
/// This widget is responsible for displaying the image and providing options
/// to edit the image using various tools like draw, shape, crop, and text.
///
/// The image editor does not work on the web platform.
class ImageEditorHome extends StatefulWidget {
  /// Creates an instance of [ImageEditorHome] with the given file.
  ///
  /// The constructor is private and can only be accessed through the [ImageEditorHome.file] factory.
  const ImageEditorHome._({super.key, required this.file});

  /// Factory constructor to create an instance of [ImageEditorHome] with the given file and key.
  factory ImageEditorHome.file(File file, {Key? key}) {
    return ImageEditorHome._(key: key, file: file);
  }

  /// The file representing the image to be edited.
  final File file;
  @override
  State<ImageEditorHome> createState() => _ImageEditorState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File>('file', file));
  }
}

/// The state class for [ImageEditorHome].
///
/// This class manages the state of the image editor home screen, including
/// loading the image and handling navigation to different editing tools.
class _ImageEditorState extends State<ImageEditorHome> {
  /// The image to be edited.
  late Image image;
  @override
  void initState() {
    image = Image.file(widget.file);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ComponentStrings.of(context);
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(title: Text(strings.get('IMAGE_EDITOR', 'Image Editor'))),
        body: Center(child: image),
        bottomNavigationBar: _buildBottomNavigationBar(strings),
      ),
    );
  }

  /// Builds the bottom navigation bar with editing options.
  ///
  /// This method returns a widget that contains buttons for different editing
  /// tools like draw, shape, crop, and text.
  Widget _buildBottomNavigationBar(ComponentStrings strings) {
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
                  icon: const Icon(Icons.edit),
                  label: strings.get('DRAW', 'Draw'),
                  onPressed: () {
                    unawaited(
                      Navigator.push<Image>(
                        context,
                        MaterialPageRoute<Image>(builder: (context) => DrawPage(image: image)),
                      ).then((value) {
                        if (value != null) setState(() => image = value);
                      }),
                    );
                  },
                ),
                EditorIcon(
                  icon: const Icon(Icons.circle_outlined),
                  label: strings.get('SHAPE', 'Shape'),
                  onPressed: () {
                    unawaited(
                      Navigator.push<Image>(
                        context,
                        MaterialPageRoute<Image>(builder: (context) => DrawShapePage(image: image)),
                      ).then((value) {
                        if (value != null) setState(() => image = value);
                      }),
                    );
                  },
                ),
                EditorIcon(
                  icon: const Icon(Icons.crop),
                  label: strings.get('CROP', 'Crop'),
                  onPressed: () {
                    unawaited(
                      Navigator.push<Image>(
                        context,
                        MaterialPageRoute<Image>(builder: (context) => CropPage(image: image)),
                      ).then((value) {
                        if (value != null) setState(() => image = value);
                      }),
                    );
                  },
                ),
                EditorIcon(
                  icon: const Icon(Icons.text_fields_outlined),
                  label: strings.get('TEXT', 'Text'),
                  onPressed: () {
                    unawaited(
                      Navigator.push<Uint8List>(
                        context,
                        MaterialPageRoute<Uint8List>(builder: (context) => TextPage(image: image)),
                      ).then((value) {
                        if (value != null) setState(() => image = Image.memory(value));
                      }),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Spacer(),
                ZdsButton.text(child: Text(strings.get('CANCEL', 'Cancel')), onTap: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                ZdsButton(
                  child: Text(strings.get('SAVE', 'Save')),
                  onTap: () {
                    unawaited(
                      imageToUint8List(image).then(
                        (imageBytes) {
                          Navigator.pop(context, imageBytes);
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
}
