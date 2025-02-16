import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/screens/statistics/duration_radio_button.dart';

main() {
  testWidgets(
    'displays text',
    (widgetTester) async {
      const expectedText = 'text';
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationRadioButton(
                text: expectedText,
                duration: Duration.zero,
                selectedDuration: Duration.zero,
                onChanged: (_) {}),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(find.text(expectedText), findsOneWidget);
    },
  );

  testWidgets(
    "passes duration and selectedDuration to Radio's value and groupValue properties, respectively",
    (widgetTester) async {
      const expectedDuration = Duration(days: 1);
      const expectedSelectedDuration = Duration(days: 7);
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationRadioButton(
                text: 'text',
                duration: expectedDuration,
                selectedDuration: expectedSelectedDuration,
                onChanged: (_) {}),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final radio =
          widgetTester.widget<Radio<Duration?>>(find.byType(Radio<Duration?>));
      expect(radio.value, expectedDuration);
      expect(radio.groupValue, expectedSelectedDuration);
    },
  );

  testWidgets(
    'onChanged is invoked when inkwell is tapped',
    (widgetTester) async {
      const duration = Duration(days: 1);
      Duration? selectedDuration;
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationRadioButton(
                text: 'text',
                duration: duration,
                selectedDuration: const Duration(days: 7),
                onChanged: (d) => selectedDuration = d),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(InkWell));
      expect(selectedDuration, duration);
    },
  );
}
