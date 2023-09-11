import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../zds_flutter.dart';

/// A dialog with a textfield and built-in validation.
///
/// This dialog can be used to retrieve 1 String value through a Future. Validation is built-in, so the Future will
/// only return a valid value.
///
/// ```dart
/// final filterName = await showDialog<String?>(
///   context: context,
///   builder: (context) => ZdsInputDialog(
///     title: 'Save Filter',
///     hint: 'Enter filter name',
///     primaryAction: 'Save',
///     secondaryAction: 'Cancel',
///     onValidate: (value) async {
///       if (value.isEmpty) {
///         return 'This field is mandatory';
///       } else if (state.filters.contains(value) {
///         return 'This filter already exists';
///       } else {
///         return null;
///       }
///     },
///   ),
/// );
/// ```
///
/// See also:
///
///  * [ZdsModal], to create a general purpose dialog.
class ZdsInputDialog extends StatefulWidget {
  /// The title of this dialog, shown at the top.
  final String? title;

  /// The label of the textField. Recommended to use [title] instead.
  final String? labelText;

  /// The hint of the textField.
  final String? hint;

  /// How many characters can be input in the textField.
  ///
  /// If null, there will be no limit.
  final int? characterCount;

  /// The text for primary action of this dialog, which will validate the input and then close the dialog and return
  /// the Future with the value.
  ///
  /// Typically 'Save' or 'Apply'.
  final String primaryAction;

  /// The text for the button that will close this dialog and cancel any value retrieval.
  ///
  /// Typically 'Cancel'.
  final String? secondaryAction;

  /// The [TextInputAction] that will be shown in the keyboard when the user types on the textField.
  ///
  /// Defaults to [TextInputAction.done].
  final TextInputAction inputAction;

  /// Whether to autofocus on this dialog.
  ///
  /// Defaults to true.
  final bool autoFocus;

  /// Optional initial text that will pre-populate the textField.
  ///
  /// If null, [hint] will be shown.
  final String? initialText;

  /// An optional input formatter to provide validation as the user types.
  final List<TextInputFormatter>? inputFormatters;

  /// The function to be called when the user taps on the [primaryAction] button to return the value.
  ///
  /// If it returns null, validation has gone through and the Future with the value will be returned. Returning a
  /// String means validation failed, with said String being the error text.
  final Future<String?> Function(String text)? onValidate;

  /// A dialog used to retrieve 1 String value with built-in validation.
  const ZdsInputDialog({
    required this.primaryAction,
    super.key,
    this.title,
    this.labelText,
    this.hint,
    this.initialText,
    this.secondaryAction,
    this.inputAction = TextInputAction.done,
    this.autoFocus = true,
    this.inputFormatters,
    this.onValidate,
    this.characterCount,
  });

  @override
  ZdsInputDialogState createState() => ZdsInputDialogState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('labelText', labelText));
    properties.add(StringProperty('hint', hint));
    properties.add(IntProperty('characterCount', characterCount));
    properties.add(StringProperty('primaryAction', primaryAction));
    properties.add(StringProperty('secondaryAction', secondaryAction));
    properties.add(EnumProperty<TextInputAction>('inputAction', inputAction));
    properties.add(DiagnosticsProperty<bool>('autoFocus', autoFocus));
    properties.add(StringProperty('initialText', initialText));
    properties.add(IterableProperty<TextInputFormatter>('inputFormatters', inputFormatters));
    properties.add(ObjectFlagProperty<Future<String?> Function(String text)?>.has('onValidate', onValidate));
  }
}

/// State for [ZdsInputDialog].
class ZdsInputDialogState extends State<ZdsInputDialog> {
  late final TextEditingController _controller = TextEditingController();
  String? _error;
  int? _characterLeftCount;

  @override
  void initState() {
    _controller.text = widget.initialText ?? '';
    if (widget.characterCount != null) {
      _characterLeftCount = widget.characterCount! - _controller.text.length;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title != null) Text(widget.title!, style: theme.textTheme.headlineMedium),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 30),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      maxLength: widget.characterCount,
                      autofocus: widget.autoFocus,
                      textInputAction: widget.inputAction,
                      controller: _controller,
                      inputFormatters: widget.inputFormatters,
                      onChanged: (value) async {
                        await _validateText();
                      },
                      onFieldSubmitted: (_) async {
                        final error = await _validateText();
                        if ((error?.isEmpty ?? true) && mounted) {
                          await Navigator.maybePop(context, _controller.text);
                        }
                      },
                      decoration: ZdsInputDecoration(
                        labelText: widget.labelText,
                        counterText: widget.characterCount != null && _error == null
                            ? ComponentStrings.of(context)
                                .get('CHAR_LEFT', 'Characters Left {0}', args: ['$_characterLeftCount'])
                            : null,
                        hintText: widget.hint,
                        errorText: _error,
                        errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ZdsColors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (widget.secondaryAction != null)
                    ZdsButton.muted(
                      key: const Key('secondary_button'),
                      onTap: () async => Navigator.maybePop(context),
                      child: Text(widget.secondaryAction!),
                    ),
                  if (widget.secondaryAction != null) const SizedBox(width: 8),
                  ZdsButton.filled(
                    key: const Key('primary_button'),
                    onTap: _error == null
                        ? () async {
                            final error = await _validateText();
                            if ((error?.isEmpty ?? true) && mounted) {
                              await Navigator.maybePop(context, _controller.text);
                            }
                          }
                        : null,
                    child: Text(widget.primaryAction),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _validateText() async {
    final error = await widget.onValidate?.call(_controller.text);
    if (mounted) {
      setState(() {
        _error = error;
        if (widget.characterCount != null) {
          _characterLeftCount = widget.characterCount! - _controller.text.length;
        }
      });
      return error;
    }
    return null;
  }
}
