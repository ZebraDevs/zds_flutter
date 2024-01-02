import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../zds_flutter.dart';

/// A button that can be used to select an image and show its preview.
///
/// This component shows [icon] when no image has been selected. Once an image is selected, an image preview will be
/// shown instead. It's possible to reselect a different image once an image has been chosen by tapping on the component
/// again.
///
/// See also:
///
///  * [ZdsFilePicker], used to select a variety of files.
class ImagePicker extends StatefulWidget {
  /// A button that can be used to select an image and show its preview.
  const ImagePicker({
    required this.backgroundColor,
    required this.icon,
    super.key,
    this.size = 64,
    this.onChange,
    this.showBorder = true,
    this.image,
    this.onPermissionDenied,
  });

  /// The side dimension of this component.
  ///
  /// Defaults to 64.
  final double size;

  /// Function called whenever the chosen image changes.
  ///
  /// Use this to synchronize the image chosen in the parent's state.
  final void Function(String)? onChange;

  /// A function called whenever the permission to access the gallery is denied.
  final void Function()? onPermissionDenied;

  /// Whether to show a border.
  ///
  /// Defaults to true.
  final bool showBorder;

  /// The background color.
  final Color backgroundColor;

  /// The icon that will be shown in the center of this image picker.
  final Icon icon;

  /// An optional default image to this image picker.
  final Image? image;

  @override
  ImagePickerState createState() => ImagePickerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('size', size))
      ..add(ObjectFlagProperty<void Function(String p1)?>.has('onChange', onChange))
      ..add(ObjectFlagProperty<void Function()?>.has('onPermissionDenied', onPermissionDenied))
      ..add(DiagnosticsProperty<bool>('showBorder', showBorder))
      ..add(ColorProperty('backgroundColor', backgroundColor));
  }
}

/// State for [ImagePicker].
class ImagePickerState extends State<ImagePicker> {
  String _imagePath = '';

  Future<void> _pickImage() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && mounted) {
        setState(() {
          _imagePath = result.files.single.path!;
        });
        widget.onChange?.call(_imagePath);
      }
    } on PlatformException catch (_) {
      if (widget.onPermissionDenied != null) {
        widget.onPermissionDenied?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _imagePath == ''
          ? ComponentStrings.of(context).get('IMAGE_PICKER_SEMANTIC_UNSELECTED', 'Image Picker. No image selected')
          : ComponentStrings.of(context).get('IMAGE_PICKER_SEMANTIC_SELECTED', 'Image Picker. Image selected'),
      onTapHint: _imagePath == ''
          ? ComponentStrings.of(context).get('PICK_IMAGE', 'Pick Image')
          : ComponentStrings.of(context).get('CHANGE_IMAGE', 'Change Image'),
      button: true,
      child: Material(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: InkWell(
          onTap: _pickImage,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: widget.showBorder ? Border.all(color: Theme.of(context).colorScheme.secondary) : null,
            ),
            child: !(_imagePath == '')
                ? _ImageContainer(
                    Image.file(
                      File(_imagePath),
                    ),
                  )
                : widget.image != null
                    ? _ImageContainer(
                        widget.image!,
                      )
                    : widget.icon,
          ),
        ),
      ),
    );
  }
}

class _ImageContainer extends StatelessWidget {
  const _ImageContainer(this.image);
  final Image image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: FittedBox(fit: BoxFit.cover, child: image),
    );
  }
}
