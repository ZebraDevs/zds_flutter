import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines what occurrence you want to highlight
enum HighlightBinding {
  /// Highlights all occurrences of a word
  all,

  /// Highlights only the first occurrence
  first,

  /// Highlights only the last occurrence
  last,
}

/// It stores the layout data about a word
class HighlightedWord {
  /// Constructs a [HighlightedWord].
  HighlightedWord({this.textStyle, this.onTap, this.decoration, this.padding});

  /// Text style of highlighted word.
  final TextStyle? textStyle;

  /// Called when highlighted word is tapped.
  final void Function(String link)? onTap;

  /// Decoration for highlighted word.
  final BoxDecoration? decoration;

  /// Padding for highlighted word.
  final EdgeInsetsGeometry? padding;
}

/// Displays a block of text with certain words highlighted.
class ZdsHighlightedText extends StatelessWidget {
  /// Constructs a [ZdsHighlightedText].
  const ZdsHighlightedText({
    required this.text,
    required this.words,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.matchCase = false,
    this.binding = HighlightBinding.all,
    super.key,
  });

  /// Total text to display.
  final String text;

  /// Words to highlight.
  final Map<String, HighlightedWord> words;

  /// Style for unhighlighted text.
  final TextStyle? textStyle;

  /// See [Text.textAlign].
  ///
  /// Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// See [Text.textDirection].
  final TextDirection? textDirection;

  /// See [Text.softWrap].
  ///
  /// Defaults to `true`.
  final bool softWrap;

  /// See [Text.overflow].
  ///
  /// Defaults to  [TextOverflow.clip].
  final TextOverflow overflow;

  /// See [Text.maxLines].
  final int? maxLines;

  /// See [Text.locale].
  final Locale? locale;

  /// See [Text.strutStyle].
  final StrutStyle? strutStyle;

  /// If the search matches strictly with cases or not.
  ///
  /// Defaults to `false`.
  final bool matchCase;

  /// See [HighlightBinding].
  ///
  /// Defaults to [HighlightBinding.all].
  final HighlightBinding binding;

  @override
  Widget build(BuildContext context) {
    if (words.isNotEmpty) {
      return RichText(
        text: _buildSpan(_textWords, context),
        locale: locale,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
      );
    } else {
      return Text(
        text,
        style: textStyle,
        locale: locale,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
      );
    }
  }

  List<String> get _textWords {
    final split = text.split(' ');
    final list = <String>[];
    for (final s in split) {
      list
        ..add(s)
        ..add(' ');
    }
    list.removeLast();
    return list;
  }

  TextSpan _buildSpan(List<String> boundWords, BuildContext context) {
    if (boundWords.isEmpty) return const TextSpan();

    return TextSpan(
      children: _getChildTextSpan(boundWords, context),
    );
  }

  List<TextSpan> _getChildTextSpan(List<String> boundWords, BuildContext context) {
    final list = <TextSpan>[];
    for (final text in boundWords) {
      final textTrimmed = text.trim();
      if (words.containsKey(textTrimmed)) {
        final x = words[textTrimmed];
        final y = Text(text, style: x?.textStyle ?? textStyle);
        list.add(
          TextSpan(
            children: [
              WidgetSpan(
                child: DecoratedBox(
                  decoration: x?.decoration ?? const BoxDecoration(),
                  child: InkWell(
                    child: y,
                    onTap: () {
                      x?.onTap?.call(text);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        list.add(TextSpan(text: text, style: textStyle));
      }
    }
    return list;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('text', text))
      ..add(DiagnosticsProperty<Map<String, HighlightedWord>>('words', words))
      ..add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(DiagnosticsProperty<bool>('softWrap', softWrap))
      ..add(EnumProperty<TextOverflow>('overflow', overflow))
      ..add(IntProperty('maxLines', maxLines))
      ..add(DiagnosticsProperty<Locale?>('locale', locale))
      ..add(DiagnosticsProperty<StrutStyle?>('strutStyle', strutStyle))
      ..add(DiagnosticsProperty<bool>('matchCase', matchCase))
      ..add(EnumProperty<HighlightBinding>('binding', binding))
      ..add(DiagnosticsProperty<TextDirection?>('textDirection', textDirection));
  }
}
