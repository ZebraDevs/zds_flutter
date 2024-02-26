import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../zds_flutter.dart';
import 'quill_toolbar.dart';

/// A custom widget for the Quill editor.
///
/// [ZdsQuillEditor] offers a customizable editor experience based on the Quill editor.
class ZdsQuillEditor extends StatelessWidget {
  /// A constructor for the Quill editor.
  const ZdsQuillEditor({
    required this.controller,
    required this.readOnly,
    this.toolbarOptions = const <QuillToolbarOption>{},
    this.quillToolbarPosition = QuillToolbarPosition.bottom,
    this.toolbarIconSize,
    this.langCode,
    this.keyboardAppearance,
    this.embedBuilders,
    this.padding = EdgeInsets.zero,
    this.autoFocus = true,
    this.expands = false,
    this.focusNode,
    this.placeholder,
    this.editorKey,
    this.toolbarColor,
    super.key,
  });

  /// Controls the text being edited in the Quill editor.
  final QuillController controller;

  /// Whether the editor is read-only or editable.
  final bool readOnly;

  /// The language code used for the toolbar, defaults to device language if null.
  final String? langCode;

  /// Defines the size of the icons in the toolbar.
  final double? toolbarIconSize;

  /// Defines the position of the toolbar in relation to the editor.
  final QuillToolbarPosition? quillToolbarPosition;

  /// Set of toolbar options to display on the editor's toolbar.
  final Set<QuillToolbarOption> toolbarOptions;

  /// Custom embed builders, for example for image or video embedding.
  final Iterable<EmbedBuilder>? embedBuilders;

  /// The appearance style of the keyboard, can be either dark or light.
  final Brightness? keyboardAppearance;

  /// Padding applied around the editor.
  final EdgeInsetsGeometry padding;

  /// If the editor should focus itself when initially displayed.
  final bool autoFocus;

  /// If the editor should expand to fill its parent's height.
  final bool expands;

  /// Represents the focus node for the editor. Useful to control focus programmatically.
  final FocusNode? focusNode;

  /// Placeholder text to be displayed when the editor is empty.
  final String? placeholder;

  /// Toolbar background color
  final Color? toolbarColor;

  /// A key to associate with the underlying editor widget.
  final GlobalKey<EditorState>? editorKey;

  @override
  Widget build(BuildContext context) {
    // Base editor configuration
    final editor = QuillEditor.basic(
      configurations: QuillEditorConfigurations(
        controller: controller,
        readOnly: readOnly,
        keyboardAppearance: keyboardAppearance ?? Brightness.light,
        embedBuilders: embedBuilders,
        padding: padding,
        autoFocus: autoFocus,
        expands: expands,
        placeholder: placeholder,
        editorKey: editorKey,
      ),
      focusNode: readOnly ? FocusNode(canRequestFocus: false) : focusNode,
    );

    // If readOnly, return just editor
    if (readOnly) return editor;

    // If not readOnly, wrap the editor in a column with the toolbar
    return Column(
      children: [
        if (quillToolbarPosition == QuillToolbarPosition.top) _buildToolbar(context),
        Expanded(child: editor),
        if (quillToolbarPosition == QuillToolbarPosition.bottom) _buildToolbar(context),
      ],
    );
  }

  /// Constructs the toolbar for the Quill editor.
  Widget _buildToolbar(BuildContext context) {
    return ZdsQuillToolbar.custom(
      context: context,
      controller: controller,
      toolbarOptions: toolbarOptions.isNotEmpty ? toolbarOptions : QuillToolbarOption.values.toSet(),
      toolbarIconSize: toolbarIconSize,
      langCode: langCode,
      toolbarColor: toolbarColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('expands', expands))
      ..add(DiagnosticsProperty<QuillController>('controller', controller))
      ..add(DiagnosticsProperty<bool>('readOnly', readOnly))
      ..add(StringProperty('langCode', langCode))
      ..add(DoubleProperty('toolbarIconSize', toolbarIconSize))
      ..add(EnumProperty<QuillToolbarPosition?>('quillToolbarPosition', quillToolbarPosition))
      ..add(IterableProperty<QuillToolbarOption>('toolbarOptions', toolbarOptions))
      ..add(IterableProperty<EmbedBuilder>('embedBuilders', embedBuilders))
      ..add(EnumProperty<Brightness?>('keyboardAppearance', keyboardAppearance))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding))
      ..add(DiagnosticsProperty<bool>('autoFocus', autoFocus))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode))
      ..add(StringProperty('placeholder', placeholder))
      ..add(ColorProperty('toolbarColor', toolbarColor))
      ..add(DiagnosticsProperty<GlobalKey<EditorState>?>('editorKey', editorKey));
  }
}
