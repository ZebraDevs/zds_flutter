import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as picker;

/// A stateless widget that provides an example of an image editor.
///
/// This widget displays a button that allows the user to pick an image from the gallery.
/// When an image is picked, it navigates to the `ImageEditorHome` page with the selected image.
class ImageEditorExample extends StatelessWidget {
  /// Creates an instance of `ImageEditorExample2`.
  ///
  /// The constructor takes an optional key parameter.
  const ImageEditorExample({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final ComponentStrings strings = ComponentStrings.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (kIsWeb) Text('This example does not work on web').paddingBottom(40),
            ElevatedButton(
              onPressed: () async {
                // Pick an image from the gallery.
                final file = await picker.ImagePicker().pickImage(source: picker.ImageSource.gallery);
                if (file != null) {
                  // Navigate to the ImageEditorHome page with the selected image.
                  unawaited(
                    Navigator.of(context).push(
                      MaterialPageRoute<dynamic>(
                        builder: (context) => ImageEditorHome.file(File(file.path)),
                      ),
                    ),
                  );
                }
              },
              child: Text(strings.get('PICK_IMAGE', 'Pick Image')),
            ),
          ],
        ),
      ),
    );
  }
}
