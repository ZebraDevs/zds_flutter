import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:csslib/parser.dart' hide Border, LineHeight;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_audio/flutter_html_audio.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as html;

import '../../../../zds_flutter.dart';
import 'nested_table.dart';
import 'table_html_extension.dart';
import 'video_html_extension.dart';

export 'package:html/dom.dart' show Element;

/// A widget for displaying HTML content using a WebView.
///
/// This widget takes HTML content as input and displays it in a styled format
/// using the Flutter HTML package. It supports features such as setting the
/// font size, limiting the number of displayed lines, and handling links.
class ZdsHtml extends StatelessWidget {
  /// Creates a new instance of the [ZdsHtml] widget.
  ///
  /// The [htmlText] parameter is required, and other parameters are optional.
  const ZdsHtml(
    this.htmlText, {
    super.key,
    this.fontSize,
    this.maxLines = 999,
    this.onLinkTap,
    this.extensions = const {},
    this.style = const {},
  });

  /// The HTML content to be displayed.
  final String htmlText;

  /// The maximum number of lines to display. Defaults to 5.
  final int maxLines;

  /// The font size for the HTML content. If null, the default font size is used.
  final double? fontSize;

  /// A Map of [HtmlExtension]s that add additional capabilities to flutter_html
  /// See the [HtmlExtension] class for more details.
  final Map<String, HtmlExtension> extensions;

  /// An API that allows you to override the default style for any HTML element
  final Map<String, Style> style;

  /// A callback function that is called when a link is tapped within the HTML content.
  ///
  /// The callback receives the URL of the tapped link, a map of attributes
  /// associated with the link, and the HTML element containing the link.
  final void Function(String? url, Map<String, String> attributes, html.Element? element)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final colorscheme = themeData.colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Html(
          data: htmlText,
          style: _buildStyles(context, colorscheme, box),
          extensions: <HtmlExtension>[
            _buildTableWrapper(),
            ...zdsTableTags.map((e) => extensions.get(e, fallback: const ZdsTableHtmlExtension())),
            extensions.get('video', fallback: const ZdsVideoHtmlExtension()),
            extensions.get('audio', fallback: const AudioHtmlExtension()),
            extensions.get('svg', fallback: const SvgHtmlExtension()),
            extensions.get('img', fallback: _imageExtension(box)),
            extensions.get('loader', fallback: _loader()),
            extensions.get('nestedtable', fallback: _nestedTable(context)),
            extensions.get('mediacontainer', fallback: _unknownMediaType()),
          ],
          onLinkTap: onLinkTap,
          onCssParseError: (String css, List<Message> messages) {
            debugPrint('css that errored: $css');
            debugPrint('error messages:');
            for (final Message element in messages) {
              debugPrint(element.toString());
            }
            return '';
          },
        );
      },
    );
  }

  TagWrapExtension _buildTableWrapper() {
    return TagWrapExtension(
      tagsToWrap: <String>{'table'},
      builder: (Widget child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: child.paddingOnly(right: 150),
        );
      },
    );
  }

  Map<String, Style> _buildStyles(BuildContext context, ColorScheme colorscheme, BoxConstraints box) {
    return <String, Style>{
      'p': Style(
        fontSize: fontSize != null ? FontSize(fontSize!) : null,
        maxLines: maxLines,
        lineHeight: LineHeight.percent(125),
        textOverflow: TextOverflow.ellipsis,
        margin: Margins.only(left: 0, right: 0),
      ),
      'li': Style(
        fontSize: fontSize != null ? FontSize(fontSize!) : null,
        maxLines: maxLines,
        lineHeight: LineHeight.percent(125),
        textOverflow: TextOverflow.ellipsis,
        margin: Margins.only(left: 0, right: 0),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      'table': Style(
        height: Height.auto(),
        width: Width.auto(),
        border: Border(
          bottom: BorderSide(color: colorscheme.onBackground),
          left: BorderSide(color: colorscheme.onBackground),
          right: BorderSide(color: colorscheme.onBackground),
          top: BorderSide(color: colorscheme.onBackground),
        ),
      ),
      'tr': Style(
        height: Height.auto(),
        width: Width.auto(),
        border: Border(
          bottom: BorderSide(color: colorscheme.onBackground, width: 0.5),
          left: BorderSide(color: colorscheme.onBackground, width: 0.5),
          right: BorderSide(color: colorscheme.onBackground, width: 0.5),
          top: BorderSide(color: colorscheme.onBackground, width: 0.5),
        ),
      ),
      'th': Style(
        height: Height.auto(),
        width: Width.auto(),
        border: Border(
          bottom: BorderSide(color: colorscheme.onBackground, width: 0.5),
          left: BorderSide(color: colorscheme.onBackground, width: 0.5),
          right: BorderSide(color: colorscheme.onBackground, width: 0.5),
          top: BorderSide(color: colorscheme.onBackground, width: 0.5),
        ),
        padding: HtmlPaddings.all(6),
      ),
      'td': Style(
        height: Height.auto(),
        width: Width.auto(),
        padding: HtmlPaddings.all(6),
        alignment: Alignment.topLeft,
        border: Border(
          bottom: BorderSide(color: colorscheme.onBackground, width: 0.5),
          left: BorderSide(color: colorscheme.onBackground, width: 0.5),
          right: BorderSide(color: colorscheme.onBackground, width: 0.5),
          top: BorderSide(color: colorscheme.onBackground, width: 0.5),
        ),
      ),
      'h5': Style(maxLines: maxLines, textOverflow: TextOverflow.ellipsis),
      'iframe': Style(width: Width(box.maxWidth), height: Height((box.maxWidth / 16) * 9)),
      'figure': Style(width: Width(box.maxWidth)),
      'blockquote': Style(
        padding: HtmlPaddings.only(left: 16),
        border: Border(left: BorderSide(color: Zeta.of(context).colors.borderSubtle, width: 5)),
      ),
      ...style,
    };
  }

  TagExtension _unknownMediaType() {
    return TagExtension(
      tagsToExtend: {'mediacontainer'},
      builder: (ctx) {
        final initialUrl = Uri.tryParse(ctx.attributes['src'] ?? '');
        return initialUrl != null
            ? ColoredBox(
                color: Colors.black,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri.uri(initialUrl)),
                    initialSettings: InAppWebViewSettings(
                      verticalScrollBarEnabled: false,
                      horizontalScrollBarEnabled: false,
                      disableHorizontalScroll: true,
                      disableVerticalScroll: true,
                      supportZoom: false,
                      disableContextMenu: true,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  TagExtension _nestedTable(BuildContext context) {
    return TagExtension(
      tagsToExtend: {'nestedtable'},
      builder: (ctx) {
        return InkWell(
          child: Text(
            ComponentStrings.of(context).get('TABLE_CONTENT', 'Click to see table content'),
            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          ),
          onTap: () {
            final tableHtml = ctx.element?.outerHtml;
            final applycss = (ctx.element?.attributes ?? {})['applycss'] == 'true';
            if (tableHtml != null && tableHtml.isNotEmpty) {
              unawaited(
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ZdsNestedTableView(tableHtml, applyCss: applycss)),
                ),
              );
            }
          },
        ).paddingOnly(top: 10, bottom: 10);
      },
    );
  }

  TagExtension _loader() {
    return TagExtension(
      tagsToExtend: {'loader'},
      builder: (ctx) {
        return const AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator())),
        );
      },
    );
  }

  TagExtension _imageExtension(BoxConstraints box) {
    return TagExtension(
      tagsToExtend: {'img'},
      builder: (ctx) {
        final url = ctx.attributes['src'];
        return url != null && url.isNotEmpty
            ? ConstrainedBox(
                constraints: BoxConstraints(maxWidth: box.maxWidth),
                child: kIsWeb ? Image.network(url) : CachedNetworkImage(imageUrl: url),
              )
            : Container();
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('htmlText', htmlText))
      ..add(IntProperty('maxLines', maxLines))
      ..add(DoubleProperty('fontSize', fontSize))
      ..add(
        ObjectFlagProperty<void Function(String? url, Map<String, String> attributes, html.Element? element)?>.has(
          'onLinkTap',
          onLinkTap,
        ),
      )
      ..add(DiagnosticsProperty<Map<String, HtmlExtension>>('extensions', extensions))
      ..add(DiagnosticsProperty<Map<String, Style>>('style', style));
  }
}
