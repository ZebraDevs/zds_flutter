// TODO(thelukewalton): throwing error on mac

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../../zds_flutter.dart' hide ImagePicker;
import 'giphy_picker.dart';

export 'file_post_processor.dart';
export 'file_validator.dart';
export 'file_wrapper.dart';
export 'xfile.dart';

/// File validator
///
/// This method will be called once the file is selected
typedef ZdsFileValidator = Future<FilePickerException?> Function(
  ZdsFilePickerController controller,
  FilePickerConfig config,
  FileWrapper fileWrapper,
);

/// The configuration used in a [ZdsFilePicker].
///
/// [maxPixelSize] is used to set a maximum side dimension for an image. For example, if the [maxPixelSize] is 500,
/// images can have a maximum resolution of 500x500. Any image above this resolution will be scaled down to this size.
///
/// See also:
///
///  * [ZdsFilePicker]
class FilePickerConfig {
  /// The maximum number of files allowed.
  ///
  /// Defaults to 0.
  final int maxFilesAllowed;

  /// The allowed file extensions.
  ///
  /// If empty, all files are allowed. Defaults to empty.
  final Set<String> allowedExtensions;

  /// If the file picked is an image, its maximum side dimension once it's been selected.
  ///
  /// If 0, it will be unlimited. Defaults to unlimited size.
  final int maxPixelSize;

  /// The maximum size of a file attachment in bytes.
  ///
  /// If 0, it will be unlimited. Defaults to unlimited size.
  ///
  /// Does not apply to images if it's value in more than 250Kb,
  /// images will always be compressed with 250Kb as max size.
  final int maxFileSize;

  /// The options that will be shown in the file picker.
  ///
  /// Defaults to all of the options.
  final List<FilePickerOptions> options;

  /// Video compression quality
  ///
  /// Defaults to 3.
  /// VID_COMPRESSION_LEVEL
  /// 1 -> 1280x720 24fps
  /// 2 -> 960x540 24fps
  /// 3 -> 640x480 24fps
  /// 4 -> Medium 24fps
  /// 5 -> Lowest 24fps
  final int videoCompressionLevel;

  /// API Key, required to use giphy service.
  ///
  /// See https://developers.giphy.com/
  final String? giphyApiKey;

  /// Creates the configuration to use in the [ZdsFilePicker].
  const FilePickerConfig({
    this.videoCompressionLevel = 3,
    this.maxFilesAllowed = 0,
    this.maxFileSize = 0,
    this.maxPixelSize = 0,
    this.allowedExtensions = const {},
    this.giphyApiKey,
    this.options = const [
      FilePickerOptions.VIDEO,
      FilePickerOptions.FILE,
      FilePickerOptions.CAMERA,
      FilePickerOptions.GALLERY,
    ],
  })  : assert(maxPixelSize >= 0, 'maxPixelSize must be greater than or equal to 0'),
        assert(maxFileSize >= 0, 'maxFileSize must be greater than or equal to 0');

  /// Creates a copy of this [FilePickerConfig], but with the given fields replaced wih the new values.
  FilePickerConfig copyWith({
    int? videoCompressionLevel,
    int? maxFilesAllowed,
    int? maxFileSize,
    int? maxPixelSize,
    Set<String>? allowedExtensions,
    List<FilePickerOptions>? options,
  }) {
    return FilePickerConfig(
      maxFilesAllowed: maxFilesAllowed ?? this.maxFilesAllowed,
      videoCompressionLevel: videoCompressionLevel ?? this.videoCompressionLevel,
      maxFileSize: maxFileSize ?? this.maxFileSize,
      maxPixelSize: maxPixelSize ?? this.maxPixelSize,
      allowedExtensions: allowedExtensions ?? this.allowedExtensions,
      options: options ?? this.options,
    );
  }

  /// Returns true if any of the [allowedExtensions] is for the video
  bool allowVideos() {
    if (allowedExtensions.isEmpty) {
      return true;
    } else {
      return UniversalPlatform.isAndroid
          ? allowedExtensions.intersection(<String>{'mp4'}).isNotEmpty
          : allowedExtensions.intersection(<String>{'mov'}).isNotEmpty;
    }
  }

  /// Returns true if any of the [allowedExtensions] is for the image
  bool allowImages() {
    return allowedExtensions.isEmpty || allowedExtensions.intersection(<String>{'jpg', 'jpeg', 'png'}).isNotEmpty;
  }
}

/// Whether to display the [ZdsFilePicker] as a horizontal row or vertical column.
enum ZdsFilePickerDisplayStyle {
  ///Displays [ZdsFilePicker] as a horizontal row.
  horizontal,

  ///Displays [ZdsFilePicker] as a vertical column.
  vertical,
}

/// UI Variants of the [ZdsFilePicker].
enum ZdsOptionDisplay {
  /// Shows an icon above text for each File option.
  standard,

  /// Just shows icon without text for each file option.
  ///
  /// Useful for scenario's where screen space is limited.
  plain,
}

/// Shows a component that can be used to select files and display their previews.
///
/// If [showSelected] is true, the attachments will be shown. There are two ways to display attachments, either
/// vertically or horizontally
///
/// {@image <image alt='' src='../../../assets/documentation/filepicker.png'>}
///
/// See also:
///
///  * [FilePickerConfig], the configuration for this filepicker.
///  * [FilePicker], the interface this widget uses to select a file.
///  * [ImagePicker], a widget used to select a single image and show its preview.
///  * [ZdsFilePreview], which this component uses to show previews of the selected files.
class ZdsFilePicker extends StatefulWidget {
  /// Whether to use a default card background. If false, uses a transparent background.
  ///
  /// Defaults to true.
  final bool useCard;

  /// Whether to show the selected files.
  ///
  /// Defaults to true.
  final bool showSelected;

  /// Whether to show the picker option label.
  ///
  /// Defaults to true.
  final ZdsOptionDisplay optionDisplay;

  /// Whether to show the attachments in a horizontal or vertical list.
  final ZdsFilePickerDisplayStyle? displayStyle;

  /// The visual density of this card.
  ///
  /// Defaults to [VisualDensity.standard].
  final VisualDensity? visualDensity;

  /// The configuration for this file picker.
  final FilePickerConfig config;

  /// The controller attached to this file picker.
  final ZdsFilePickerController controller;

  /// A function called whenever the selected items change, i.e. an item gets removed or added.
  final void Function(List<FileWrapper> items)? onChange;

  /// Whether to allow the user to give a name to the links attached.
  ///
  /// Defaults to true.
  final bool showLinkName;

  /// List of processes a file should undergo post getting picked from file picker
  ///
  /// Defaults to [zds DefaultPostProcessors]
  final List<ZdsFilePostProcessor>? postProcessors;

  /// Validations that are needed to be performed on a file
  ///
  /// Defaults to [zdsValidator]
  final ZdsFileValidator? validator;

  /// A function called whenever any exception is thrown in selection process
  ///
  /// Defaults to [zds FileError]
  final void Function(BuildContext context, FilePickerConfig config, Exception exception)? onError;

  /// Creates a component that allows to select files and can display a preview of the selected files.
  const ZdsFilePicker({
    required this.controller,
    super.key,
    this.onChange,
    this.config = const FilePickerConfig(),
    this.displayStyle = ZdsFilePickerDisplayStyle.vertical,
    this.validator = zdsValidator,
    this.onError = zdsFileError,
    this.postProcessors = zdsDefaultPostProcessors,
    this.optionDisplay = ZdsOptionDisplay.standard,
    this.showLinkName = true,
    this.showSelected = true,
    this.useCard = true,
    this.visualDensity = VisualDensity.standard,
  });

  @override
  ZdsFilePickerState createState() => ZdsFilePickerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('useCard', useCard));
    properties.add(DiagnosticsProperty<bool>('showSelected', showSelected));
    properties.add(EnumProperty<ZdsOptionDisplay>('optionDisplay', optionDisplay));
    properties.add(EnumProperty<ZdsFilePickerDisplayStyle?>('displayStyle', displayStyle));
    properties.add(DiagnosticsProperty<VisualDensity?>('visualDensity', visualDensity));
    properties.add(DiagnosticsProperty<FilePickerConfig>('config', config));
    properties.add(DiagnosticsProperty<ZdsFilePickerController>('controller', controller));
    properties.add(ObjectFlagProperty<void Function(List<FileWrapper> items)?>.has('onChange', onChange));
    properties.add(DiagnosticsProperty<bool>('showLinkName', showLinkName));
    properties.add(IterableProperty<ZdsFilePostProcessor>('postProcessors', postProcessors));
    properties.add(ObjectFlagProperty<ZdsFileValidator?>.has('validator', validator));
    properties.add(
      ObjectFlagProperty<void Function(BuildContext context, FilePickerConfig config, Exception exception)?>.has(
        'onError',
        onError,
      ),
    );
  }
}

///State fot [ZdsFilePicker].
class ZdsFilePickerState extends State<ZdsFilePicker> with AutomaticKeepAliveClientMixin {
  bool __busy = false;

  bool get _busy => __busy;

  set _busy(bool busy) {
    if (!mounted || __busy == busy) return;
    setState(() {
      __busy = busy;
    });
  }

  /// Current [ZdsFilePickerController] for this state
  ZdsFilePickerController get controller => widget.controller;

  /// Current [FilePickerConfig] for this state
  FilePickerConfig get config => widget.config;

  List<FilePickerOptions> get _allowedOptions {
    final list = [...config.options];
    if (config.giphyApiKey == null || config.giphyApiKey!.isEmpty) {
      list.remove(FilePickerOptions.GIF);
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (mounted) {
        widget.onChange?.call(controller.items);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final maxFiles = config.maxFilesAllowed;
    final busy = _busy || controller.busy;
    final attachmentList = controller.items.where((element) => !element.isLink).toList();
    final disableWidget = _busy || controller.busy || (maxFiles != 0 && maxFiles <= attachmentList.length);
    final content = AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ZdsAbsorbPointer(
            absorbing: busy,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showSelected && (controller.items.isNotEmpty)) ...[
                  _buildAttachments(),
                  if (widget.displayStyle == ZdsFilePickerDisplayStyle.vertical) const Divider(),
                ],
                ZdsAbsorbPointer(
                  absorbing: disableWidget,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _allowedOptions
                        .map((option) => _buildOption(context, option))
                        .toList()
                        .divide(_divider)
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          if (_busy || controller.busy)
            const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
        ],
      ),
    );

    if (widget.useCard) {
      return ZdsCard(padding: EdgeInsets.zero, child: content);
    } else {
      return content;
    }
  }

  /// Builds a [ZdsFilePicker as a horizontal row.
  Widget _buildHorizontalDisplay({double height = 120}) {
    if (controller.items.isEmpty) return const SizedBox();
    return SizedBox(
      height: height,
      child: Builder(
        builder: (context) {
          return DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!,
            child: ZdsHorizontalList.builder(
              isReducedHeight: true,
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final fileWrapper = controller.items[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ZdsFilePreview(
                      file: fileWrapper,
                      size: height * 0.7,
                      onDelete: () => controller.removeFile(fileWrapper),
                      onTap: () async => controller.openFile(context, config, fileWrapper),
                    ),
                    if (fileWrapper.content is XFile) ZdsFileSize(file: fileWrapper.content as XFile),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Builds a [ZdsFilePicker] as a vertical column.
  Widget _buildVerticalDisplay() {
    if (controller.items.isEmpty) return const SizedBox();
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.items.length,
      separatorBuilder: (_, __) => const Divider(),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final wrapper = controller.items[index];
        return SwipeActionCell(
          key: ObjectKey(wrapper.hashCode),
          backgroundColor: Theme.of(context).colorScheme.surface,
          trailingActions: [
            SwipeAction(
              color: Theme.of(context).colorScheme.error,
              onTap: (handler) async => controller.openFile(context, config, wrapper),
              content: Semantics(
                focused: true,
                label: ComponentStrings.of(context).get('DELETE', 'Delete'),
                child: IconButton(
                  icon: Icon(ZdsIcons.delete, color: Theme.of(context).colorScheme.onError),
                  onPressed: () => controller.removeFile(wrapper),
                ),
              ),
            ),
          ],
          child: Semantics(
            hint: ComponentStrings.of(context).get('SWIPE_TO_REVEAL_SEMANTIC', 'Swipe left to reveal actions'),
            child: ZdsListTile(
              shrinkWrap: true,
              leading: ZdsFilePreview(file: wrapper, size: 50, useCard: false),
              onTap: () async => controller.openFile(context, config, wrapper),
              title: Text(
                wrapper.name ?? ComponentStrings.of(context).get('UNKNOWN', 'Unknown'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: wrapper.content is XFile
                  ? ZdsFileSize(file: wrapper.content as XFile)
                  : wrapper.content is XUri
                      ? Text((wrapper.content as XUri).uri.toString(), maxLines: 1, overflow: TextOverflow.ellipsis)
                      : null,
              trailing: const Icon(ZdsIcons.chevron_right),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachments() {
    return widget.displayStyle == ZdsFilePickerDisplayStyle.horizontal
        ? _buildHorizontalDisplay()
        : _buildVerticalDisplay();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ZdsFilePickerController>('controller', controller));
    properties.add(DiagnosticsProperty<FilePickerConfig>('config', config));
  }
}

extension _FileWrapperIcon on FilePickerOptions {
  IconData get icon {
    final Map<FilePickerOptions, IconData> map = {
      FilePickerOptions.FILE: ZdsIcons.upload,
      FilePickerOptions.LINK: ZdsIcons.add_link,
      FilePickerOptions.GALLERY: ZdsIcons.image,
      FilePickerOptions.VIDEO: ZdsIcons.video,
      FilePickerOptions.CAMERA: ZdsIcons.camera,
      FilePickerOptions.GIF: Icons.gif_box_outlined,
    };

    return map[this] ?? Icons.error;
  }

  String getLabel(BuildContext context) {
    final Map<FilePickerOptions, String> map = {
      FilePickerOptions.FILE: ComponentStrings.of(context).get('FILE', 'File'),
      FilePickerOptions.LINK: ComponentStrings.of(context).get('LINK', 'Link'),
      FilePickerOptions.GALLERY: ComponentStrings.of(context).get('GALLERY', 'Gallery'),
      FilePickerOptions.VIDEO: ComponentStrings.of(context).get('VIDEO', 'Video'),
      FilePickerOptions.CAMERA: ComponentStrings.of(context).get('CAMERA', 'Camera'),
      FilePickerOptions.GIF: ComponentStrings.of(context).get('GIF', 'Gif'),
    };

    return map[this] ?? '';
  }
}

extension _Methods on ZdsFilePickerState {
  Future<void> handleOptionAction(BuildContext context, FilePickerOptions option) async {
    if (option == FilePickerOptions.FILE) {
      await _handleFileAction(context);
    } else if (option == FilePickerOptions.LINK) {
      await _handleLinkAction(context);
    } else if (option == FilePickerOptions.GALLERY) {
      await _handleGalleryAction(context);
    } else if (option == FilePickerOptions.VIDEO) {
      await _handleVideoAction(context);
    } else if (option == FilePickerOptions.CAMERA) {
      await _handleCameraAction(context);
    } else if (option == FilePickerOptions.GIF) {
      await _handleGifAction(context);
    }
  }

  Future<void> _handleLinkAction(BuildContext context) async {
    String? isValidUrl(Uri? uri) {
      final urlExp = RegExp(r'(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?');
      final url = uri.toString();
      if (uri == null || !uri.isAbsolute || !urlExp.hasMatch(url)) {
        return ComponentStrings.of(context).get('URL_INVALID_ER', 'Please enter valid URL.');
      } else {
        return null;
      }
    }

    final result = await showDialog<List<_TextField>?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final strings = ComponentStrings.of(context);
        return _MultiInputDialog(
          title: strings.get('ADD_URL', 'Add url'),
          textFields: [
            if (widget.showLinkName)
              _TextField(id: 'name', hint: strings.get('LINK_NAME', 'Link Name'), autoFocus: true),
            _TextField(id: 'url', hint: strings.get('LINK_URL', 'Link URL'), autoFocus: true),
          ],
          primaryAction: strings.get('SAVE', 'Save'),
          secondaryAction: strings.get('CANCEL', 'Cancel'),
          onValidate: (field) {
            if (field.id == 'url') {
              return isValidUrl(Uri.tryParse(field.value));
            } else {
              return null;
            }
          },
        );
      },
    );

    if (result != null) {
      final urlField = result.last;
      final nameField = result.length == 2 ? result.first : null;
      final uri = Uri.tryParse(urlField.value);
      if (uri != null) {
        final name = nameField?.value ?? '';
        controller.addFiles([
          FileWrapper(FilePickerOptions.LINK, XUri(uri: uri, name: name.isEmpty ? uri.toString() : name)),
        ]);
      }
    }
  }

  Future<void> _handleGifAction(BuildContext context) async {
    final GiphyGif? gif = await Navigator.push<GiphyGif?>(
      context,
      MaterialPageRoute<GiphyGif?>(
        builder: (context) => ZdsGiphyPicker(apiKey: config.giphyApiKey ?? ''),
      ),
    );

    try {
      if (gif == null) return;
      _busy = true;
      if (mounted) await onPicked(context, FileWrapper(FilePickerOptions.GIF, gif));
    } on Exception catch (e) {
      if (mounted) widget.onError?.call(context, config, e);
    } finally {
      _busy = false;
    }
  }

  Future<void> _handleCameraAction(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null && mounted) {
        final FileWrapper file = FileWrapper(FilePickerOptions.CAMERA, photo);
        await onPicked(context, file);
      }
    } on Exception catch (e) {
      if (mounted) widget.onError?.call(context, config, e);
    } finally {
      _busy = false;
    }
  }

  Future<void> _handleVideoAction(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final video = await picker.pickVideo(source: ImageSource.camera);

      if (video != null && mounted) {
        final FileWrapper file = FileWrapper(FilePickerOptions.VIDEO, video);
        await onPicked(context, file);
      }
    } on Exception catch (e) {
      if (mounted) widget.onError?.call(context, config, e);
    } finally {
      _busy = false;
    }
  }

  /// Picks media from gallery
  ///
  /// Allow to pick media if allowed extensions are empty.
  /// Else checks based on allowed types.
  Future<void> _handleGalleryAction(BuildContext context) async {
    var fileType = FileType.media;

    final allowImages = config.allowImages();
    final allowVideos = config.allowVideos();

    if (allowImages && allowVideos) {
      fileType = FileType.media;
    } else if (allowImages) {
      fileType = FileType.image;
    } else if (allowVideos) {
      fileType = FileType.video;
    } else {
      return;
    }

    await _handleFileAction(context, type: fileType, option: FilePickerOptions.GALLERY);
  }

  Future<void> _handleFileAction(
    BuildContext context, {
    FileType type = FileType.any,
    FilePickerOptions option = FilePickerOptions.FILE,
  }) async {
    try {
      final allowedFileExt = Set<String>.from(config.allowedExtensions);
      final maxFilesAllowed = config.maxFilesAllowed;
      final allowMultiple = maxFilesAllowed == 0 || maxFilesAllowed > 1;
      final mutableType = type == FileType.any
          ? allowedFileExt.isNotEmpty
              ? FileType.custom
              : type
          : type;

      _busy = true;

      final result = mutableType == FileType.custom
          ? await FilePicker.platform.pickFiles(
              type: mutableType,
              allowedExtensions: List.from(allowedFileExt),
              allowMultiple: allowMultiple,
            )
          : await FilePicker.platform.pickFiles(
              type: mutableType,
              allowMultiple: allowMultiple,
            );

      if (result != null && mounted) {
        for (final file in result.files) {
          if (maxFilesAllowed != 0 &&
              controller.items.where((element) => !element.isLink).toList().length >= maxFilesAllowed) break;
          if (kIsWeb) {
            final mimeType = lookupMimeType(file.name);
            final xfile = XFile.fromData(file.bytes!, name: file.name, length: file.size, mimeType: mimeType);
            await onPicked(context, FileWrapper(option, xfile));
          } else {
            final mimeType = lookupMimeType(file.path ?? '');
            final xfile = XFile(file.path!, name: file.name, length: file.size, mimeType: mimeType);
            await onPicked(context, FileWrapper(option, xfile));
          }
        }
      }
    } on Exception catch (e) {
      if (mounted) widget.onError?.call(context, config, e);
    } finally {
      _busy = false;
    }
  }

  Future<void> onPicked(BuildContext context, FileWrapper file) async {
    try {
      if (file.content == null) return;
      _busy = true;

      final exception = await widget.validator?.call(controller, config, file);

      var input = file;
      if (exception == null && widget.postProcessors != null) {
        for (final p in widget.postProcessors!) {
          input = await p.process(config, input);
        }
      }

      if (exception != null && mounted) {
        widget.onError?.call(context, config, exception);
      } else {
        controller.addFiles([input]);
      }
    } on Exception catch (e) {
      if (mounted) widget.onError?.call(context, config, e);
    } finally {
      _busy = false;
    }
  }
}

extension on ZdsFilePickerState {
  Widget get _divider {
    return widget.optionDisplay == ZdsOptionDisplay.standard
        ? Container(
            height: widget.visualDensity == VisualDensity.standard ? 40 : 26,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: ZdsColors.greySwatch(context)[400] ?? ZdsColors.lightGrey),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildOption(BuildContext context, FilePickerOptions option) {
    final bool isStandard = widget.visualDensity == VisualDensity.standard;
    final style = isStandard
        ? Theme.of(context).textTheme.bodyMedium
        : Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, height: 16 / 12);
    final padding = 16 + ((widget.visualDensity?.vertical ?? 0) * 4);
    return Expanded(
      child: Semantics(
        button: true,
        enabled: true,
        child: InkResponse(
          radius: widget.optionDisplay == ZdsOptionDisplay.plain
              ? isStandard
                  ? 24
                  : 20
              : isStandard
                  ? 40
                  : 30,
          onTap: () async => handleOptionAction(context, option),
          child: Column(
            children: [
              Icon(
                option.icon,
                size: 24 + ((widget.visualDensity?.vertical ?? 0) * 4),
                color: ZetaColors.of(context).textSubtle,
              ),
              if (widget.optionDisplay == ZdsOptionDisplay.standard) ...[
                SizedBox(height: 10 + ((widget.visualDensity?.vertical ?? 0) * 4)),
                Text(
                  option.getLabel(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style?.copyWith(color: ZdsColors.greySwatch(context)[800]),
                  textScaleFactor: MediaQuery.of(context).textScaleFactor > 2.7 ? 2.7 : null,
                ),
              ],
            ],
          ).paddingInsets(EdgeInsets.symmetric(vertical: padding)),
        ),
      ),
    );
  }
}

/// A controller used with [ZdsFilePicker] to keep track and use the selected files.
///
/// See also:
///
///  * [ZdsFilePicker]
class ZdsFilePickerController extends ChangeNotifier {
  bool _busy = false;

  /// Busy state indicator
  bool get busy => _busy;

  set busy(bool busy) {
    if (_busy == busy) return;
    _busy = busy;
    notifyListeners();
  }

  /// The selected files.
  List<FileWrapper> items = [];

  /// file from server to check itemCount only
  List<dynamic> remoteItems = [];

  /// Programmatically adds a list of files to the linked [ZdsFilePicker].
  void addFiles(List<FileWrapper> files) {
    items += files;
    notifyListeners();
  }

  /// Programmatically removes files from the linked [ZdsFilePicker].
  int removeFile(FileWrapper file, {bool notify = true}) {
    final index = items.indexWhere((element) => element == file);
    if (index >= 0) {
      items.removeAt(index);
      if (notify) notifyListeners();
    }

    return index;
  }

  /// Opens the provided file.
  ///
  /// Opens links in an InAppWebView, otherwise opens the file using the native viewer.
  Future<void> openFile(BuildContext context, FilePickerConfig config, FileWrapper file) async {
    if (file.content != null && file.content is XFile) {
      final fileToOpen = file.content as XFile;
      if (file.isImage()) {
        // Edit the file
        final editPostProcessor = ZdsFileEditPostProcessor(() => context);
        final editedFile = await editPostProcessor.process(config, file);
        if (editedFile.content != file.content) {
          const compressPostProcessor = ZdsFileCompressPostProcessor();
          final compressedFile = await compressPostProcessor.process(config, editedFile);
          final index = removeFile(file);
          items.insert(index, compressedFile);
          notifyListeners();
        }
      } else {
        await OpenFilex.open(fileToOpen.path);
      }
    }
  }
}

class _TextField {
  _TextField({this.id, this.hint, this.autoFocus = false});

  final dynamic id;
  final String? hint;
  bool autoFocus = false;
  String value = '';
  String? error;
}

class _MultiInputDialog extends StatefulWidget {
  final String? title;
  final String primaryAction;
  final String? secondaryAction;
  final List<_TextField> textFields;
  final String? Function(_TextField)? onValidate;

  const _MultiInputDialog({
    required this.textFields,
    required this.primaryAction,
    this.title,
    this.secondaryAction,
    this.onValidate,
  });

  @override
  _MultiInputDialogState createState() => _MultiInputDialogState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('primaryAction', primaryAction));
    properties.add(StringProperty('secondaryAction', secondaryAction));
    properties.add(IterableProperty<_TextField>('textFields', textFields));
    properties.add(ObjectFlagProperty<String? Function(_TextField p1)?>.has('onValidate', onValidate));
  }
}

class _MultiInputDialogState extends State<_MultiInputDialog> {
  bool get isValid => widget.textFields.fold<bool>(true, (p, r) => p && (widget.onValidate?.call(r) == null));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.title != null) Text(widget.title!, style: theme.textTheme.displaySmall),
              if (widget.textFields.isEmpty) const SizedBox(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.textFields.length,
                itemBuilder: (BuildContext context, int index) {
                  return TextFormField(
                    autofocus: widget.textFields[index].autoFocus,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      setState(() {
                        widget.textFields[index].value = value;
                      });
                    },
                    onFieldSubmitted: (value) => widget.textFields[index].value = value,
                    validator: (value) => widget.onValidate?.call(widget.textFields[index]),
                    decoration: ZdsInputDecoration(
                      hintText: widget.textFields[index].hint,
                      errorText: widget.textFields[index].error,
                      errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ZdsColors.red),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (widget.secondaryAction != null)
                    ZdsButton.muted(
                      child: Text(widget.secondaryAction!),
                      onTap: () async => Navigator.maybePop(context),
                    ),
                  if (widget.secondaryAction == null) const Spacer(),
                  const SizedBox(width: 16),
                  ZdsButton(
                    onTap: isValid
                        ? () {
                            if (isValid) {
                              unawaited(Navigator.maybePop(context, widget.textFields));
                            }
                          }
                        : null,
                    child: Text(widget.primaryAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isValid', isValid));
  }
}
