import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

import '../../../../zds_flutter.dart';

/// Editors used to edit only image files & to launch other types of files
class ZdsImageAnnotationPostProcessor implements ZdsFilePostProcessor {
  ///default constructor
  ZdsImageAnnotationPostProcessor(this.buildContext);

  ///Context used for navigations and toasts
  final BuildContextProvider buildContext;

  @override
  Future<ZdsFileWrapper> process(ZdsFilePickerConfig config, ZdsFileWrapper file) async {
    if (kIsWeb) return file;

    if (file.isImage() && file.content != null) {
      final File originalFile = File(file.xFilePath);
      final XFile? result = await _editFile(buildContext.call(), originalFile);
      if (result != null) {
        return ZdsFileWrapper(file.type, result);
      }
    }

    return file;
  }

  Future<XFile?> _editFile(BuildContext context, File originalFile) async {
    ImageEditor.i18n(ComponentStrings.of(context).getAll());
    final bytes = await Navigator.of(context, rootNavigator: true).push<Uint8List>(
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
      await originalFile.delete(recursive: true);
      final File result = File(originalFile.path);
      await result.writeAsBytes(bytes);
      return ZdsXFile.fromFile(result);
    } else {
      return null;
    }
  }
}
