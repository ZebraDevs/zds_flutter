import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_quill/quill_delta.dart';

import '../../../../zds_flutter.dart';

/// An extension on [Delta] to convert Delta content to HTML
///
extension DeltaToHtml on Delta {
  ///
  /// Converts the current instance's Delta representation to HTML format.
  ///
  /// This method loads the Quill JavaScript library and utilizes the QuillDeltaToHtmlConverter
  /// to convert the Delta representation to HTML. A headless in-app WebView is used for this conversion.
  ///
  /// Returns:
  ///   - A [Future] that completes with the converted HTML string.
  ///
  Future<String> toHtml() async {
    // Load the Quill JavaScript library from the specified path.
    final String quillJs = await rootBundle.loadString('packages/$packageName/lib/assets/js/quill.min.js');

    // Completer to hold the final HTML result.
    final Completer<String> completer = Completer<String>();

    late HeadlessInAppWebView webView;

    // Initialize the headless WebView with the loaded Quill library and a script to trigger the conversion.
    webView = HeadlessInAppWebView(
      initialData: InAppWebViewInitialData(
        data: '''
      <!DOCTYPE html>
      <html lang="en">
          <head>       
              <script>$quillJs</script>
          </head>
          <body>
              <h1>JavaScript Handlers</h1>
              <script>
                    window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                      var converter = new QuillDeltaToHtmlConverter(${jsonEncode(toJson())}, {});
                      var html = converter.convert(); 
                      window.flutter_inappwebview.callHandler('deltaToHtml', ...[html]);
                    });
              </script>
          </body>
      </html>
      ''',
      ),
      initialSettings: InAppWebViewSettings(),
      onWebViewCreated: (InAppWebViewController controller) {
        // JavaScript handler to retrieve the converted HTML and complete the completer.
        controller.addJavaScriptHandler(
          handlerName: 'deltaToHtml',
          callback: (List<dynamic> args) {
            // Check if the arguments are not empty and complete the completer with the HTML string.
            if (args.isNotEmpty) {
              completer.complete(args.first as String);
            } else {
              completer.complete('');
            }
            // Dispose the WebView after getting the HTML.
            webView.dispose();
          },
        );
      },
    );
    await webView.run();

    return completer.future;
  }
}

/// An extension on [String] to convert HTML content to Quill's Delta format
///
extension HtmlToDelta on String {
  ///
  /// Converts the current HTML string to Quill's Delta format.
  ///
  /// This method loads the Quill JavaScript library, initializes a Quill editor with the current HTML content,
  /// and retrieves the editor's content in Delta format. A headless in-app WebView is used for this conversion.
  ///
  /// Returns:
  ///   - A [Future] that completes with the converted Delta.
  ///
  Future<Delta> toDelta() async {
    // Completer to hold the final Delta result.
    final Completer<Delta> completer = Completer<Delta>();

    // Load the Quill JavaScript library from the specified path.
    final String quillJs = await rootBundle.loadString('packages/reflexis_ui/lib/assets/js/quill.min.js');

    late HeadlessInAppWebView webView;

    // Initialize the headless WebView with the loaded Quill library, the current HTML content, and a script to trigger the conversion.
    webView = HeadlessInAppWebView(
      initialData: InAppWebViewInitialData(
        data: '''
        <!DOCTYPE html>
        <html lang="en">
            <head>       
                <script>$quillJs</script>
            </head>
            <body>
                <div id="editor">
                $this
                </div>
                <script>
                      var quill = new Quill('#editor', { theme: 'snow' });
                      window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                        window.flutter_inappwebview.callHandler('htmlToDelta', ...[JSON.stringify(quill.getContents())]);
                      });
                </script>
            </body>
        </html>
        ''',
      ),
      initialSettings: InAppWebViewSettings(),
      onWebViewCreated: (InAppWebViewController controller) {
        // JavaScript handler to retrieve the converted Delta and complete the completer.
        controller.addJavaScriptHandler(
          handlerName: 'htmlToDelta',
          callback: (List<dynamic> args) {
            try {
              // Dispose the WebView after getting the Delta.
              webView.dispose();
              // Parse the Delta from the callback arguments.
              final dynamic resp = jsonDecode(args.first as String);
              // ignore: avoid_dynamic_calls
              final Delta delta = Delta.fromJson(resp['ops'] as List<dynamic>);
              completer.complete(delta);
            } catch (e) {
              // Print the error if in debug mode.
              if (kDebugMode) print(e);
            }
          },
        );
      },
    );
    await webView.run();
    return completer.future;
  }
}
