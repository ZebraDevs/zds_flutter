import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/assets/icons.dart';
import '../../../utils/localizations/translation.dart';
import '../../../utils/tools/utils.dart';
import '../../molecules/toast.dart';
import 'file_picker.dart';

/// Class defining different exceptions types with its arguments
class FilePickerException implements Exception {
  /// Default constructor
  FilePickerException(this.type, {this.args = const <String>[]});

  /// Used to specify different types of errors
  PickerExceptionType type;

  /// Used to specify custom error sizes
  List<String> args;
}

/// Types of errors, commonly used to generate error toast messages later
enum PickerExceptionType {
  /// This file type is not allowed
  unsupportedFile,

  /// File size limit
  maxFileSize,

  /// Pixel size limit
  maxPixelSize,

  /// Error in file compression
  compression,

  /// Error in reading file size
  fileSizeRead,

  /// File processing error
  processing,

  /// File already selected
  duplicateFile,

  /// URL already added
  duplicateURL,

  /// Invalid URL added
  invalidUrl,

  /// Maximum total attachment size reached
  maxLimitReached,

  /// Used for custom error message
  custom
}

/// Default file validator
Future<FilePickerException?> zdsValidator(
  ZdsFilePickerController controller,
  FilePickerConfig config,
  FileWrapper wrapper,
  FilePickerOptions option,
) async {
  final dynamic file = wrapper.content;
  if (file is! XFile) return null;

  //file type check if [useLiveMediaOnly] is true and
  //option will be [FilePickerOptions.FILE]
  if (config.useLiveMediaOnly && option == FilePickerOptions.FILE) {
    final allowedFileTypes = getAllowedFileBrowserTypes(
      useLiveMediaOnly: config.useLiveMediaOnly,
      allowedFileTypes: config.allowedExtensions,
    );
    if (allowedFileTypes.isNotEmpty && !allowedFileTypes.contains(wrapper.extension)) {
      return FilePickerException(PickerExceptionType.unsupportedFile);
    }
  }

  // File type check
  if (config.allowedExtensions.isNotEmpty && !config.allowedExtensions.contains(wrapper.extension)) {
    return FilePickerException(PickerExceptionType.unsupportedFile);
  }

  // Check if file is already selected
  if (controller.items.contains(wrapper)) {
    return FilePickerException(PickerExceptionType.duplicateFile);
  }

  // check if the file size is within the limit
  if (!(wrapper.isImage() || wrapper.isVideo()) && config.maxFileSize > 0 && config.maxFileSize < await file.length()) {
    return FilePickerException(PickerExceptionType.maxFileSize, args: <String>[fileSizeWithUnit(config.maxFileSize)]);
  }

  return null;
}

/// Default error handler
void zdsFileError(BuildContext context, FilePickerConfig config, Exception exception) {
  String message(Exception exception) {
    if (exception is FilePickerException) {
      return exception.type.message(context, args: exception.args);
    } else {
      return ComponentStrings.of(context).get('FILE_COMPRESSING_ER', 'An error occurred while compressing a file.');
    }
  }

  ScaffoldMessenger.of(context).showZdsToast(
    padding: const EdgeInsets.all(16).copyWith(top: 0),
    ZdsToast(
      multiLine: true,
      title: Text(message(exception)),
      leading: const Icon(ZdsIcons.close_circle),
      color: ZdsToastColors.error,
    ),
  );
}

///extension used to return different strings on exceptions.
extension ExceptionTextMessage on PickerExceptionType {
  ///  method returns FilePickerException message's.
  String message(BuildContext context, {List<String> args = const <String>[]}) {
    final ComponentStrings strings = ComponentStrings.of(context);
    switch (this) {
      case PickerExceptionType.unsupportedFile:
        return strings.get('FILE_UNSUPPORTED', 'This file type is not allowed');
      case PickerExceptionType.maxFileSize:
        return strings.get('ATTACH_MAXSIZE_VALIDATE', 'File size must be less than {0}', args: args);
      case PickerExceptionType.maxPixelSize:
        return strings.get('FILE_PIXEL_SIZE_ER', 'File pixel size should be less than {0}', args: args);
      case PickerExceptionType.compression:
        return strings.get('FILE_COMPRESSING_ER', 'An error occurred while compressing a file.');
      case PickerExceptionType.fileSizeRead:
        return strings.get('FILE_SIZE_CALCULATING_ER', 'An error occurred while calculating a file size.');
      case PickerExceptionType.processing:
        return strings.get('FILE_PROCESSING_ER', 'An error occurred while processing a file.');
      case PickerExceptionType.duplicateFile:
        return strings.get('FILE_DUPLICATE_ER', 'File is already attached. Please choose different file.');
      case PickerExceptionType.duplicateURL:
        return strings.get('URL_DUPLICATE_ER', 'URL is already attached. Please enter different URL.');
      case PickerExceptionType.invalidUrl:
        return strings.get('URL_INVALID_ER', 'Please enter valid URL.');
      case PickerExceptionType.maxLimitReached:
        return strings.get('MAX_ATTACH_MSG', 'Attachment max limit reached');
      case PickerExceptionType.custom:
        return args.join(' ');
    }
  }
}
