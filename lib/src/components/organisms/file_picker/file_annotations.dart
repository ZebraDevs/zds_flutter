import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

import '../../../../../zds_flutter.dart';

/// Editors used to edit only image files & to launch other types of files
class ZdsImageAnnotationPostProcessor implements ZdsFilePostProcessor {
  ///default constructor
  ZdsImageAnnotationPostProcessor(
    this.buildContext, {
    this.initialCropAspectRatio = ZdsAspectRatio.ratio1x1,
  });

  ///Context used for navigations and toasts
  final BuildContextProvider buildContext;

  /// Initial Aspect ratio of crop rect
  /// default is [ZdsAspectRatio.original]
  ///
  /// The argument only affects the initial aspect ratio.
  final ZdsAspectRatio initialCropAspectRatio;

  @override
  Future<FileWrapper> process(FilePickerConfig config, FileWrapper file) async {
    if (kIsWeb) return file;

    if (file.isImage() && file.content != null) {
      final File originalFile = File(file.xFilePath);
      final XFile? result = await _editFile(buildContext.call(), originalFile);
      if (result != null) {
        return FileWrapper(file.type, result);
      }
    }

    return file;
  }

  Future<XFile?> _editFile(BuildContext context, File originalFile) async {
    ImageEditor.i18n(ComponentStrings.of(context).getAll());
    final Uint8List? bytes = await Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute<Uint8List?>(
        builder: (BuildContext context) {
          return SingleImageEditor(
            image: originalFile.readAsBytesSync(),
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
