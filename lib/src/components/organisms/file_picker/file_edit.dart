import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path/path.dart' as path;

import '../../../../../zds_flutter.dart';
import '../temp_directory/resolver.dart';

/// Editors used to edit only image files & to launch other types of files
class ZdsFileEditPostProcessor implements ZdsFilePostProcessor {
  ///default constructor
  ZdsFileEditPostProcessor(this.buildContext);

  ///Context used for navigations and toasts
  final BuildContextProvider buildContext;

  @override
  Future<FileWrapper> process(FilePickerConfig config, FileWrapper file) async {
    if (kIsWeb) return file;

    if (file.isImage() && file.content != null) {
      final File originalFile = File(file.xFilePath);
      ImageEditor.i18n(ComponentStrings.of(buildContext.call()).getAll());
      final bytes = await Navigator.of(buildContext.call(), rootNavigator: true).push<Uint8List>(
        ZdsFadePageRouteBuilder(
          fullscreenDialog: true,
          builder: (context) {
            return ImageEditor(
              image: originalFile.readAsBytesSync(),
              emojiOption: null,
              textOption: null,
              blurOption: null,
            );
          },
        ),
      );

      if (bytes != null) {
        final String dir = await zdsTempDirectory('edited');
        await originalFile.delete(recursive: true);
        final File result = File(path.join(dir, path.basename(originalFile.absolute.path)));
        await result.writeAsBytes(bytes);
        return FileWrapper(file.type, ZdsXFile.fromFile(result));
      }
    }

    return file;
  }
}
