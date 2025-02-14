import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/screens/statistics/pass_rate_list_tile.dart';
import 'package:uchu/screens/statistics/statistics_page.dart';
import 'package:uchu/services/statistics_service.dart';

import '../../mocks.dart';

main() {
  late StatisticsService mockStatisticsService;
  final totalExerciseCount = WordFormType.values.length + Gender.values.length;

  setUp(() async {
    await GetIt.instance.reset();

    mockStatisticsService = MockStatisticsService();
    when(() => mockStatisticsService.getExercisePassRate(any(), any()))
        .thenAnswer((_) async => 0.0);

    GetIt.instance.registerSingleton<StatisticsService>(mockStatisticsService);
  });

  testWidgets(
    'invokes StatisticsService.getExercisePassRate for each exercise type',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: StatisticsPage(),
        ),
      );
      await widgetTester.pumpAndSettle();

      verify(() => mockStatisticsService.getExercisePassRate(any(), any()))
          .called(totalExerciseCount);
    },
  );

  testWidgets(
    'displays empty state when no exercises have been completed',
    (widgetTester) async {
      when(() => mockStatisticsService.getExercisePassRate(any(), any()))
          .thenAnswer((_) async => null);

      await widgetTester.pumpWidget(
        const MaterialApp(
          home: StatisticsPage(),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(find.text('Complete exercises to view your statistics.'),
          findsOneWidget);
    },
  );

  group(
    'duration radios',
    () {
      testWidgets(
        'displays "All", "Day", "Week", "Month", "Year" radios',
        (widgetTester) async {
          await widgetTester.pumpWidget(
            const MaterialApp(
              home: StatisticsPage(),
            ),
          );

          await widgetTester.pumpAndSettle();

          expect(find.text('All'), findsOneWidget);
          expect(find.text('Day'), findsOneWidget);
          expect(find.text('Week'), findsOneWidget);
          expect(find.text('Month'), findsOneWidget);
          expect(find.text('Year'), findsOneWidget);
        },
      );

      testWidgets(
        'tapping each radio enables the radio and invokes StatisticsService.getExercisePassRate with correct duration',
        (widgetTester) async {
          await widgetTester.pumpWidget(
            const MaterialApp(
              home: StatisticsPage(),
            ),
          );

          await widgetTester.pumpAndSettle();

          await widgetTester.tap(find.text('All'));
          await widgetTester.pumpAndSettle();
          final allRadio = widgetTester
              .widget<Radio<Duration?>>(find.byKey(const Key('All-radio')));
          expect(allRadio.value, allRadio.groupValue);
          verify(() => mockStatisticsService.getExercisePassRate(any(), null))
              .called(totalExerciseCount * 2);

          await widgetTester.tap(find.text('Day'));
          await widgetTester.pumpAndSettle();
          final dayRadio = widgetTester
              .widget<Radio<Duration?>>(find.byKey(const Key('Day-radio')));
          expect(dayRadio.value, dayRadio.groupValue);
          verify(() => mockStatisticsService.getExercisePassRate(
              any(), const Duration(days: 1))).called(totalExerciseCount);

          await widgetTester.tap(find.text('Week'));
          await widgetTester.pumpAndSettle();
          final weekRadio = widgetTester
              .widget<Radio<Duration?>>(find.byKey(const Key('Week-radio')));
          expect(weekRadio.value, weekRadio.groupValue);
          verify(() => mockStatisticsService.getExercisePassRate(
              any(), const Duration(days: 7))).called(totalExerciseCount);

          await widgetTester.tap(find.text('Month'));
          await widgetTester.pumpAndSettle();
          final monthRadio = widgetTester
              .widget<Radio<Duration?>>(find.byKey(const Key('Month-radio')));
          expect(monthRadio.value, monthRadio.groupValue);
          verify(() => mockStatisticsService.getExercisePassRate(
              any(), const Duration(days: 31))).called(totalExerciseCount);

          await widgetTester.tap(find.text('Year'));
          await widgetTester.pumpAndSettle();
          final yearRadio = widgetTester
              .widget<Radio<Duration?>>(find.byKey(const Key('Year-radio')));
          expect(yearRadio.value, yearRadio.groupValue);
          verify(() => mockStatisticsService.getExercisePassRate(
              any(), const Duration(days: 365))).called(totalExerciseCount);
        },
      );
    },
  );

  group('CircularProgressIndicator', () {
    testWidgets(
      'is shown when futures are loading',
      (widgetTester) async {
        // TODO(DC): How do we write this test?
      },
    );
  });

  group('ListView', () {
    testWidgets(
      'displays exercises sorted by passrate, ascending',
      (widgetTester) async {
        int exerciseLoadCount = 0;
        when(() => mockStatisticsService.getExercisePassRate(any(), any()))
            .thenAnswer((_) async {
          exerciseLoadCount++;
          return 1.0 - exerciseLoadCount / 100;
        });
        await widgetTester.pumpWidget(
          const MaterialApp(
            home: StatisticsPage(),
          ),
        );
        await widgetTester.pumpAndSettle();

        final passRateListTileFinder = find.byType(PassRateListTile);
        for (var passRateListTileEntry in widgetTester
            .widgetList<PassRateListTile>(passRateListTileFinder)
            .indexed) {
          final index = passRateListTileEntry.$1;
          final passRateListTile = passRateListTileEntry.$2;
          final value = passRateListTile.value;
          expect(value, 1.0 - (totalExerciseCount - index) / 100);
        }
      },
    );
  });
}
