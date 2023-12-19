// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;
import 'file_picker.dart';

/// Extension on FilePickerException to show message

/// Types of files the [ZdsFilePicker] can be used to pick.
enum FilePickerOptions {
  /// Opens native video file picker.
  VIDEO,

  /// Opens native file picker.
  FILE,

  /// Opens a modal with text fields to enter link name and url.
  LINK,

  /// Opens camera. Requires user to give camera permission.
  CAMERA,

  /// Opens native image gallery picker.
  GALLERY,

  /// Opens Giphy gif picker.
  GIF
}

/// Wrapper around files picked using [ZdsFilePicker].
@immutable
class FileWrapper {
  /// Constructs a [FileWrapper].
  const FileWrapper(this.type, this.content);

  /// The type of file wrapped.
  final FilePickerOptions type;

  /// The content of the picked file.
  final dynamic content;

  /// Gets the name of the file.
  ///
  /// For links this will be either the provided name or the url.
  String? get name {
    if (content is XFile) {
      return (content as XFile).name;
    } else if (content is XUri) {
      return (content as XUri).name;
    } else if (content is GiphyGif) {
      return (content as GiphyGif).title;
    } else {
      return null;
    }
  }

  /// Gets the path of a file, if the file is [XFile].
  String get xFilePath {
    if (content is XFile) {
      return (content as XFile).path;
    }
    return '';
  }

  /// Gets the extension of the picked file in lowercase- e.g: jpg, pdf.
  ///
  /// For links, the url is returned
  String? get extension {
    if (content is XFile) {
      return path.extension((content as XFile).name).toLowerCase().replaceAll('.', '');
    } else if (content is XUri) {
      return 'url';
    } else if (content is GiphyGif) {
      return 'gif';
    } else {
      return null;
    }
  }

  /// True if the file is a link.
  bool get isLink => content != null && content is XUri;

  /// Returns mimeType of the [content] if it is a valid file
  String? get mimeType {
    if (content is XFile) {
      final XFile file = content as XFile;
      return file.mimeType ?? mime.lookupMimeType(file.path) ?? mime.lookupMimeType(file.name);
    } else {
      return null;
    }
  }

  /// True if the file is an image.
  bool isImage() {
    if (content is XFile) {
      return mimeType?.contains('image') ?? false;
    } else {
      return false;
    }
  }

  /// True if the file is a video.
  bool isVideo() {
    if (content is XFile) {
      return mimeType?.contains('video') ?? false;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => type.hashCode ^ content.hashCode;

  @override
  bool operator ==(covariant FileWrapper other) {
    // ignore: avoid_dynamic_calls
    if (other.content.runtimeType != content.runtimeType) return false;
    if (content is XFile && other.content is XFile) {
      final XFile f1 = content as XFile;
      final XFile f2 = other.content as XFile;
      return f1.name == f2.name || f1.path == f2.path;
    } else if (content is XUri && other.content is XUri) {
      final XUri u1 = content as XUri;
      final XUri u2 = other.content as XUri;
      return u1.uri == u2.uri;
    } else {
      return content == other.content;
    }
  }
}

/// Uri wrapper
@immutable
class XUri {
  /// Const constructor
  const XUri({required this.uri, required this.name});

  /// Uri
  final Uri uri;

  /// Name of the uri
  final String name;

  /// Creates a deep copy
  XUri copyWith({Uri? uri, String? name}) {
    return XUri(uri: uri ?? this.uri, name: name ?? this.name);
  }

  @override
  int get hashCode => uri.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is XUri && runtimeType == other.runtimeType && uri == other.uri && name == other.name;
  }
}
