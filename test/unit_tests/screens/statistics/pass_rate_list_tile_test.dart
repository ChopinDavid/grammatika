import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/screens/statistics/pass_rate_bar.dart';
import 'package:uchu/screens/statistics/pass_rate_list_tile.dart';

main() {
  testWidgets(
    'displays title',
    (widgetTester) async {
      const expectedTitle = 'Test Title';
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PassRateListTile(
              title: expectedTitle,
              value: 0.5,
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(find.text(expectedTitle), findsOneWidget);
    },
  );

  testWidgets('displays pass rate string with value as percentage',
      (widgetTester) async {
    const expectedValue = 0.5;
    await widgetTester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PassRateListTile(
            title: 'Test Title',
            value: expectedValue,
          ),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();

    expect(find.text('${(expectedValue * 100).toStringAsFixed(2)}% pass rate'),
        findsOneWidget);
  });

  testWidgets('displays pass rate bar', (widgetTester) async {
    const expectedValue = 0.5;
    await widgetTester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PassRateListTile(
            title: 'Test Title',
            value: expectedValue,
          ),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();

    final passRateBarFinder = find.byType(PassRateBar);
    expect(passRateBarFinder, findsOneWidget);
    expect(widgetTester.widget<PassRateBar>(passRateBarFinder).passRate,
        expectedValue);
  });
}
