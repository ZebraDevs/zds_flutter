// ignore_for_file: avoid_dynamic_calls
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'html_parser.dart';

/// [ZdsQuillDelta] represents a wrapper around the Quill's `Document` to
/// offer additional functionalities like conversion from and to HTML.
class ZdsQuillDelta {
  /// Constructs a [ZdsQuillDelta] instance with the given [document].
  ZdsQuillDelta({required Document document}) : document = Document.fromDelta(document.toDelta());

  /// Creates an empty [ZdsQuillDelta].
  factory ZdsQuillDelta.empty() => ZdsQuillDelta(document: Document());

  /// The underlying Quill document.
  final Document document;

  /// Creates a [ZdsQuillDelta] instance by converting the given [htmlString]
  /// to Quill's Delta.
  static Future<ZdsQuillDelta> fromHtml(String htmlString) async {
    final Delta delta = await htmlString.toDelta();
    return ZdsQuillDelta(document: Document.fromDelta(delta));
  }

  /// Converts the underlying Quill's Delta to an HTML string.
  String toHtml() {
    // Convert document to JSON format
    final List<dynamic> deltaJson = document.toDelta().toJson();

    // Iterate through each Delta operation
    for (final dynamic element in deltaJson) {
      // Modify color attribute by removing '#FF' if it exists
      _updateColorAttribute(element, 'color');

      // Modify background attribute by removing '#FF' if it exists
      _updateColorAttribute(element, 'background');
    }

    // Use the QuillDeltaToHtmlConverter to convert modified Delta to HTML
    final QuillDeltaToHtmlConverter converter =
        QuillDeltaToHtmlConverter(List.castFrom(deltaJson), ConverterOptions.forEmail());
    return converter.convert();
  }

  /// Helper method to update a color attribute (either 'color' or 'background')
  /// in a Delta operation by removing '#FF' if it exists.
  void _updateColorAttribute(dynamic element, String attribute) {
    if (element['attributes'] != null && element['attributes'][attribute] != null) {
      element['attributes'][attribute] = element['attributes'][attribute].toString().replaceAll('#FF', '#');
    }
  }

  /// Creates a copy with provided document
  ZdsQuillDelta copyWith({
    Document? document,
  }) {
    return ZdsQuillDelta(
      document: document ?? this.document,
    );
  }
}
