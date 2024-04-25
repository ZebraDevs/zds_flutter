import 'package:flutter/material.dart';

import 'file_picker.dart';

export 'file_compress.dart';
export 'file_edit.dart';
export 'file_rename.dart';
export 'image_crop.dart';

/// Context used for page navigation
typedef BuildContextProvider = BuildContext Function();

/// abstract class to process file actions for all processors.
// ignore: one_member_abstracts
abstract class ZdsFilePostProcessor {
  /// method that is to be implemented.
  Future<ZdsFileWrapper> process(ZdsFilePickerConfig config, ZdsFileWrapper wrapper);
}

/// Default post processors
const List<ZdsFilePostProcessor> zdsDefaultPostProcessors = <ZdsFilePostProcessor>[
  ZdsFileCompressPostProcessor(),
  ZdsFileRenamePostProcessor(),
];
