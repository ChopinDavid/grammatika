import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/screens/statistics/pass_rate_bar.dart';

main() {
  testWidgets('throws if the pass rate is less than 0',
      (WidgetTester tester) async {
    expect(() => PassRateBar(passRate: -0.1), throwsAssertionError);
  });

  testWidgets('throws if the pass rate is greater than 1',
      (WidgetTester tester) async {
    expect(() => PassRateBar(passRate: 1.1), throwsAssertionError);
  });

  testWidgets(
      'shows green and red containers with correct flex based on passRate',
      (WidgetTester tester) async {
    const passRate = 0.6;
    await tester.pumpWidget(
      const MaterialApp(
        home: PassRateBar(
          passRate: passRate,
        ),
      ),
    );

    final greenContainer = find.byWidgetPredicate(
        (widget) => widget is Container && widget.color == Colors.green);
    final redContainer = find.byWidgetPredicate(
        (widget) => widget is Container && widget.color == Colors.red);

    expect(greenContainer, findsOneWidget);
    expect(redContainer, findsOneWidget);

    final greenContainerWidth = tester.getSize(greenContainer).width;
    final redContainerWidth = tester.getSize(redContainer).width;

    expect(greenContainerWidth, 800 * passRate);
    expect(redContainerWidth, 800 * (1 - passRate));
  });
}
