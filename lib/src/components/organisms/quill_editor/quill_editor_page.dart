import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';

import '../../../../zds_flutter.dart';
import 'quill_toolbar.dart';

/// Default options for ZDS Quill Toolbar
final zdsQuillToolbarOptions = QuillToolbarOption.values.toSet();

/// Represents a Quill editor page.
class ZdsQuillEditorPage extends StatefulWidget {
  /// Constructs a [ZdsQuillEditorPage] with private constructor.
  ///
  /// This ensures the widget is instantiated using the [edit] method.
  const ZdsQuillEditorPage._({
    required this.title,
    required this.toolbarOptions,
    required this.readOnly,
    required this.showClearFormatAsFloating,
    this.quillToolbarPosition,
    this.toolbarIconSize = kDefaultIconSize,
    this.langCode,
    this.charLimit = 10000,
    this.placeholder = '',
    this.initialDelta,
  });

  /// The title displayed in the editor's AppBar.
  final String title;

  /// Determines if the editor should be read-only.
  final bool readOnly;

  /// The language code for localization purposes.
  final String? langCode;

  /// The maximum number of characters allowed in the editor.
  final int charLimit;

  /// The size of the toolbar icons.
  final double toolbarIconSize;

  /// The position of the toolbar, either at the top or bottom.
  final QuillToolbarPosition? quillToolbarPosition;

  /// The initial content for the editor.
  final ZdsQuillDelta? initialDelta;

  /// A placeholder text for the editor when it's empty.
  final String? placeholder;

  /// Set of toolbar options for customization.
  final Set<QuillToolbarOption> toolbarOptions;

  /// Decides the visibility of the clear formatting floating button.
  ///
  /// Defaults to true.
  final bool showClearFormatAsFloating;

  /// Navigates to the editor page for creating or editing content.
  ///
  /// Returns a [ZdsQuillDelta] representing the edited content or null if the user cancels the operation.
  static Future<ZdsQuillDelta?> edit(
    BuildContext context, {
    required String title,
    String? langCode,
    String? placeholder,
    int charLimit = 10000,
    bool readOnly = false,
    ZdsQuillDelta? initialDelta,
    double toolbarIconSize = kDefaultIconSize,
    bool fullscreenDialog = true,
    bool showClearFormatAsFloating = true,
    Set<QuillToolbarOption>? toolbarOptions,
    QuillToolbarPosition? quillToolbarPosition = QuillToolbarPosition.bottom,
  }) {
    return Navigator.of(context).push<ZdsQuillDelta>(
      MaterialPageRoute<ZdsQuillDelta>(
        fullscreenDialog: fullscreenDialog,
        builder: (BuildContext context) {
          return ZdsQuillEditorPage._(
            title: title,
            readOnly: readOnly,
            charLimit: charLimit,
            placeholder: placeholder,
            toolbarIconSize: toolbarIconSize,
            quillToolbarPosition: quillToolbarPosition,
            showClearFormatAsFloating: showClearFormatAsFloating,
            toolbarOptions: toolbarOptions ?? zdsQuillToolbarOptions,
            langCode: langCode ?? ComponentStrings.of(context).locale.toString(),
            initialDelta: initialDelta?.copyWith(document: initialDelta.document),
          );
        },
      ),
    );
  }

  @override
  State<ZdsQuillEditorPage> createState() => _ZdsQuillEditorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('readOnly', readOnly))
      ..add(StringProperty('title', title))
      ..add(StringProperty('langCode', langCode))
      ..add(IntProperty('charLimit', charLimit))
      ..add(DoubleProperty('toolbarIconSize', toolbarIconSize))
      ..add(EnumProperty<QuillToolbarPosition?>('quillToolbarPosition', quillToolbarPosition))
      ..add(DiagnosticsProperty<ZdsQuillDelta?>('initialDelta', initialDelta))
      ..add(StringProperty('placeholder', placeholder))
      ..add(IterableProperty<QuillToolbarOption>('toolbarOptions', toolbarOptions))
      ..add(DiagnosticsProperty<bool>('showClearFormatAsFloating', showClearFormatAsFloating));
  }
}

class _ZdsQuillEditorState extends State<ZdsQuillEditorPage> with FrameCallbackMixin {
  /// Builder for handling uncaught Flutter errors in the widget.
  ErrorWidgetBuilder? _originalErrorWidgetBuilder;

  /// Key to reference the shake animation, used for providing feedback when char limit is exceeded.
  final GlobalKey<ZdsShakeAnimationState> _shakeKey = GlobalKey<ZdsShakeAnimationState>();

  /// Controller for managing the Quill editor's content.
  late final quill.QuillController _quillController = quill.QuillController(
    document: widget.initialDelta?.document ?? quill.Document(),
    selection: TextSelection.collapsed(offset: widget.initialDelta?.document.length ?? 0),
    onReplaceText: _onReplaceText,
    onSelectionChanged: (textSelection) {
      if (widget.showClearFormatAsFloating) {
        showClear = textSelection.start != textSelection.end && textSelection.end != 1;
      }
    },
  );

  final FocusNode _focusNode = FocusNode();

  bool _showClear = false;

  bool get showClear => _showClear;

  set showClear(bool value) {
    if (_showClear == value) return;
    setState(() {
      _showClearPill = value;
      _showClear = value;
    });
  }

  bool _showClearPill = true;

  bool get showClearPill => _showClearPill;

  set showClearPill(bool value) {
    if (_showClearPill == value) return;
    setState(() {
      _showClearPill = value;
    });
  }

  var _withinLimit = true;
  var _animating = false;

  bool __fetchingText = false;

  bool get _fetchingText => __fetchingText;

  set _fetchingText(bool value) {
    if (__fetchingText == value) return;
    setState(() {
      __fetchingText = value;
    });
  }

  int __characters = 0;

  int get _characters => __characters;

  set _characters(int characters) {
    if (characters == __characters) return;
    setState(() {
      __characters = characters;
      _withinLimit = characters <= (widget.charLimit);
      _shakeAnimate();
    });
  }

  void _shakeAnimate() {
    if (!_withinLimit && !_animating) {
      unawaited(HapticFeedback.mediumImpact());
      _shakeKey.currentState?.shake();
    }
  }

  /// Callback when a replacement of text occurs in the editor.
  ///
  /// Used to monitor the character count.
  bool _onReplaceText(int index, int length, Object? data) {
    if (widget.charLimit != 0 && widget.charLimit != 10000) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _characters = _quillController.document.length - 1;
      });
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _quillController.dispose();
    if (_originalErrorWidgetBuilder != null) {
      ErrorWidget.builder = _originalErrorWidgetBuilder!;
    }
  }

  /// Sets up the error handling mechanisms and initializes content.
  @override
  void initState() {
    super.initState();
    _originalErrorWidgetBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_showErrorDialog());
      });
      return Center(child: ZdsImages.sadZebra);
    };

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _quillController.moveCursorToEnd();
      _onReplaceText(0, 0, null);
    });
  }

  bool _showingHtmlError = false;

  bool get showingHtmlError => _showingHtmlError;

  set showingHtmlError(bool value) {
    if (_showingHtmlError == value) return;
    setState(() {
      _showingHtmlError = value;
    });
  }

  /// Shows a dialog when unsupported styles are detected.
  Future<void> _showErrorDialog() async {
    if (showingHtmlError) return;
    showingHtmlError = true;

    final bool? value = await showDialog<bool?>(
      context: context,
      builder: (BuildContext localContext) {
        return ZdsModal(
          actions: <Widget>[
            ZdsButton.muted(
              child: Text(ComponentStrings.of(context).get('CANCEL', 'Cancel')),
              onTap: () => Navigator.of(localContext).pop(false),
            ),
            ZdsButton(
              child: Text(ComponentStrings.of(context).get('CONTINUE', 'Continue')),
              onTap: () => Navigator.of(localContext).pop(true),
            ),
          ],
          child: Text(
            ComponentStrings.of(context).get(
              'STYLE_NOT_SUPPORTED_WARNING',
              'Some styles are not supported with mobile editor, Do you want to continue with plain text?',
            ),
          ),
        );
      },
    );

    if (value != null && value) {
      final String? plainText = widget.initialDelta?.document.toPlainText();
      await _setText(plainText ?? '');
      showingHtmlError = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _quillController.moveCursorToEnd();
      });
    } else {
      if (mounted) Navigator.of(context).pop();
    }
  }

  /// Sets the editor's content from a plain text source.
  Future<void> _setText(String initialText) async {
    await initialText.toDelta().then((Delta delta) {
      _quillController.document = quill.Document.fromDelta(delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the primary editor widget.
    final Widget editor = _buildEditorWidget();

    // Create the scaffold which houses the editor.
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeData.colorScheme.surface,
      appBar: _buildAppBar(context, themeData),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            editor,
            if (showClear)
              _buildClearFormatting(context)
            else if (widget.charLimit != 0 && widget.charLimit != 10000)
              _buildCharacterCountIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildClearFormatting(BuildContext context) {
    atLast(() async {
      await Future<void>.delayed(const Duration(seconds: 2));
      showClearPill = false;
    });
    return Positioned(
      bottom: (widget.quillToolbarPosition == QuillToolbarPosition.top ? 0 : widget.toolbarIconSize) + 20,
      right: 10,
      left: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showClearPill)
            ZdsTag(child: Text(ComponentStrings.of(context).get('CLEAR_FORMATTING', 'Clear Formatting'))),
          const SizedBox(width: 4),
          FloatingActionButton(
            mini: true,
            tooltip: ComponentStrings.of(context).get('CLEAR_FORMATTING', 'Clear Formatting'),
            onPressed: null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: IconButton(
                icon: const Icon(Icons.format_clear),
                onPressed: _clearFormatting,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearFormatting() {
    final Set<quill.Attribute<dynamic>> attributes = {};
    for (final style in _quillController.getAllSelectionStyles()) {
      style.attributes.values.forEach(attributes.add);
    }
    for (final attribute in attributes) {
      _quillController.formatSelection(quill.Attribute.clone(attribute, null));
    }
  }

  Widget _buildEditorWidget() {
    if (showingHtmlError) {
      return const SizedBox();
    }

    return ZdsQuillEditor(
      autoFocus: false,
      padding: const EdgeInsets.all(14),
      controller: _quillController,
      placeholder: widget.placeholder,
      readOnly: widget.readOnly,
      langCode: widget.langCode,
      focusNode: _focusNode,
      toolbarIconSize: widget.toolbarIconSize,
      quillToolbarPosition: widget.quillToolbarPosition,
      toolbarColor: Theme.of(context).colorScheme.surface,
      toolbarOptions: <QuillToolbarOption>{...widget.toolbarOptions}
        ..remove(QuillToolbarOption.redo)
        ..remove(QuillToolbarOption.undo)
        ..remove(QuillToolbarOption.clearFormat),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData themeData) {
    final appBarFg = themeData.appBarTheme.foregroundColor ?? Colors.white;
    return AppBar(
      centerTitle: false,
      title: Text(widget.title),
      actions: <Widget>[
        if (widget.toolbarOptions.contains(QuillToolbarOption.undo))
          _HistoryButton(
            icon: Icons.undo_outlined,
            iconSize: 24,
            controller: _quillController,
            enabledColor: appBarFg,
            disabledColor: appBarFg.withOpacity(0.3),
            afterPressed: _afterUndoRedo,
            undo: true,
          ),
        if (widget.toolbarOptions.contains(QuillToolbarOption.redo))
          _HistoryButton(
            icon: Icons.redo_outlined,
            iconSize: 24,
            controller: _quillController,
            enabledColor: appBarFg,
            disabledColor: appBarFg.withOpacity(0.3),
            afterPressed: _afterUndoRedo,
            undo: false,
          ),
        const SizedBox(width: 16),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _withinLimit ? 1.0 : 0.3,
          child: _fetchingText ? _buildProgressIndicator(context) : _buildSaveButton(context),
        ),
      ],
    );
  }

  void _afterUndoRedo() {
    _onReplaceText(0, 0, null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quillController.moveCursorToEnd();
    });
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return SizedBox(
      height: 44,
      width: 44,
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return IconButton(
      icon: const Icon(ZdsIcons.check),
      tooltip: ComponentStrings.of(context).get('DONE', 'Done'),
      onPressed: () async {
        if (_withinLimit) {
          _fetchingText = true;
          Navigator.of(context).pop(ZdsQuillDelta(document: _quillController.document));
        } else {
          _shakeAnimate();
        }
      },
    );
  }

  Widget _buildCharacterCountIndicator(BuildContext context) {
    return Positioned(
      bottom: widget.quillToolbarPosition == QuillToolbarPosition.top ? 10 : widget.toolbarIconSize + 34,
      right: 10,
      left: 16,
      child: Align(
        alignment: Alignment.bottomRight,
        child: ZdsShakeAnimation(
          key: _shakeKey,
          shakeCount: 2,
          shakeOffset: 5,
          shakeDuration: const Duration(milliseconds: 350),
          onAnimationUpdate: (AnimationStatus status) {
            _animating = status == AnimationStatus.reverse || status == AnimationStatus.forward;
          },
          child: ZdsTag(
            customColor: _withinLimit ? null : Theme.of(context).colorScheme.error,
            child: Text(
              ComponentStrings.of(context).get(
                'CHAR_LEFT',
                'Characters Left {0}',
                args: <String>[
                  '${widget.charLimit - _characters}',
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('showingHtmlError', showingHtmlError))
      ..add(DiagnosticsProperty<bool>('showClear', showClear))
      ..add(DiagnosticsProperty<bool>('showClearPill', showClearPill));
  }
}

class _HistoryButton extends StatefulWidget {
  const _HistoryButton({
    required this.icon,
    required this.controller,
    required this.undo,
    required this.enabledColor,
    required this.disabledColor,
    required this.afterPressed,
    this.iconSize = kDefaultIconSize,
  });

  final Color enabledColor;
  final Color disabledColor;
  final IconData icon;
  final double iconSize;
  final bool undo;
  final VoidCallback afterPressed;
  final quill.QuillController controller;

  @override
  _HistoryButtonState createState() => _HistoryButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('enabledColor', enabledColor))
      ..add(ColorProperty('disabledColor', disabledColor))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(DiagnosticsProperty<bool>('undo', undo))
      ..add(ObjectFlagProperty<VoidCallback>.has('afterPressed', afterPressed))
      ..add(DiagnosticsProperty<quill.QuillController>('controller', controller));
  }
}

class _HistoryButtonState extends State<_HistoryButton> {
  Color? _iconColor;

  @override
  Widget build(BuildContext context) {
    _setIconColor();

    widget.controller.changes.listen((quill.DocChange event) async {
      _setIconColor();
    });

    return quill.QuillToolbarIconButton(
      isSelected: false,
      iconTheme: const quill.QuillIconTheme(),
      icon: Icon(widget.icon, size: widget.iconSize, color: _iconColor),
      onPressed: _changeHistory,
      afterPressed: widget.afterPressed,
    );
  }

  void _setIconColor() {
    if (!mounted) return;

    if (widget.undo) {
      setState(() {
        _iconColor = widget.controller.hasUndo ? widget.enabledColor : widget.disabledColor;
      });
    } else {
      setState(() {
        _iconColor = widget.controller.hasRedo ? widget.enabledColor : widget.disabledColor;
      });
    }
  }

  void _changeHistory() {
    if (widget.undo) {
      if (widget.controller.hasUndo) {
        widget.controller.undo();
      }
    } else {
      if (widget.controller.hasRedo) {
        widget.controller.redo();
      }
    }

    _setIconColor();
  }
}
