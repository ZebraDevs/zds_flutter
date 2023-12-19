import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:video_compress/video_compress.dart';
import '../../../../../zds_flutter.dart';

/// Creates a temporary directory for [ZdsFilePicker].
Future<String> zdsTempDirectory([
  String subdir1 = '',
  String subdir2 = '',
  String subdir3 = '',
  String subdir4 = '',
  String subdir5 = '',
  String subdir6 = '',
]) async {
  final Directory supportDir = await path_provider.getApplicationSupportDirectory();
  final Directory tempDir = Directory(
    path.join(supportDir.path, 'Zds-ui', subdir1, subdir2, subdir3, subdir4, subdir5, subdir6),
  );
  if (!tempDir.existsSync()) await tempDir.create(recursive: true);
  return tempDir.absolute.path;
}

/// Clears all files and cache from any [ZdsFilePicker].
Future<void> clearUiTempDirectory() async {
  await Directory(await zdsTempDirectory()).delete(recursive: true);
  await VideoCompress.deleteAllCache();
}
