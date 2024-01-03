import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// It applied viewport script for page meta-data
class ZdsNestedTableView extends StatelessWidget {
  /// Creates a new instance of the [ZdsNestedTableView] widget.
  ///
  /// The [html] parameter is required.
  const ZdsNestedTableView(this.html, {super.key, this.applyCss = false});

  /// The HTML content to be displayed.
  final String html;

  /// Apply css if true
  final bool applyCss;

  /// It applied viewport script for page meta-data
  String get _viewportScript => '''
    var meta = document.createElement('meta');
    meta.setAttribute('name', 'viewport');
    meta.setAttribute('content', 'width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no, viewport-fit=cover');
    document.getElementsByTagName('head')[0].appendChild(meta);  
      ''';

  ////Table Style
  String get _tablecss =>
      'table, th, td{border:1px solid gray;}table {border-collapse: collapse;}td, tr{padding:6px}th {text-align: left;}';

  ///Initial `data` as a content for an [InAppWebView] instance.
  InAppWebViewInitialData? get initialData => InAppWebViewInitialData(
        data: html,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: InAppWebView(
          initialData: initialData,
          initialUserScripts: UnmodifiableListView<UserScript>([
            UserScript(source: _viewportScript, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
          ]),
          gestureRecognizers: const {
            Factory<VerticalDragGestureRecognizer>(VerticalDragGestureRecognizer.new),
            Factory<HorizontalDragGestureRecognizer>(HorizontalDragGestureRecognizer.new),
          },
          initialSettings: InAppWebViewSettings(
            useShouldOverrideUrlLoading: true,
            allowsInlineMediaPlayback: true,
          ),
          onPageCommitVisible: (controller, url) {
            if (applyCss) {
              unawaited(
                controller.evaluateJavascript(
                  source: """
                  var style = document.createElement('style');
                  style.innerHTML = "$_tablecss";
                  document.head.appendChild(style);
                  """,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('html', html))
      ..add(DiagnosticsProperty<InAppWebViewInitialData?>('initialData', initialData))
      ..add(DiagnosticsProperty<bool>('applyCss', applyCss));
  }
}
