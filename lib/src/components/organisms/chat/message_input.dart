import 'dart:async';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../zds_flutter.dart';

/// An input used in chat organism
class ZdsMessageInput extends StatefulWidget {
  /// Creates a new [ZdsMessageInput]
  const ZdsMessageInput({
    required this.placeholder,
    this.focusNode,
    this.onChange,
    this.onSubmit,
    this.onUploadFiles,
    this.onUploadError,
    this.initialValue = '',
    this.allowAttachments = false,
    this.msgLimit,
    this.maxAttachSize = 250000,
    this.allowedFileTypes = const {},
    this.maxPixelSize = 0,
    this.onVoiceNoteSubmitted,
    this.maxVoiceNoteDuration = const Duration(minutes: 1),
    this.voiceNoteFileName,
    this.allowVoiceNotes = false,
    this.postProcessors = const [ZdsFileCompressPostProcessor()],
    this.moreConfig,
    this.inlineConfig,
    this.moreOptionItemStyle = ZdsFilePickerOptionItemStyle.vertical,
    this.addAttachment,
    this.enforceSheet = true,
    super.key,
  }) : assert(
          (allowVoiceNotes && voiceNoteFileName != null) || !allowVoiceNotes,
          'A value for voiceNoteFileName must be provided if allowVoiceNotes is enabled',
        );

  /// Enables attachments to be sent as messages.
  /// Defaults to false.
  final bool allowAttachments;

  /// The message shown when no text has been entered.
  final String placeholder;

  /// The initial value of the input.
  final String initialValue;

  /// The focus node assigned to the text input.
  final FocusNode? focusNode;

  /// Called with the new value of the input whenever it is changed.
  final void Function(String value)? onChange;

  /// Called with the value of the input when the submit button is clicked.
  final void Function(String value)? onSubmit;

  /// Called whenever a file is uploaded.
  final void Function(List<XFile> file)? onUploadFiles;

  /// Called when file uploading fails.
  final void Function(BuildContext context, ZdsFilePickerConfig config, Exception exception)? onUploadError;

  /// List of processes a file should undergo post getting picked from file picker
  ///
  /// Defaults to [ZdsFileCompressPostProcessor()]
  final List<ZdsFilePostProcessor> postProcessors;

  /// Enables voice notes to be sent as messages
  ///
  /// Does not currently work on web.
  ///
  /// Defaults to false
  final bool allowVoiceNotes;

  /// Called when a voice note is submitted.
  final void Function(XFile file, Duration duration)? onVoiceNoteSubmitted;

  /// The maximum duration of a voice note.
  /// Defaults to 1 minute.
  final Duration maxVoiceNoteDuration;

  /// The file name any recorded voice note will be saved under.
  /// Must be provided if [allowVoiceNotes] is enabled.
  final String? voiceNoteFileName;

  /// The character limit for messages.
  final int? msgLimit;

  /// The maximum file size of an attachment.
  /// Defaults to 250000.
  final int maxAttachSize;

  /// The list of allowed file types for attachments.
  /// Defaults to all file types.
  final Set<String> allowedFileTypes;

  /// The maximum pixel size of any image sent as an attachment.
  final int maxPixelSize;

  /// The value of Add Attachment in localised language.
  final String? addAttachment;

  /// The value of enforceSheet is used to show bottom sheet.
  final bool enforceSheet;

  /// Custom configuration for the file picker that appears when the attachment button is clicked.
  ///
  /// If not provided, a default configuration will be used.
  ///
  /// Default config includes:
  /// maxFilesAllowed: 1,
  /// maxFileSize: widget.maxAttachSize,
  /// allowedExtensions: widget.allowedFileTypes,
  /// maxPixelSize: widget.maxPixelSize,
  /// options: [ ZdsFilePickerOptions.FILE, ZdsFilePickerOptions.GIF, ZdsFilePickerOptions.GALLERY, ZdsFilePickerOptions.VIDEO, ZdsFilePickerOptions.CAMERA],
  ///
  /// NOTE: To add a Giphy key, this object must be provided with the key.
  final ZdsFilePickerConfig? moreConfig;

  /// Custom configuration for the file picker that appears inline on the message input
  ///
  /// If not provided, a default configuration will be used.
  ///
  /// Default config includes:
  /// maxFilesAllowed: 1,
  /// maxFileSize: widget.maxAttachSize,
  /// allowedExtensions: widget.allowedFileTypes,
  /// maxPixelSize: widget.maxPixelSize,
  /// options: [ ZdsFilePickerOptions.CAMERA],
  final ZdsFilePickerConfig? inlineConfig;

  /// The style of the option items in the file picker.
  final ZdsFilePickerOptionItemStyle moreOptionItemStyle;

  @override
  ZdsMessageInputState createState() => ZdsMessageInputState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('allowAttachments', allowAttachments))
      ..add(StringProperty('placeholder', placeholder))
      ..add(StringProperty('initialValue', initialValue))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode))
      ..add(ObjectFlagProperty<void Function(String value)?>.has('onChange', onChange))
      ..add(ObjectFlagProperty<void Function(String value)?>.has('onSubmit', onSubmit))
      ..add(ObjectFlagProperty<void Function(List<XFile> file)?>.has('onUploadFiles', onUploadFiles))
      ..add(DiagnosticsProperty<bool>('allowVoiceNotes', allowVoiceNotes))
      ..add(
        ObjectFlagProperty<void Function(XFile file, Duration duration)?>.has(
          'onVoiceNoteSubmitted',
          onVoiceNoteSubmitted,
        ),
      )
      ..add(DiagnosticsProperty<Duration>('maxVoiceNoteDuration', maxVoiceNoteDuration))
      ..add(StringProperty('voiceNoteFileName', voiceNoteFileName))
      ..add(IntProperty('msgLimit', msgLimit))
      ..add(IntProperty('maxAttachSize', maxAttachSize))
      ..add(IterableProperty<String>('allowedFileTypes', allowedFileTypes))
      ..add(IntProperty('maxPixelSize', maxPixelSize))
      ..add(
        ObjectFlagProperty<void Function(BuildContext context, ZdsFilePickerConfig config, Exception exception)?>.has(
          'onUploadError',
          onUploadError,
        ),
      )
      ..add(IterableProperty<ZdsFilePostProcessor>('postProcessors', postProcessors))
      ..add(DiagnosticsProperty<ZdsFilePickerConfig?>('moreConfig', moreConfig))
      ..add(DiagnosticsProperty<ZdsFilePickerConfig?>('inlineConfig', inlineConfig))
      ..add(EnumProperty<ZdsFilePickerOptionItemStyle>('optionItemStyle', moreOptionItemStyle))
      ..add(StringProperty('addAttachment', addAttachment))
      ..add(DiagnosticsProperty<bool>('enforceSheet', enforceSheet));
  }
}

/// The state object for a [ZdsMessageInput]
class ZdsMessageInputState extends State<ZdsMessageInput> with SingleTickerProviderStateMixin {
  late TextEditingController _messageController;

  late final _inlineController = ZdsFilePickerController();

  late final _focusNode = FocusNode();

  bool __hasText = false;

  bool get _hasText => __hasText;

  set _hasText(bool value) {
    if (__hasText == value) return;
    setState(() => __hasText = value);
  }

  ZdsFilePickerConfig get _moreConfig =>
      widget.moreConfig ??
      ZdsFilePickerConfig(
        maxFilesAllowed: 1,
        maxFileSize: widget.maxAttachSize,
        allowedExtensions: widget.allowedFileTypes,
        maxPixelSize: widget.maxPixelSize,
        options: [
          ZdsFilePickerOptions.FILE,
          ZdsFilePickerOptions.GIF,
          ZdsFilePickerOptions.GALLERY,
          ZdsFilePickerOptions.VIDEO,
          ZdsFilePickerOptions.CAMERA,
        ],
      );

  ZdsFilePickerConfig get _inlineConfig =>
      widget.inlineConfig ??
      ZdsFilePickerConfig(
        maxFilesAllowed: 1,
        maxFileSize: widget.maxAttachSize,
        allowedExtensions: widget.allowedFileTypes,
        maxPixelSize: widget.maxPixelSize,
        options: [
          ZdsFilePickerOptions.CAMERA,
        ],
      );

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.initialValue);
    _hasText = _messageController.text.isNotEmpty;
    _messageController.addListener(() {
      _hasText = _messageController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onFileSelected(XFile? file) {
    if (file != null) {
      widget.onUploadFiles?.call([file]);
    }
  }

  void _onFilesChanged(List<ZdsFileWrapper> items) {
    if (items.isEmpty) {
      return;
    } else if (items.first.content is XFile) {
      _onFileSelected(items.first.content as XFile);
    }
  }

  Future<ZdsRecording?> _pickVoiceNote() async {
    final recorderKey = GlobalKey<ZdsVoiceNoteRecorderState>();
    final directory = await getTemporaryDirectory();
    if (mounted) {
      return showZdsBottomSheet<ZdsRecording>(
        enforceSheet: true,
        backgroundColor: Zeta.of(context).colors.surfaceDefault,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ZdsVoiceNoteRecorder(
                  key: recorderKey,
                  rootDirectory: directory.path,
                  maxDuration: widget.maxVoiceNoteDuration,
                  fileName: widget.voiceNoteFileName!,
                  onSubmit: (audioFile) {
                    Navigator.of(context).pop(audioFile);
                  },
                ).padding(16),
              ],
            ),
          );
        },
      ).then((value) {
        if (value == null) {
          final recordingPath = recorderKey.currentState?.recordingDestination;
          if (recordingPath != null) {
            final recording = File(recordingPath);
            if (recording.existsSync()) recording.delete();
          }
        }
        return value;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final zetaColors = Zeta.of(context).colors;
    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(minHeight: 72, maxHeight: 150),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 2,
            ),
            BoxShadow(offset: const Offset(0, 1), color: zetaColors.surfaceDefault, blurRadius: 2),
          ],
        ),
        child: Material(
          color: zetaColors.surfaceDefault,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: Row(
              children: [
                if (widget.allowAttachments)
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(ZdsIcons.add),
                    color: zetaColors.mainSubtle,
                    tooltip: ComponentStrings.of(context).get(
                      'EXPAND_MESSAGE_OPTIONS',
                      'Expand message options',
                    ),
                    onPressed: () => _pickAttachments(context),
                  ).paddingOnly(left: 8),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    maxLength: widget.msgLimit,
                    focusNode: widget.focusNode ?? _focusNode,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [LengthLimitingTextInputFormatter(widget.msgLimit)],
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: widget.placeholder,
                      hintMaxLines: 1,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    onSubmitted: (text) {
                      _sendMessage();
                    },
                    onChanged: (inputText) {
                      widget.onChange?.call(inputText);
                      _hasText = inputText.isNotEmpty;
                    },
                  ).paddingInsets(EdgeInsets.symmetric(horizontal: widget.allowAttachments ? 8 : 16, vertical: 8)),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  child: _hasText
                      ? IconButton(
                          icon: const Icon(ZdsIcons.send),
                          color: themeData.colorScheme.secondary,
                          tooltip: ComponentStrings.of(context).get('SEND_MESSAGE', 'Send message'),
                          onPressed: _sendMessage,
                        )
                      : widget.allowAttachments
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 50.0 * _inlineConfig.options.length,
                                  height: 60,
                                  child: ZdsFilePicker(
                                    useCard: false,
                                    showSelected: false,
                                    config: _inlineConfig,
                                    controller: _inlineController,
                                    optionDisplay: ZdsOptionDisplay.plain,
                                    displayStyle: ZdsFilePickerDisplayStyle.horizontal,
                                    postProcessors: widget.postProcessors,
                                    onError: widget.onUploadError,
                                    onChange: (files) {
                                      _onFilesChanged([...files]);
                                      _inlineController.items.clear();
                                    },
                                  ),
                                ),
                                if (widget.allowVoiceNotes && !kIsWeb)
                                  IconButton(
                                    icon: Icon(Icons.mic, size: 24, color: zetaColors.mainSubtle),
                                    tooltip: ComponentStrings.of(context).get(
                                      'ADD_VOICE_NOTE',
                                      'Add voice note',
                                    ),
                                    onPressed: () async {
                                      final value = await _pickVoiceNote();
                                      if (value != null) {
                                        widget.onVoiceNoteSubmitted?.call(
                                          ZdsXFile.fromFile(File(value.filePath)),
                                          value.duration,
                                        );
                                      }
                                    },
                                  ).paddingOnly(right: 8),
                              ],
                            )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    widget.onSubmit?.call(_messageController.text);
    if (widget.msgLimit != null) {
      if (_messageController.text.length < widget.msgLimit!) {
        _messageController.text = '';
      }
    } else {
      _messageController.text = '';
    }
  }

  void _pickAttachments(BuildContext context) {
    unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));
    final modalController = ZdsFilePickerController();
    final zetaColors = Zeta.of(context).colors;

    int moreItemsLength = _moreConfig.options.length;
    if (_moreConfig.options.contains(ZdsFilePickerOptions.GIF) && _moreConfig.giphyKey == null) {
      debugPrint('A Giphy key must be provided in the moreConfig object to use the Giphy option');
      moreItemsLength--;
    }

    const titleHeaderHeight = 54;
    const handleSize = 11;
    const itemHeightVertical = 84;
    const itemHeightHorizontalIndividual = 56;
    final itemHeightHorizontalTotal = itemHeightHorizontalIndividual * moreItemsLength;
    final dividerHeight = _moreConfig.options.length - 1;
    final viewInsets = MediaQuery.of(context).padding.bottom;
    final maxSheetHeight = viewInsets +
        handleSize +
        titleHeaderHeight +
        (widget.moreOptionItemStyle == ZdsFilePickerOptionItemStyle.vertical
            ? itemHeightHorizontalTotal + dividerHeight
            : itemHeightVertical);

    unawaited(
      showZdsBottomSheet<ZdsFileWrapper>(
        enforceSheet: widget.enforceSheet,
        backgroundColor: zetaColors.surfaceDefault,
        context: context,
        maxHeight: maxSheetHeight,
        builder: (_) {
          return Scaffold(
            body: Material(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 54,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Semantics(
                              identifier: 'drawer_title',
                              container: true,
                              child: Text(
                                widget.addAttachment ?? ComponentStrings.of(context).get('ADD', 'Add'),
                                style: Zeta.of(context).textStyles.h5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Semantics(
                              identifier: 'drawer_close',
                              container: true,
                              child: IconButton(
                                icon: const Icon(ZdsIcons.close, size: 20),
                                onPressed: Navigator.of(context).pop,
                                color: zetaColors.mainSubtle,
                                splashRadius: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ZdsFilePicker(
                      displayOptionItemStyle: widget.moreOptionItemStyle,
                      useCard: false,
                      config: _moreConfig,
                      showSelected: false,
                      controller: modalController,
                      onChange: (files) {
                        if (files.isNotEmpty) Navigator.of(context).pop(files.first);
                      },
                      onError: widget.onUploadError,
                      postProcessors: widget.postProcessors,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).then((value) {
        if (value != null) {
          _onFilesChanged([value]);
        }
      }),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('messageController', _messageController));
  }
}
