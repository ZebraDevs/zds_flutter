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
  Future<FileWrapper> process(FilePickerConfig config, FileWrapper file) async {
    if (kIsWeb || file.content is! XFile) return file;
    final photoDir = path.dirname(file.xFilePath);
    final epoch = DateFormat('yyyyMMdd_HHmmssSSS').format(DateTime.now());
    final fileName = '${file.type.toPrefix()}_$epoch${path.extension(file.xFilePath)}';
    final newPath = path.join(photoDir, fileName);
    final photoFile = File(file.xFilePath).renameSync(newPath);
    return FileWrapper(file.type, ZdsXFile.fromFile(photoFile));
  }
}

extension on FilePickerOptions {
  String toPrefix() {
    switch (this) {
      case FilePickerOptions.CAMERA:
        return 'IMG';
      case FilePickerOptions.FILE:
        return 'FIL';
      case FilePickerOptions.GALLERY:
        return 'GAL';
      case FilePickerOptions.GIF:
        return 'GIF';
      case FilePickerOptions.LINK:
        return 'LNK';
      case FilePickerOptions.VIDEO:
        return 'VID';
    }
  }
}
