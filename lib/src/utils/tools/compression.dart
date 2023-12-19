import 'dart:io';
import 'dart:ui' as ui show Image;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:video_compress/video_compress.dart';

import '../../components/organisms/temp_directory/resolver.dart';

/// Compression Profile
///
/// This provides information on compression parameters
///
@immutable
class Compression {
  /// Default constructor
  const Compression({
    required this.maxFileSize,
    required this.minWidth,
    required this.minHeight,
    required this.quality,
    this.inSampleSize = 1,
    this.rotate = 0,
    this.autoCorrectionAngle = true,
    this.keepExif = false,
    this.numberOfRetries = 5,
    this.format = CompressFormat.jpeg,
  })  : assert(1 <= quality && quality <= 100, 'quality must be between 1 and 100.'),
        assert(minWidth > 0, 'minWidth must be greater than 0.'),
        assert(inSampleSize > 0, 'inSampleSize must be greater than 0.'),
        assert(minHeight > 0, 'minHeight must be greater than 0.');

  /// Efficient compression with minimum values
  const Compression.standard()
      : quality = 10,
        minHeight = 1920,
        minWidth = 1080,
        maxFileSize = 0,
        inSampleSize = 1,
        rotate = 0,
        autoCorrectionAngle = true,
        keepExif = false,
        numberOfRetries = 5,
        format = CompressFormat.jpeg;

  /// Creates compression from [quality].
  const Compression.withQuality(
    this.quality, {
    this.maxFileSize = 0,
    this.minWidth = 1920,
    this.minHeight = 1080,
  })  : inSampleSize = 1,
        rotate = 0,
        autoCorrectionAngle = true,
        keepExif = false,
        numberOfRetries = 5,
        format = CompressFormat.jpeg,
        assert(1 <= quality && quality <= 100, 'quality must be between 1 and 100.'),
        assert(minWidth > 0, 'minWidth must be greater than 0.'),
        assert(minHeight > 0, 'minHeight must be greater than 0.');

  /// Creates compression from [minWidth] & [minHeight].
  const Compression.withSize({
    required this.maxFileSize,
    this.minWidth = 1920,
    this.minHeight = 1080,
  })  : quality = 10,
        inSampleSize = 1,
        rotate = 0,
        autoCorrectionAngle = true,
        keepExif = false,
        numberOfRetries = 5,
        format = CompressFormat.jpeg,
        assert(minWidth > 0, 'minWidth must be greater than 0'),
        assert(minHeight > 0, 'minHeight must be greater than 0');

  /// Compression quality. Ranges from 1-100
  ///
  /// If [format] is png, the param will be ignored in iOS
  final int quality;

  /// Minimum width of the image. Compression will be made around this width.
  final int minWidth;

  /// Minimum width of the image. Compression will be made around this height.
  final int minHeight;

  /// Maximum byte-size of the image. Default to 250Kb
  final int maxFileSize;

  /// Compress format, only used in case of images
  final CompressFormat format;

  /// The param is only support android.
  ///
  /// If set to a value > 1, requests the decoder to subsample the original image, returning a smaller image to save
  /// memory. The sample size is the number of pixels in either dimension that correspond to a single pixel in the
  /// decoded bitmap. For example, inSampleSize == 4 returns an image that is 1/4 the width/height of the original,
  /// and 1/16 the number of pixels. Any value <= 1 is treated the same as 1. Note: the decoder uses a final value
  /// based on powers of 2, any other value will be rounded down to the nearest power of 2.
  final int inSampleSize;

  /// If you need to rotate the picture, use this parameter.
  final int rotate;

  /// Modify rotate to 0 or autoCorrectionAngle to false.
  final bool autoCorrectionAngle;

  /// If this parameter is true, EXIF information is saved in the compressed result.
  /// Default value is false.
  final bool keepExif;

  /// No of retries before giving up on error.
  final int numberOfRetries;

  /// Creates a copy of this compression, but with the given fields replaced wih the new values.
  Compression copyWith({
    int? quality,
    int? minWidth,
    int? minHeight,
    int? maxFileSize,
    CompressFormat? format,
    int? inSampleSize,
    int? rotate,
    bool? autoCorrectionAngle,
    bool? keepExif,
    int? numberOfRetries,
  }) {
    return Compression(
      maxFileSize: maxFileSize ?? this.maxFileSize,
      quality: quality ?? this.quality,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      format: format ?? this.format,
      inSampleSize: inSampleSize ?? this.inSampleSize,
      rotate: rotate ?? this.rotate,
      autoCorrectionAngle: autoCorrectionAngle ?? this.autoCorrectionAngle,
      keepExif: keepExif ?? this.keepExif,
      numberOfRetries: numberOfRetries ?? this.numberOfRetries,
    );
  }
}

/// Compresses the files based on [Compression] provided.
class ZdsCompressor {
  /// Private constructor
  ZdsCompressor._();

  /// Compresses [image] and stores the image at `target`.
  ///
  /// This method compresses the image at-least once and then keeps it compressing until [Compression.maxFileSize]
  /// is reached.
  ///
  /// See also
  ///   * [Compression]
  static Future<File?> compressImage({required File image, Compression? compression}) async {
    File? compressedImage;

    try {
      compression ??= const Compression.standard();

      final int maxFileSize = compression.maxFileSize;

      final int originalSize = await image.length();
      int quality = compression.quality;

      if (kDebugMode) print('Size before compression : $originalSize');

      compressedImage = image;

      //tempFile for more compression if needed
      final String dir = await zdsTempDirectory('compressed');
      final String imageExt = compression.format == CompressFormat.jpeg
          ? 'jpeg'
          : compression.format == CompressFormat.png
              ? 'png'
              : path.extension(compressedImage.absolute.path).toLowerCase();

      final String tmpName = 'TMP_${DateTime.now().microsecondsSinceEpoch}.$imageExt';
      final File tempFile = File(path.join(dir, tmpName));

      //targetFile
      final File targetFile = File('$dir/${path.basenameWithoutExtension(image.absolute.path)}.$imageExt');
      final ui.Image decodeImage = await decodeImageFromList(image.readAsBytesSync());
      final double scaleFactor = decodeImage.height > decodeImage.width
          ? compression.minHeight / decodeImage.height
          : compression.minWidth / decodeImage.width;

      final int newHeight = (decodeImage.height * scaleFactor).toInt();
      final int newWidth = (decodeImage.width * scaleFactor).toInt();

      int compressedSize;

      /// Compress at-least once
      do {
        if (targetFile.existsSync()) await targetFile.delete();
        final XFile? processedFile = await FlutterImageCompress.compressAndGetFile(
          compressedImage?.absolute.path ?? '',
          autoCorrectionAngle: compression.autoCorrectionAngle,
          format: compression.format,
          inSampleSize: compression.inSampleSize,
          keepExif: compression.keepExif,
          minHeight: newHeight,
          minWidth: newWidth,
          numberOfRetries: compression.numberOfRetries,
          quality: quality,
          rotate: compression.rotate,
          targetFile.absolute.path,
        );

        // Return if compression failed
        if (processedFile == null) throw PlatformException(code: 'PROCESS_ERR');

        //delete existing compressed file
        if (tempFile.existsSync()) await tempFile.delete();
        compressedImage = await File(processedFile.path).copy(tempFile.path);
        compressedSize = await compressedImage.length();

        if (compressedSize > originalSize) throw PlatformException(code: 'COMPRESS_ERR');

        if (kDebugMode) print('quality after compression $quality : $compressedSize');

        quality = quality - 5;
      } while (quality >= 50 && compressedSize >= maxFileSize);

      return targetFile;
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    } finally {
      await compressedImage?.delete();
    }
  }

  /// Compresses video
  ///
  /// This method compresses the video at-least once and then keeps it compressing until [Compression.maxFileSize]
  /// is reached.
  ///
  /// See also
  ///  * [Compression]
  static Future<File?> compressVideo({
    required File video,
    required int maxFileSize,
    File? target,
    VideoQuality? quality,
  }) async {
    try {
      quality ??= VideoQuality.Res640x480Quality;

      File compressedVideo = video;
      final int originalSize = await compressedVideo.length();
      int iteration = 1;
      if (kDebugMode) print('Size before compression : $originalSize');

      int compressedSize;
      do {
        final MediaInfo? info = await VideoCompress.compressVideo(
          compressedVideo.path,
          quality: quality,
          includeAudio: true,
          frameRate: 24,
        );

        if (info == null || info.file == null) throw PlatformException(code: 'PROCESS_ERR');
        compressedVideo = info.file!;
        compressedSize = await compressedVideo.length();
        if (compressedSize > originalSize) throw PlatformException(code: 'COMPRESS_ERR');

        if (kDebugMode) print('Size after compression $iteration : $compressedSize');

        ++iteration;
      } while (compressedSize >= maxFileSize && iteration < 4);

      /// Create target file
      File? newTarget = target;
      if (newTarget == null) {
        final String fileExtension = path.extension(compressedVideo.absolute.path).toLowerCase();
        final String newName = 'VID_${DateTime.now().microsecondsSinceEpoch}$fileExtension';
        final String dir = path.dirname(compressedVideo.absolute.path);
        newTarget = File(path.join(dir, newName));
      }

      /// Delete target if exists
      if (newTarget.existsSync()) await newTarget.delete();

      /// move file to target
      final File compressed = await compressedVideo.copy(newTarget.absolute.path);

      /// Delete cached file
      if (compressedVideo.absolute.path != compressed.absolute.path) await compressedVideo.delete();

      return compressed;
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }
}
