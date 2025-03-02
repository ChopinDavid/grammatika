import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/utilities/url_helper.dart';
import 'package:grammatika/widgets/dashed_border_painter.dart';
import 'package:grammatika/widgets/translatable_word.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

main() {
  late UrlHelper mockUrlHelper;

  setUp(() async {
    await GetIt.instance.reset();

    mockUrlHelper = MockUrlHelper();
    when(() => mockUrlHelper.launchWiktionaryPageFor(any()))
        .thenAnswer((_) async => true);

    GetIt.instance.registerSingleton<UrlHelper>(mockUrlHelper);
  });

  testWidgets(
    'word is shown in a Text widget',
    (widgetTester) async {
      const expectedWord = 'someWord';
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TranslatableWord(expectedWord),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final textFinder = find.byType(Text);
      expect(textFinder, findsOneWidget);
      expect(widgetTester.widget<Text>(textFinder).data, expectedWord);
    },
  );

  testWidgets(
    'Text widget is wrapped in a CustomPaint with expected painter',
    (widgetTester) async {
      const expectedPainter = DashedBorderPainter(color: Colors.blue);
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TranslatableWord('someWord'),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final customPaintFinder =
          find.byKey(const Key('translatable-custom-paint'));
      expect(customPaintFinder, findsOneWidget);

      final customPaintWidget =
          widgetTester.widget<CustomPaint>(customPaintFinder);
      expect(customPaintWidget.painter, expectedPainter);
      expect(customPaintWidget.child, isA<Text>());
    },
  );

  testWidgets(
    'Tapping on InkWell launches Wiktionary page for word',
    (widgetTester) async {
      const expectedWord = 'someWord';
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TranslatableWord(expectedWord),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(InkWell));
      await widgetTester.pumpAndSettle();

      verify(() => mockUrlHelper.launchWiktionaryPageFor(expectedWord))
          .called(1);
    },
  );
}
