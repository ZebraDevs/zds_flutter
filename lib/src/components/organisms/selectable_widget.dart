import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../../../zds_flutter.dart';

/// A selectable widget that can be used to select the text from the child content on long press.
///
/// Contains the implementation of the ZdsSelectableWidget class.
/// This widget allows users to select and copy text from its child content on a long press.
/// It supports both plain text and HTML content, converting HTML to plain text if necessary
class ZdsSelectableWidget extends StatefulWidget {
  /// Constructor
  const ZdsSelectableWidget({super.key, required this.child, required this.textToCopy, this.isHtmlData, this.copyable});

  /// Child widget
  final Widget child;

  /// text to be copied
  final String textToCopy;

  /// Whether the copied text is in HTML format (if it is we will convert it to plain text)
  final bool? isHtmlData;

  /// Whether the copied text is copyable
  final bool? copyable;

  @override
  State<ZdsSelectableWidget> createState() => _ZdsSelectableWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool?>('isHtmlData', isHtmlData))
      ..add(DiagnosticsProperty<bool>('copyable', copyable))
      ..add(StringProperty('textToCopy', textToCopy));
  }
}

class _ZdsSelectableWidgetState extends State<ZdsSelectableWidget> {
  bool isSelected = false;

  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  String htmlToPlainText(String htmlString) {
    final dom.Document document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.copyable ?? false)) return widget.child;
    final zeta = Zeta.of(context).colors;
    return GestureDetector(
      child: ColoredBox(color: isSelected ? zeta.primary.surface : Colors.transparent, child: widget.child),
      onLongPress: () async {
        toggleSelection();
        if (isSelected) {
          var copiedText = widget.textToCopy;
          if (widget.isHtmlData ?? false) {
            try {
              copiedText = htmlToPlainText(widget.textToCopy);
            } catch (e) {
              copiedText = widget.textToCopy;
            }
          }
          await Clipboard.setData(ClipboardData(text: copiedText));
          ScaffoldMessenger.of(context).showZdsToast(
            ZdsToast(
              rounded: false,
              title: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ComponentStrings.of(context).get('COPIED_TO_CLIPBOARD', 'Copied to Clipboard'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        Future.delayed(const Duration(seconds: 4), toggleSelection);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}
