import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:video_compress/video_compress.dart';

import '../../../utils/tools/compression.dart';
import '../../../utils/tools/utils.dart';

import '../temp_directory/resolver.dart';
import 'file_picker.dart';

const _maxImageUploadSize = 256 * 1024; // 256 Kb
const _maxVideoUploadSize = 5 * 1024 * 1024; // 25 Mb

/// Compressors for mobile devices
@immutable
class ZdsFileCompressPostProcessor implements ZdsFilePostProcessor {
  /// Default constructor
  const ZdsFileCompressPostProcessor();

  @override
  Future<FileWrapper> process(FilePickerConfig config, FileWrapper file) async {
    if (kIsWeb) {
      return file;
    } else if (file.isImage()) {
      return FileWrapper(file.type, await _compressImage(File(file.xFilePath), config));
    } else if (file.isVideo()) {
      return FileWrapper(
        file.type,
        await _compressVideo(File(file.xFilePath), config),
      );
    } else {
      return file;
    }
  }

  Future<XFile> _compressVideo(File video, FilePickerConfig config) async {
    try {
      final dir = await zdsTempDirectory();
      final fileExtension = path.extension(video.path).toLowerCase().replaceAll('.', '');
      final targetFile = File('$dir/${path.basenameWithoutExtension(video.path)}.$fileExtension');
      final maxFileSize = config.maxFileSize == 0 ? _maxVideoUploadSize : config.maxFileSize;

      File compressedVideo;
      try {
        compressedVideo = await ZdsCompressor.compressVideo(
              video: video,
              target: targetFile,
              maxFileSize: maxFileSize,
              quality: _videoQuality(config.videoCompressionLevel),
            ) ??
            video;
      } catch (e) {
        compressedVideo = video;
      }

      final size = await compressedVideo.length();
      if (size > maxFileSize) {
        throw FilePickerException(PickerExceptionType.maxFileSize, args: [fileSizeWithUnit(maxFileSize)]);
      }

      return ZdsXFile.fromFile(compressedVideo);
    } catch (e) {
      rethrow;
    }
  }

  VideoQuality _videoQuality(int config) {
    const qualityMap = {
      1: VideoQuality.Res1280x720Quality,
      2: VideoQuality.Res960x540Quality,
      3: VideoQuality.Res640x480Quality,
      4: VideoQuality.MediumQuality,
      5: VideoQuality.LowQuality,
    };

    return qualityMap[config] ?? VideoQuality.Res640x480Quality;
  }

  Future<XFile> _compressImage(File image, FilePickerConfig config) async {
    try {
      final fileSize = config.maxFileSize == 0 ? _maxImageUploadSize : config.maxFileSize;
      final h = config.maxPixelSize <= 0 ? 1080 : config.maxPixelSize;

      // Resolve compression type
      final fileExtension = path.extension(image.path).toLowerCase().replaceAll('.', '');
      final format = _getCompressFormat(fileExtension, config);
      final quality = h < 1000
          ? 95
          : h < 1500
              ? 75
              : 50;

      File result = image;

      if (format != null) {
        try {
          final c = Compression(maxFileSize: fileSize, minHeight: h, minWidth: h, format: format, quality: quality);
          var compressed = await ZdsCompressor.compressImage(image: image, compression: c);
          if (compressed != null) {
            // Rename file back to jpg if picked file was jpg and allowed file types dose not contain jpeg.
            // This step is needed as jpg is compressed to jpeg
            if (fileExtension == 'jpg' && !config.allowedExtensions.contains('jpeg')) {
              compressed = compressed.renameSync(compressed.absolute.path.replaceAll('.jpeg', '.jpg'));
            }

            result = compressed;
            await image.delete();
          }
        } catch (e) {
          result = image;
        }
      }

      final int size = await result.length();
      if (size > fileSize) {
        throw FilePickerException(PickerExceptionType.maxFileSize, args: [fileSizeWithUnit(fileSize)]);
      }

      return ZdsXFile.fromFile(result);
    } catch (e) {
      rethrow;
    }
  }

  CompressFormat? _getCompressFormat(String extension, FilePickerConfig config) {
    final allowedExt = config.allowedExtensions.map((e) => e.toLowerCase());

    // If allowed file extension list is empty then return jpeg
    if (allowedExt.isEmpty) return CompressFormat.jpeg;

    // fallback to other extension
    switch (extension) {
      case 'png':
        return CompressFormat.png;
      case 'jpeg':
      case 'jpg':
        return CompressFormat.jpeg;
      case 'heic':
        return CompressFormat.heic;
      case 'webp':
        return CompressFormat.webp;
      default:
        return null;
    }
  }
}
