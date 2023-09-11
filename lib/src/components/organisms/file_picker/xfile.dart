import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;

/// Constructors for XFile
extension ZdsXFile on XFile {
  /// Creates [XFile] instance from a [File]
  static XFile fromFile(File file) {
    return XFile(
      file.absolute.path,
      length: file.lengthSync(),
      mimeType: mime.lookupMimeType(file.absolute.path),
      name: path.basename(file.absolute.path),
    );
  }

  /// Synchronously deletes this [XFile].
  ///
  /// If the [XFile] is a directory, and if [recursive] is false,
  /// the directory must be empty. Otherwise, if [recursive] is true, the
  /// directory and all sub-directories and files in the directories are
  /// deleted. Links are not followed when deleting recursively. Only the link
  /// is deleted, not its target.
  void deleteSync({bool recursive = false}) {
    if (kIsWeb || this.path.isEmpty) return;
    File(this.path).deleteSync(recursive: recursive);
  }

  /// Deletes this [XFile].
  ///
  /// If the [XFile] is a directory, and if [recursive] is false,
  /// the directory must be empty. Otherwise, if [recursive] is true, the
  /// directory and all sub-directories and files in the directories are
  /// deleted. Links are not followed when deleting recursively. Only the link
  /// is deleted, not its target.
  Future<void> delete({bool recursive = false}) async {
    if (kIsWeb || this.path.isEmpty) return;
    await File(this.path).delete(recursive: recursive);
  }
}
