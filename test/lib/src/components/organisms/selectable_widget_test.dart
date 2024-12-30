import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zds_flutter/zds_flutter.dart';
import '../../../../fixtures/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  var clipboardContent = 'Selectable Text';
  setUp(() {
    // Mock the clipboard data
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform,
        (MethodCall methodCall) async {
      if (methodCall.method == 'Clipboard.getData') {
        return {'text': clipboardContent};
      }
      return null;
    });
  });
  tearDown(() {
    // Remove the mock handler
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });
  group('ZdsSelectableWidget Tests', () {
    testWidgets('Displays child widget', (WidgetTester tester) async {
      const childWidget = Text('Selectable Text');
      clipboardContent = 'Selectable Text';
      await tester.pumpWidget(
        TestApp(
          builder: (BuildContext context) {
            return const ZdsSelectableWidget(
              textToCopy: 'Selectable Text',
              child: childWidget,
            );
          },
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byWidget(childWidget), findsOneWidget);
    });
    testWidgets('Copies plain text to clipboard on long press', (WidgetTester tester) async {
      const childWidget = Text('Selectable Text');
      clipboardContent = 'Selectable Text';
      await tester.pumpWidget(
        TestApp(
          builder: (BuildContext context) {
            return const ZdsSelectableWidget(
              textToCopy: 'Selectable Text',
              copyable: true,
              child: childWidget,
            );
          },
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.longPress(find.byWidget(childWidget));
      await tester.pumpAndSettle();
      final clipboardData = await Clipboard.getData('text/plain');
      expect(clipboardData?.text, clipboardContent);
    });
    testWidgets('Copies HTML text to clipboard as plain text on long press', (WidgetTester tester) async {
      const childWidget = Text('Selectable HTML Text');
      const htmlText = '<p>Selectable <b>HTML</b> Text</p>';
      clipboardContent = 'Selectable HTML Text';
      await tester.pumpWidget(
        TestApp(
          builder: (BuildContext context) {
            return const ZdsSelectableWidget(
              textToCopy: htmlText,
              isHtmlData: true,
              copyable: true,
              child: childWidget,
            );
          },
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.longPress(find.byWidget(childWidget));
      await tester.pumpAndSettle();
      final clipboardData = await Clipboard.getData('text/plain');
      expect(clipboardData?.text, 'Selectable HTML Text');
    });
    testWidgets('Does not copy text if copyable is false', (WidgetTester tester) async {
      const childWidget = Text('Non-copyable Text');
      clipboardContent = '';
      await tester.pumpWidget(
        TestApp(
          builder: (BuildContext context) {
            return const ZdsSelectableWidget(
              textToCopy: 'Non-copyable Text',
              copyable: false,
              child: childWidget,
            );
          },
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.longPress(find.byWidget(childWidget));
      await tester.pumpAndSettle();
      final clipboardData = await Clipboard.getData('text/plain');
      expect(clipboardData?.text, '');
    });
  });
}
