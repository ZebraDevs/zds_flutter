import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zds_flutter/zds_flutter.dart';

import 'test_utility.dart';

void main() {
  testWidgets('ZdsDayPicker without any parameters', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final Widget testWidget = getTestWidget(
      ZdsDayPicker(
        startingWeekDate: DateTime.now(),
      ),
    );
    await tester.pumpWidget(testWidget);
  });

  testWidgets('Select individual with deprecated initialSelectedDate', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final Widget testWidget = getTestWidget(
      ZdsDayPicker(
        startingWeekDate: DateTime.now().add(const Duration(days: -2)),
        header: 'Days',
      ),
    );
    await tester.pumpWidget(testWidget);
  });

  testWidgets('Select individual with initialSelectedDates', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final Widget testWidget = getTestWidget(
      ZdsDayPicker(
        startingWeekDate: DateTime.now().add(const Duration(days: -2)),
        initialSelectedDates: [DateTime.now().add(const Duration(days: 2))],
        header: 'Days',
      ),
    );
    await tester.pumpWidget(testWidget);
    expect(find.text('Days'), findsOneWidget);
  });

  testWidgets('ZdsDayPicker assertion check', (WidgetTester tester) async {
    expect(
      () => ZdsDayPicker(
        startingWeekDate: DateTime.now(),
        initialSelectedDates: [DateTime.now(), DateTime.now().add(const Duration(days: 2))],
      ),
      throwsAssertionError,
    );
  });
}
