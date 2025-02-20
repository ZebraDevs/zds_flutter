import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Converts an [Image] to a [Uint8List].
///
/// This function resolves the image and converts it to a byte array in the specified format.
///
/// [image] The image to be converted.
/// [format] The format in which to encode the image. Defaults to [ui.ImageByteFormat.png].
///
/// Returns a [Future] that completes with the byte array representation of the image.
Future<Uint8List?> imageToUint8List(Image image, {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
  final completer = Completer<ui.Image>();
  image.image.resolve(ImageConfiguration.empty).addListener(
    ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }),
  );
  final uiImage = await completer.future;
  final byteData = await uiImage.toByteData(format: format);
  return byteData?.buffer.asUint8List();
}

/// Creates a list of actions for the app bar.
///
/// This function returns a list of widgets to be used as actions in the app bar.
///
/// [undo] The callback function to be executed when the undo action is triggered.
///
/// Returns a list of [Widget]s representing the actions.
List<Widget> appBarActions({
  required void Function()? undo,
}) {
  return [
    IconButton(
      onPressed: undo,
      icon: const Icon(Icons.undo),
    ),
  ];
}
