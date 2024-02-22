import 'package:dart_emoji/dart_emoji.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../zds_flutter.dart';

import '../chat_utils.dart';
import 'link_preview.dart';

/// Text message for [ZdsChatMessage].
class ZdsChatTextMessage extends StatelessWidget {
  /// Constructs a [ZdsChatTextMessage].
  const ZdsChatTextMessage({
    super.key,
    this.searchTerm,
    required this.content,
    this.onLinkTapped,
    this.padding = const EdgeInsets.all(12),
  });

  /// Optional search term for word to be highlighted.
  final String? searchTerm;

  /// Content of text message.
  final String content;

  /// Callback for when a link is tapped.
  ///
  /// Links do not open automatically.
  final ValueChanged<String>? onLinkTapped;

  /// Padding for content.
  ///
  /// Defaults to `EdgeInsets.all(12)`.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final List<String> urls = content.urls;
    final textStyle = EmojiUtil.hasOnlyEmojis(content.trim())
        ? Theme.of(context).textTheme.displayLarge
        : Theme.of(context).textTheme.bodyMedium;

    final zetaColors = Zeta.of(context).colors;
    final wordsMapping = Map<String, HighlightedWord>.fromEntries(
      [...urls].map((e) {
        return MapEntry(e, HighlightedWord(textStyle: textStyle?.apply(color: zetaColors.link), onTap: onLinkTapped));
      }),
    );

    if (searchTerm != null && searchTerm!.isNotEmpty) {
      wordsMapping[searchTerm!] = HighlightedWord(
        decoration: BoxDecoration(color: zetaColors.yellow, borderRadius: BorderRadius.circular(2)),
      );
    }
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: content,
            excludeSemantics: true,
            child: ZdsHighlightedText(
              overflow: TextOverflow.visible,
              text: content,
              textStyle: textStyle,
              words: wordsMapping,
            ),
          ),
          if (urls.isNotEmpty && !kIsWeb) ZdsChatLinkPreview(link: urls.first, onTap: onLinkTapped),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('searchTerm', searchTerm))
      ..add(StringProperty('textContent', content))
      ..add(ObjectFlagProperty<void Function(String link)?>.has('onLinkTapped', onLinkTapped))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }
}
