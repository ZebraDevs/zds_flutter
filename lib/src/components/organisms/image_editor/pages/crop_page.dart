import 'dart:async';
import 'dart:ui' as ui;
import 'package:crop_image/crop_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../utils/localizations.dart';
import '../../../atoms.dart';
import '../utils/editor_icon.dart';
import '../utils/utils.dart';

/// A page that allows users to crop an image.
///
/// This page provides tools for cropping an image, including rotating and flipping the image.
class CropPage extends StatefulWidget {
  /// Creates a [CropPage] with the given image.
  ///
  /// The [image] parameter is required and represents the image to be edited.
  const CropPage({super.key, required this.image});

  /// The image to be edited.
  final Image image;
  @override
  State<CropPage> createState() => _CropPageState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Image>('image', image));
  }
}

/// The state class for [CropPage].
///
/// This class manages the state of the cropping page, including the crop controller.
class _CropPageState extends State<CropPage> {
  /// Controller for managing the crop operations.
  final controller = CropController();
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
            title: Text(strings.get('CROP', 'Crop')),
            actions: appBarActions(undo: () {}),
          ),
          body: Center(
            child: CropImage(
              image: widget.image,
              controller: controller,
              paddingSize: 25,
              alwaysMove: true,
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(strings),
        ),
      ),
    );
  }

  /// Builds the bottom navigation bar with cropping tools.
  ///
  /// This method returns a widget that contains buttons for different cropping tools.
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
                  icon: const Icon(Icons.flip),
                  label: strings.get('MIRROR', 'Mirror'),
                  onPressed: _flipImage,
                ),
                EditorIcon(
                  icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
                  label: strings.get('ROTATE', 'Rotate'),
                  onPressed: _rotateRight,
                ),
                EditorIcon(
                  icon: const Icon(Icons.crop_free_outlined),
                  label: strings.get('FREE', 'Free'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 12,
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
                  onTap: _saveAndPop,
                  child: Text(strings.get('APPLY', 'Apply')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Rotates the image 90 degrees to the right.
  Future<void> _rotateRight() async {
    controller.rotateRight();
  }

  /// Flips the image horizontally.
  Future<void> _flipImage() async {
    try {
      final ui.Image? originalImage = controller.getImage();
      if (originalImage != null) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        final paint = Paint();
        final width = originalImage.width.toDouble();
        final height = originalImage.height.toDouble();
        if (controller.rotation == CropRotation.up || controller.rotation == CropRotation.down) {
          canvas
            ..translate(width, 0)
            ..scale(-1, 1);
        } else {
          canvas
            ..translate(0, height)
            ..scale(1, -1);
        }
        final Rect rect = Rect.fromLTWH(0, 0, originalImage.width.toDouble(), originalImage.height.toDouble());
        canvas.drawImageRect(originalImage, rect, rect, paint);
        final picture = recorder.endRecording();
        final flippedImage = await picture.toImage(width.toInt(), height.toInt());
        controller.image = flippedImage;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Saves the cropped image and pops the current page.
  Future<void> _saveAndPop() async {
    unawaited(
      controller.croppedImage().then(
            (image) => Navigator.pop(context, image),
          ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CropController>('controller', controller));
  }
}
