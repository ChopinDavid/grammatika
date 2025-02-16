import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/widgets/translation_button.dart';
import 'package:uchu/widgets/translation_widget.dart';

void main() {
  group('constructor assertions', () {
    test('throws AssertionError when both tatoebaKey and onPressed are null',
        () {
      expect(
        () => TranslationButton(),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'throws AssertionError when both tatoebaKey and onPressed are provided',
        () {
      expect(
        () => TranslationButton(
          tatoebaKey: 123,
          onPressed: () {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('does not throw when only tatoebaKey is provided', () {
      expect(
        () => const TranslationButton(tatoebaKey: 123),
        returnsNormally,
      );
    });

    test('does not throw when only onPressed is provided', () {
      expect(
        () => TranslationButton(onPressed: () {}),
        returnsNormally,
      );
    });
  });

  testWidgets('Displays icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TranslationButton(
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.translate), findsOneWidget);
  });

  testWidgets('Invokes custom onPressed when passed',
      (WidgetTester tester) async {
    int onPressedCallCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TranslationButton(
            onPressed: () {
              onPressedCallCount++;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.translate));
    await tester.pump();

    expect(onPressedCallCount, 1);
  });

  testWidgets('Shows TranslationWidget when tatoebaKey is provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TranslationButton(
            tatoebaKey: 123,
          ),
        ),
      ),
    );

    // Tap the button and verify the dialog is shown
    await tester.tap(find.byIcon(Icons.translate));
    await tester.pump();

    expect(find.byType(TranslationWidget), findsOneWidget);
  });
}
