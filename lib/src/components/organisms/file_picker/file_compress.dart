import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:video_compress/video_compress.dart';

import '../../../utils/tools/compression.dart';
import '../../../utils/tools/utils.dart';

import '../temp_directory/resolver.dart';
import 'file_picker.dart';

const int _maxImageUploadSize = 256 * 1024; // 256 Kb
const int _maxVideoUploadSize = 5 * 1024 * 1024; // 25 Mb

/// Compressors for mobile devices
@immutable
class ZdsFileCompressPostProcessor implements ZdsFilePostProcessor {
  /// Default constructor
  const ZdsFileCompressPostProcessor();

  @override
  Future<ZdsFileWrapper> process(ZdsFilePickerConfig config, ZdsFileWrapper file) async {
    if (kIsWeb) {
      return file;
    } else if (file.isImage()) {
      return ZdsFileWrapper(file.type, await _compressImage(File(file.xFilePath), config));
    } else if (file.isVideo()) {
      return ZdsFileWrapper(
        file.type,
        await _compressVideo(File(file.xFilePath), config),
      );
    } else {
      return file;
    }
  }

  Future<XFile> _compressVideo(File video, ZdsFilePickerConfig config) async {
    try {
      final String dir = await zdsTempDirectory();
      final String fileExtension = path.extension(video.path).toLowerCase().replaceAll('.', '');
      final File targetFile = File('$dir/${path.basenameWithoutExtension(video.path)}.$fileExtension');
      final int maxFileSize = config.maxFileSize == 0 ? _maxVideoUploadSize : config.maxFileSize;

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

      final int size = await compressedVideo.length();
      if (size > maxFileSize) {
        throw FilePickerException(PickerExceptionType.maxFileSize, args: <String>[fileSizeWithUnit(maxFileSize)]);
      }

      return ZdsXFile.fromFile(compressedVideo);
    } catch (e) {
      rethrow;
    }
  }

  VideoQuality _videoQuality(int config) {
    const Map<int, VideoQuality> qualityMap = <int, VideoQuality>{
      1: VideoQuality.Res1280x720Quality,
      2: VideoQuality.Res960x540Quality,
      3: VideoQuality.Res640x480Quality,
      4: VideoQuality.MediumQuality,
      5: VideoQuality.LowQuality,
    };

    return qualityMap[config] ?? VideoQuality.Res640x480Quality;
  }

  Future<XFile> _compressImage(File image, ZdsFilePickerConfig config) async {
    try {
      final int fileSize = config.maxFileSize == 0 ? _maxImageUploadSize : config.maxFileSize;
      final int h = config.maxPixelSize <= 0 ? 1080 : config.maxPixelSize;

      // Resolve compression type
      final String fileExtension = path.extension(image.path).toLowerCase().replaceAll('.', '');
      final CompressFormat? format = _getCompressFormat(fileExtension, config);
      final int quality = h < 1000
          ? 95
          : h < 1500
              ? 75
              : 50;

      File result = image;

      if (format != null) {
        try {
          final Compression c =
              Compression(maxFileSize: fileSize, minHeight: h, minWidth: h, format: format, quality: quality);
          File? compressed = await ZdsCompressor.compressImage(image: image, compression: c);
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
        throw FilePickerException(PickerExceptionType.maxFileSize, args: <String>[fileSizeWithUnit(fileSize)]);
      }

      return ZdsXFile.fromFile(result);
    } catch (e) {
      rethrow;
    }
  }

  CompressFormat? _getCompressFormat(String extension, ZdsFilePickerConfig config) {
    final Iterable<String> allowedExt = config.allowedExtensions.map((String e) => e.toLowerCase());

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
