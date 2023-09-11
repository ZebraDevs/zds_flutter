import 'dart:io';

import 'package:extended_image/extended_image.dart' as image_editor;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path/path.dart' as path;
import './temp_directory/resolver.dart';

import '../../../zds_flutter.dart';

/// A full-screen image editor that allows to edit an image, including cropping and orientation. Returns a [Scaffold],
/// so it's highly recommended to push a new page when using this component
///
/// This widget can be used with [Navigator.push], whose [Future] will be contain the edited [File]:
/// ```dart
/// Navigator.push(
///   context,
///   CupertinoPageRoute(builder: (context) => ImageEditor(image: originalFile))
/// ).then((result) {
///   if (result != null) {
///     final editedImage = result as File;
///     // Handle new file
///   }
/// });
/// ```
class ZdsImageEditor extends StatefulWidget {
  /// The image to be edited
  final File image;

  /// Initial Aspect ratio of crop rect
  /// default is [ZdsAspectRatio.original]
  ///
  /// The argument only affects the initial aspect ratio.
  final ZdsAspectRatio initialCropAspectRatio;

  /// Creates an image editor that allows to crop and rotate an image.
  /// Recommended to push a new page as this returns a [Scaffold].
  const ZdsImageEditor({
    required this.image,
    this.initialCropAspectRatio = ZdsAspectRatio.original,
    super.key,
  });

  @override
  ZdsImageEditorState createState() => ZdsImageEditorState();

  /// Navigates to the `ImageEditor` screen, allowing the user to edit
  /// the [originalFile]. Once editing is complete, the edited image data
  /// replaces the original file.
  ///
  /// This method takes the following parameters:
  /// - [context]: The BuildContext required for the Navigator and translation
  ///   purposes.
  /// - [originalFile]: The original image File that needs to be edited.
  ///
  /// The method first retrieves all available translations for the
  /// `ImageEditor` component and sets them using `ImageEditor.i18n`.
  /// It then pushes the `SingleImageEditor` screen onto the navigation stack,
  /// passing the image data from [originalFile] as a parameter.
  ///
  /// After the `SingleImageEditor` screen is popped, the method checks if
  /// there is a non-null value of type Uint8List (edited image data). If
  /// there is, the [originalFile] is deleted, and a new File with the same
  /// path is created with the edited image data.
  static Future<void> editFile(BuildContext context, File originalFile) async {
    final translations = ComponentStrings.of(context).getAll();
    ImageEditor.i18n(translations);
    final Uint8List? value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SingleImageEditor(
            image: originalFile.readAsBytesSync(),
          );
        },
      ),
    );
    if (value != null) {
      await originalFile.delete(recursive: true);
      await File(originalFile.path).writeAsBytes(value);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File>('image', image));
    properties.add(EnumProperty<ZdsAspectRatio>('initialCropAspectRatio', initialCropAspectRatio));
  }
}

/// Aspect ratio for the initial crop
enum ZdsAspectRatio {
  /// no aspect ratio for crop
  custom,

  /// the same as aspect ratio of image
  /// `cropAspectRatio` is not more than 0.0, it's original
  original,

  /// ratio of width and height is 1 : 1
  ratio1x1,

  /// ratio of width and height is 3 : 4
  ratio3x4,

  /// ratio of width and height is 4 : 3
  ratio4x3,

  /// ratio of width and height is 9 : 16
  ratio9x16,

  /// ratio of width and height is 16 : 9
  ratio16x9,
}

extension _ZdsAspectRatioToDouble on ZdsAspectRatio {
  double? toValue() {
    switch (this) {
      case ZdsAspectRatio.custom:
        return null;
      case ZdsAspectRatio.original:
        return 0;
      case ZdsAspectRatio.ratio1x1:
        return 1;
      case ZdsAspectRatio.ratio3x4:
        return 3 / 4;
      case ZdsAspectRatio.ratio4x3:
        return 4 / 3;
      case ZdsAspectRatio.ratio9x16:
        return 9 / 16;
      case ZdsAspectRatio.ratio16x9:
        return 16 / 9;
    }
  }
}

/// State for [ZdsImageEditor].
class ZdsImageEditorState extends State<ZdsImageEditor> with FrameCallbackMixin {
  final _editorKey = GlobalKey<image_editor.ExtendedImageEditorState>();

  late final List<_AspectRatioItem> _aspectRatios = <_AspectRatioItem>[
    _AspectRatioItem(
      text: ComponentStrings.of(context).get('DEFAULT', 'Default'),
      value: image_editor.CropAspectRatios.original,
    ),
    _AspectRatioItem(text: ComponentStrings.of(context).get('CUSTOM', 'Custom')),
    _AspectRatioItem(text: '1:1', value: image_editor.CropAspectRatios.ratio1_1),
    _AspectRatioItem(text: '4:3', value: image_editor.CropAspectRatios.ratio4_3),
    _AspectRatioItem(text: '3:4', value: image_editor.CropAspectRatios.ratio3_4),
    _AspectRatioItem(text: '16:9', value: image_editor.CropAspectRatios.ratio16_9),
    _AspectRatioItem(text: '9:16', value: image_editor.CropAspectRatios.ratio9_16),
  ];

  late Uint8List _imageBytes;
  late double? _aspectRatio = widget.initialCropAspectRatio.toValue();

  bool _saving = false;

  /// True if image is being saved.
  bool get saving => _saving;

  set saving(bool saving) {
    if (_saving == saving) return;
    setState(() {
      _saving = saving;
    });
  }

  bool _cropping = false;

  /// True if image is being cropped.
  bool get cropping => _cropping;

  set cropping(bool cropping) {
    if (_cropping == cropping) return;
    setState(() {
      _cropping = cropping;
    });
  }

  @override
  void initState() {
    _imageBytes = widget.image.readAsBytesSync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(ComponentStrings.of(context).get('EDIT', 'Edit')),
        actions: <Widget>[
          IconButton(
            tooltip: ComponentStrings.of(context).get('COMPLETE_EDITING', 'Complete editing'),
            icon: saving
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : const Icon(Icons.done),
            onPressed: _saveImage,
          ),
        ],
      ),
      body: image_editor.ExtendedImage.memory(
        _imageBytes,
        fit: BoxFit.contain,
        cacheRawData: true,
        mode: image_editor.ExtendedImageMode.editor,
        extendedImageEditorKey: _editorKey,
        initEditorConfigHandler: (state) {
          return image_editor.EditorConfig(
            maxScale: 8,
            initialCropAspectRatio: widget.initialCropAspectRatio.toValue(),
            cropAspectRatio: _aspectRatio,
            cornerColor: Colors.white,
            editorMaskColorHandler: (context, editing) {
              if (editing) {
                return Colors.black26;
              } else {
                return Colors.black45;
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: cropping
              ? _croppingOptions()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _iconWithText(
                      const Icon(Icons.crop),
                      ComponentStrings.of(context).get('CROP', 'Crop'),
                      () => cropping = true,
                      color,
                    ),
                    _iconWithText(
                      const Icon(Icons.flip),
                      ComponentStrings.of(context).get('FLIP', 'Flip'),
                      () => _editorKey.currentState?.flip(),
                      color,
                    ),
                    _iconWithText(
                      const Icon(Icons.rotate_left),
                      ComponentStrings.of(context).get('ROTATE_LEFT', 'Rotate Left'),
                      () => _editorKey.currentState?.rotate(right: false),
                      color,
                    ),
                    _iconWithText(
                      const Icon(Icons.rotate_right),
                      ComponentStrings.of(context).get('ROTATE_RIGHT', 'Rotate Right'),
                      () => _editorKey.currentState?.rotate(),
                      color,
                    ),
                    _iconWithText(
                      const Icon(Icons.restore),
                      ComponentStrings.of(context).get('RESET', 'Reset'),
                      () => _editorKey.currentState?.reset(),
                      color,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _croppingOptions() {
    return SizedBox(
      height: 66,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _aspectRatios.length,
        itemBuilder: (context, index) {
          final _AspectRatioItem item = _aspectRatios[index];

          void onTap() {
            setState(() {
              cropping = false;
              _aspectRatio = item.value;
            });
          }

          if (item.value == _aspectRatio) {
            return Builder(
              builder: (context) {
                atLast(() async => Scrollable.ensureVisible(context, alignment: 0.5));
                return Center(
                  child: ZdsButton.filled(
                    onTap: onTap,
                    child: Text(item.text),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: ZdsButton.text(
                onTap: onTap,
                child: Text(
                  item.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _saveImage() async {
    if (saving) return;

    try {
      final currentState = _editorKey.currentState;

      if (currentState == null) return;

      saving = true;

      final fileData = await cropImageDataWithNativeLibrary(state: currentState);

      if (fileData == null) return;

      final appDir = await zdsTempDirectory('edited');
      final fileName = path.basename(widget.image.path);

      //save image to tem file
      final tempFile = File(path.join(appDir, 'edit.tmp'));
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }

      await tempFile.writeAsBytes(fileData);

      // delete fileName file if already exist
      final editedFile = File(path.join(appDir, fileName));
      if (editedFile.existsSync()) {
        await editedFile.delete();
      }

      // rename edited file to expected filename
      if (mounted) {
        Navigator.pop(context, await tempFile.rename(editedFile.absolute.path));
      }
    } catch (e, stack) {
      debugPrint('save failed: $e\n $stack');
    } finally {
      saving = false;
    }
  }

  Widget _iconWithText(Icon icon, String text, void Function()? onTap, Color color) {
    return MergeSemantics(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(color: color, icon: icon, onPressed: onTap),
          Text(text, style: TextStyle(fontSize: 10, color: color)),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('saving', saving));
    properties.add(DiagnosticsProperty<bool>('cropping', cropping));
  }
}

class _AspectRatioItem {
  /// Constructs an [_AspectRatioItem].
  _AspectRatioItem({required this.text, this.value});

  final String text;
  final double? value;
}
