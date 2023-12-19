import 'package:cached_network_image/cached_network_image.dart';
import 'package:csslib/parser.dart' hide Border, LineHeight;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_audio/flutter_html_audio.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:html/dom.dart' as html;

import '../../../../../zds_flutter.dart';
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
  });

  /// The HTML content to be displayed.
  final String htmlText;

  /// The maximum number of lines to display. Defaults to 5.
  final int maxLines;

  /// The font size for the HTML content. If null, the default font size is used.
  final double? fontSize;

  /// A callback function that is called when a link is tapped within the HTML content.
  ///
  /// The callback receives the URL of the tapped link, a map of attributes
  /// associated with the link, and the HTML element containing the link.
  final void Function(String? url, Map<String, String> attributes, html.Element? element)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorscheme = Theme.of(context).colorScheme;
    final BoxDecoration boxDecoration = BoxDecoration(
      color: ZdsColors.lightGrey.withOpacity(0.5),
      border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), width: 0.5),
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Html(
          shrinkWrap: true,
          data: htmlText,
          style: <String, Style>{
            'p': Style(
              fontSize: fontSize != null ? FontSize(fontSize!) : null,
              maxLines: maxLines,
              lineHeight: LineHeight.percent(125),
              textOverflow: TextOverflow.ellipsis,
              margin: Margins.only(left: 0, right: 0),
            ),
            'table': Style(
              width: Width.auto(),
              border: Border(
                bottom: BorderSide(color: colorscheme.onBackground),
                left: BorderSide(color: colorscheme.onBackground),
                right: BorderSide(color: colorscheme.onBackground),
                top: BorderSide(color: colorscheme.onBackground),
              ),
            ),
            'tr': Style(
              width: Width.auto(),
              border: Border(
                bottom: BorderSide(color: colorscheme.onBackground, width: 0.5),
                left: BorderSide(color: colorscheme.onBackground, width: 0.5),
                right: BorderSide(color: colorscheme.onBackground, width: 0.5),
                top: BorderSide(color: colorscheme.onBackground, width: 0.5),
              ),
            ),
            'th': Style(
              width: Width.auto(),
              padding: HtmlPaddings.all(6),
            ),
            'td': Style(
              width: Width.auto(),
              padding: HtmlPaddings.all(6),
              border: Border(
                bottom: BorderSide(color: colorscheme.onBackground, width: 0.5),
                left: BorderSide(color: colorscheme.onBackground, width: 0.5),
                right: BorderSide(color: colorscheme.onBackground, width: 0.5),
                top: BorderSide(color: colorscheme.onBackground, width: 0.5),
              ),
              alignment: Alignment.topLeft,
            ),
            'h5': Style(maxLines: maxLines, textOverflow: TextOverflow.ellipsis),
            'iframe': Style(width: Width(box.maxWidth), height: Height((box.maxWidth / 16) * 9)),
            'figure': Style(width: Width(box.maxWidth)),
          },
          extensions: <HtmlExtension>[
            TagWrapExtension(
              tagsToWrap: <String>{'table'},
              builder: (Widget child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 150),
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: child,
                );
              },
            ),
            const ZdsTableHtmlExtension(),
            const ZdsVideoHtmlExtension(),
            const AudioHtmlExtension(),
            const SvgHtmlExtension(),
            TagExtension(
              tagsToExtend: <String>{'img'},
              builder: (ExtensionContext ctx) {
                final String? url = ctx.attributes['src'];
                return url != null && url.isNotEmpty
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: box.maxWidth),
                        child: kIsWeb ? Image.network(url) : CachedNetworkImage(imageUrl: url),
                      )
                    : Container();
              },
            ),
            TagExtension(
              tagsToExtend: <String>{'loader'},
              builder: (ExtensionContext ctx) {
                return DecoratedBox(
                  decoration: boxDecoration,
                  child: const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator())),
                  ),
                );
              },
            ),
            TagExtension(
              tagsToExtend: <String>{'mediacontainer'},
              builder: (ExtensionContext ctx) {
                final String? url = ctx.attributes['src'];
                return url != null && url.isNotEmpty
                    ? InkWell(
                        child: DecoratedBox(
                          decoration: boxDecoration,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.error,
                                    color: ZdsColors.darkGrey,
                                    size: 50,
                                  ).paddingOnly(bottom: 20),
                                  Text(
                                    ComponentStrings.of(context).get('MEDIA_ERROR', 'Error loading media.'),
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ).paddingOnly(bottom: 10),
                                  Text(
                                    url,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: ZdsColors.blue, decoration: TextDecoration.underline),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ).padding(10),
                        ),
                        onTap: () {
                          onLinkTap?.call(url, ctx.attributes, ctx.element);
                        },
                      )
                    : Container();
              },
            ),
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
      );
  }
}
