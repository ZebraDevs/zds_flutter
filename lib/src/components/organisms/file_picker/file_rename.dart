import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'file_picker.dart';

/// used to rename a file before compression.
@immutable
class ZdsFileRenamePostProcessor implements ZdsFilePostProcessor {
  /// Default constructor
  const ZdsFileRenamePostProcessor();

  @override
  Future<ZdsFileWrapper> process(ZdsFilePickerConfig config, ZdsFileWrapper file) async {
    if (kIsWeb || file.content is! XFile) return file;
    final String photoDir = path.dirname(file.xFilePath);
    final String epoch = DateFormat('yyyyMMdd_HHmmssSSS').format(DateTime.now());
    final String fileName = '${file.type.toPrefix()}_$epoch${path.extension(file.xFilePath)}';
    final String newPath = path.join(photoDir, fileName);
    final File photoFile = File(file.xFilePath).renameSync(newPath);
    return ZdsFileWrapper(file.type, ZdsXFile.fromFile(photoFile));
  }
}

extension on ZdsFilePickerOptions {
  String toPrefix() {
    switch (this) {
      case ZdsFilePickerOptions.CAMERA:
        return 'IMG';
      case ZdsFilePickerOptions.FILE:
        return 'FIL';
      case ZdsFilePickerOptions.GALLERY:
        return 'GAL';
      case ZdsFilePickerOptions.GIF:
        return 'GIF';
      case ZdsFilePickerOptions.LINK:
        return 'LNK';
      case ZdsFilePickerOptions.VIDEO:
        return 'VID';
    }
  }
}
