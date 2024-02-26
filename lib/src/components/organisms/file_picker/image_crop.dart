import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path/path.dart' as path;

import '../../../../zds_flutter.dart';
import '../temp_directory/resolver.dart';

/// Editors used to edit only image files & to launch other types of files
class ZdsImageCropPostProcessor implements ZdsFilePostProcessor {
  ///default constructor
  ZdsImageCropPostProcessor(this.buildContext);

  ///Context used for navigations and toasts
  final BuildContextProvider buildContext;

  @override
  Future<FileWrapper> process(FilePickerConfig config, FileWrapper file) async {
    if (kIsWeb) return file;

    if (file.isImage() && file.content != null) {
      // ignore: avoid_dynamic_calls
      final originalFile = File(file.content.path as String);
      ImageEditor.i18n(ComponentStrings.of(buildContext.call()).getAll());
      final bytes = await Navigator.of(buildContext.call(), rootNavigator: true).push<Uint8List>(
        ZdsFadePageRouteBuilder(
          fullscreenDialog: true,
          builder: (context) {
            return ImageCropper(
              image: originalFile.readAsBytesSync(),
            );
          },
        ),
      );

      if (bytes != null) {
        final dir = await zdsTempDirectory('edited');
        await originalFile.delete(recursive: true);
        final result = File(path.join(dir, path.basename(originalFile.absolute.path)));
        await result.writeAsBytes(bytes);
        return FileWrapper(file.type, ZdsXFile.fromFile(result));
      }
    }
    // Clicking cancel returns an empty file.
    return const FileWrapper(FilePickerOptions.GALLERY, null);
  }
}
