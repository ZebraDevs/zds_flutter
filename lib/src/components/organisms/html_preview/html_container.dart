import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/dom.dart' as css;
import 'package:html/parser.dart' show parse;
import 'package:http_client_helper/http_client_helper.dart';

import '../../../../../zds_flutter.dart';
import 'html_body.dart' as html;

final _mediaTypeCache = <String, MediaType>{};

/// An enumeration to represent different types of media content.
enum MediaType {
  /// audio media
  audio,

  /// video media
  video,

  /// webUrl
  webUrl
}

/// Map of colors Swatch
Map<Color, ZetaColorSwatch> htmlColorSwatch = {};

/// A container widget for displaying HTML content with optional features.
///
/// This widget can display HTML content with options for text expansion, setting
/// font size, displaying a "Read More" link, and handling links. It also transforms
/// media tags to audio/video tags and iframe tags to href links.
class ZdsHtmlContainer extends StatefulWidget {
  /// Creates a new instance of the [ZdsHtmlContainer] widget.
  ///
  /// The [htmlText] parameter is required, and other parameters are optional.
  const ZdsHtmlContainer(
    this.htmlText, {
    super.key,
    this.expanded = false,
    this.fontSize,
    this.showReadMore = true,
    this.onLinkTap,
    this.containerHeight = 200,
    this.extensions = const {},
    this.style = const {},
  });

  /// The HTML content to be displayed.
  final String htmlText;

  /// Determines whether the text is initially expanded. Defaults to `false`.
  final bool expanded;

  /// The font size for the HTML content. If null, the default font size is used.
  final double? fontSize;

  /// Controls the visibility of the "Read More" link. Defaults to `true`.
  final bool showReadMore;

  ///Height of Html Container
  final double containerHeight;

  /// Add custom extensions to override the existing ones
  /// Following can be overridden tableTagWrap, tableHtml, video, audio, svg, img, loader, nestedTable, mediaContainer
  final Map<String, HtmlExtension> extensions;

  /// An API that allows you to override the default style for any HTML element
  final Map<String, Style> style;

  /// A callback function that is called when a link is tapped within the HTML content.
  ///
  /// The callback receives the URL of the tapped link, a map of attributes
  /// associated with the link, and the HTML element containing the link.
  final void Function(String? url, Map<String, String> attributes, html.Element? element)? onLinkTap;

  @override
  State<ZdsHtmlContainer> createState() => _ZdsHtmlContainerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<void Function(String? url, Map<String, String> attributes, html.Element? element)?>.has(
          'onLinkTap',
          onLinkTap,
        ),
      )
      ..add(StringProperty('htmlText', htmlText))
      ..add(DiagnosticsProperty<bool>('expanded', expanded))
      ..add(DoubleProperty('fontSize', fontSize))
      ..add(DiagnosticsProperty<bool>('showReadMore', showReadMore))
      ..add(DoubleProperty('containerHeight', containerHeight))
      ..add(DiagnosticsProperty<Map<String, HtmlExtension>>('extensions', extensions))
      ..add(DiagnosticsProperty<Map<String, Style>>('style', style));
  }
}

class _ZdsHtmlContainerState extends State<ZdsHtmlContainer> with FrameCallbackMixin {
  bool expanded = false;
  bool hasMore = false;
  String htmlContent = '';
  double? containerWidth;

  static final mediaRegex = RegExp(
    '<figure class="media">.*?(?:url|src|data-oembed-url|href)="(https?://[^"]+)".*?</figure>',
    dotAll: true,
  );

  static final loaderRegex = RegExp(r'<loader\s+src=(\S+)></loader>', dotAll: true);
  static final iFrameRegex = RegExp('<iframe.*?src="(.*?)".*?</iframe>', dotAll: true);
  static final nestedTableRegex = RegExp('.*?<table.*?<table.*?.*?</table>.*?</table>.*?', dotAll: true);

  static const _maxLines = 2;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _initialize() {
    expanded = widget.expanded || !widget.showReadMore;
    htmlContent = widget.htmlText;
    _transformWebView();
  }

  void _setContainerWidth(double width) {
    containerWidth = width;
    if (widget.showReadMore) {
      _updateHasMore();
    }
  }

  void _updateHasMore() {
    final TextPainter tp = TextPainter(
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: widget.htmlText,
        style: TextStyle(fontSize: widget.fontSize),
      ),
    )..layout(
        maxWidth: containerWidth ?? MediaQuery.of(context).size.width,
      );

    if (hasMore != tp.didExceedMaxLines) {
      setState(() {
        hasMore = tp.didExceedMaxLines;
      });
    }
  }

  void _transformWebView() {
    try {
      _handleNestedTable();
      _addMediaLoaders();
      unawaited(
        _collectMediaUrls().then((_) {
          _transformMediaFigures();
          _refreshUI();
        }),
      );
      _transformIFrameTag();
    } finally {
      _refreshUI();
    }
  }

  void _refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _collectMediaUrls() async {
    final Iterable<RegExpMatch> matches = loaderRegex.allMatches(htmlContent);
    for (final RegExpMatch match in matches) {
      final String? mediaUrl = match.group(1);
      if (mediaUrl != null) {
        await _cacheMediaType(mediaUrl);
      }
    }
  }

  void _addMediaLoaders() {
    String mediaUrl;
    htmlContent = htmlContent.replaceAllMapped(mediaRegex, (Match match) {
      mediaUrl = match.group(1) ?? '';
      return '<loader src=$mediaUrl></loader>';
    });
  }

  void _handleNestedTable() {
    final document = parse(htmlContent);
    final tables = document.getElementsByTagName('table');
    for (final table in tables) {
      if (nestedTableRegex.hasMatch(table.outerHtml)) {
        final nesTable = dom.Element.tag('nestedtable');
        table.replaceWith(nesTable);
        nesTable.append(table);
        if (table.attributes['border'] == null || (table.attributes['border']?.isEmpty ?? true)) {
          nesTable.attributes.addAll({'applyCss': 'true'});
        }
        final div = dom.Element.tag('div');
        nesTable.replaceWith(div);
        div.append(nesTable);
      }
    }
    htmlContent = document.outerHtml;
  }

  void _transformMediaFigures() {
    String mediaUrl;
    htmlContent = htmlContent.replaceAllMapped(loaderRegex, (Match match) {
      mediaUrl = (match.group(1) ?? '').replaceAll('"', '').replaceAll(r'\', '').replaceAll("'", '');
      String attributes = 'controls';
      if (containerWidth != null) {
        attributes = '$attributes width=$containerWidth height=${(containerWidth! / 16) * 9}';
      }
      final MediaType? mediaType = _mediaTypeCache[mediaUrl];
      if (mediaType == MediaType.video) {
        return '<p><video src="$mediaUrl" $attributes></video></p>';
      } else if (mediaType == MediaType.audio) {
        return '<p><audio src="$mediaUrl" $attributes></audio></p>';
      } else {
        return '<p><mediacontainer src="$mediaUrl"></mediacontainer></p>';
      }
    });
  }

  void _transformIFrameTag() {
    htmlContent = htmlContent.replaceAllMapped(iFrameRegex, (Match match) {
      final String url = match.group(1) ?? '';
      return '<p><a target="_blank" rel="noopener noreferrer" href=$url>$url</a></p>';
    });
  }

  void _transformColorTag() {
    htmlContent = adjustHtmlColorsForTheme(htmlContent);
  }

  Future<void> _cacheMediaType(String url) async {
    if (_mediaTypeCache.containsKey(url)) return;
    try {
      final Response? response = await HttpClientHelper.head(Uri.parse(url), retries: 2);
      if (response != null) {
        final String? contentType = response.headers['content-type'];
        if (contentType != null && contentType.isNotEmpty) {
          _mediaTypeCache[url] = contentType.contains('audio')
              ? MediaType.audio
              : contentType.contains('video')
                  ? MediaType.video
                  : MediaType.webUrl;
          return;
        }
      }

      _mediaTypeCache[url] = MediaType.webUrl;
    } catch (e) {
      _mediaTypeCache[url] = MediaType.webUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme surfaceColor = Theme.of(context).colorScheme;
    _transformColorTag();
    final html.ZdsHtml htmlView = html.ZdsHtml(
      htmlContent,
      fontSize: widget.fontSize,
      onLinkTap: widget.onLinkTap,
      extensions: widget.extensions,
      style: widget.style,
    );

    return LayoutBuilder(
      builder: (ctx, box) {
        if (widget.showReadMore) atLast(() => _setContainerWidth(box.maxWidth));
        return widget.showReadMore
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(),
                        constraints: BoxConstraints(maxHeight: expanded ? double.infinity : widget.containerHeight),
                        clipBehavior: Clip.hardEdge,
                        child: htmlView.paddingOnly(bottom: (hasMore && expanded) ? 24 : 0),
                      ),
                      if (hasMore && !expanded)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  surfaceColor.surface.withOpacity(0.3),
                                  surfaceColor.surface.withOpacity(0.4),
                                  surfaceColor.surface.withOpacity(0.5),
                                  surfaceColor.surface.withOpacity(0.6),
                                  surfaceColor.surface.withOpacity(0.7),
                                  surfaceColor.surface.withOpacity(0.8),
                                  surfaceColor.surface.withOpacity(0.9),
                                  surfaceColor.surface,
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (hasMore)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () => setState(() => expanded = !expanded),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              expanded
                                  ? ComponentStrings.of(context).get('READ_LESS', 'Read Less')
                                  : ComponentStrings.of(context).get('READ_MORE', 'Read More'),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: surfaceColor.secondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              )
            : htmlView;
      },
    );
  }

  // Check if html element colors are visible on background and if not adjust them as per background color
  String adjustHtmlColorsForTheme(String htmlContent) {
    final document = parse(htmlContent);
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    bool isContrastEnough(Color textColor, Color backgroundColor) {
      return textColor.contrastRatio(backgroundColor) >= 3;
    }

    // Function to convert various color formats to Color
    Color getColor(String color) {
      if (color.startsWith('#')) {
        return color.colorFromHex();
      } else if (color.startsWith('rgb')) {
        return color.colorFromRGBString();
      } else {
        return color.colorFromNamedColor() ?? (isDarkMode ? Colors.white : Colors.black);
      }
    }

    void adjustColor(css.Element element) {
      final style = element.attributes['style'];
      if (style != null) {
        // Extract color and background-color properties
        final colorMatch = RegExp(r'color:\s*([^;]+);?').firstMatch(style);
        final bgColorMatch = RegExp(r'background-color:\s*([^;]+);?').firstMatch(style);

        final textColorStr = colorMatch?.group(1);
        final bgColorStr = bgColorMatch?.group(1);

        Color? textColor;
        Color? bgColor;

        if (textColorStr != null) {
          textColor = getColor(textColorStr);
        }

        bgColor = bgColorStr != null ? getColor(bgColorStr) : (isDarkMode ? Colors.black : Colors.white);

        if (textColor != null && !isContrastEnough(textColor, bgColor)) {
          Color visible;
          if (textColor == Colors.black) {
            visible = Colors.white;
          } else if (textColor == Colors.white) {
            visible = Colors.black;
          } else {
            visible = textColor.adjustContrast(on: bgColor, target: 4.57);
          }
          element.attributes['style'] = style.replaceFirst(
            RegExp(r'color:\s*[^;]+;?'),
            'color: ${visible.toHex()};',
          );
        }
      }
    }

    document.body?.children.forEach((element) {
      adjustColor(element);
      element.querySelectorAll('*').forEach(adjustColor);
    });

    return document.outerHtml;
  }

  // Get visible color on background color
  ZetaColorSwatch getVisibleColor(Color color, Color bgColor) {
    var visible = htmlColorSwatch[color];
    if (visible == null) {
      final colorSwatch = ZetaColorSwatch.fromColor(color);
      htmlColorSwatch[color] = colorSwatch;
      visible = colorSwatch;
    }

    return visible.apply(brightness: bgColor.isDark ? Brightness.dark : Brightness.light);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('expanded', expanded))
      ..add(DiagnosticsProperty<bool>('hasMore', hasMore))
      ..add(StringProperty('htmlContent', htmlContent))
      ..add(DiagnosticsProperty<RegExp>('mediaRegex', mediaRegex))
      ..add(DiagnosticsProperty<RegExp>('iFrameRegex', iFrameRegex))
      ..add(DoubleProperty('containerWidth', containerWidth));
  }
}
