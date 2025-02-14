import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/services/statistics_service.dart';

import '../mocks.dart';

main() {
  late Database mockDatabase;
  late StatisticsService testObject;

  setUp(() {
    mockDatabase = MockDatabase();

    when(() => mockDatabase.insert(any(), any())).thenAnswer((_) async => 1);

    testObject = StatisticsService(database: mockDatabase);
  });

  group('addExercisePassed', () {
    test('inserts exercise with a passed value of 1 and correct timestamp',
        () async {
      const exerciseId = 'abc123';
      final timestamp = DateTime.now();

      await testObject.addExercisePassed(exerciseId, timestamp);

      verify(() => mockDatabase.insert('exercise_statistics', {
            'exercise_id': exerciseId,
            'passed': 1,
            'timestamp': timestamp.millisecondsSinceEpoch,
          }));
    });
  });

  group('addExerciseFailed', () {
    test('inserts exercise with a passed value of 0 and correct timestamp',
        () async {
      const exerciseId = 'abc123';
      final timestamp = DateTime.now();

      await testObject.addExerciseFailed(exerciseId, timestamp);

      verify(() => mockDatabase.insert('exercise_statistics', {
            'exercise_id': exerciseId,
            'passed': 0,
            'timestamp': timestamp.millisecondsSinceEpoch,
          }));
    });
  });

  group('getExercisePassRate', () {
    test('returns null if no exercises have been recorded', () async {
      const exerciseId = 'abc123';

      when(() => mockDatabase.rawQuery(any(), any()))
          .thenAnswer((_) async => []);

      final result = await testObject.getExercisePassRate(exerciseId, null);

      expect(result, isNull);
    });

    test('returns the pass rate for the given exercise', () async {
      const exerciseId = 'abc123';
      final timestamp = DateTime.now();

      when(() => mockDatabase.rawQuery(any(), any())).thenAnswer((_) async => [
            {'passed': 1, 'timestamp': timestamp.millisecondsSinceEpoch},
            {'passed': 0, 'timestamp': timestamp.millisecondsSinceEpoch},
          ]);

      final result = await testObject.getExercisePassRate(exerciseId, null);

      expect(result, 0.5);
    });

    test('ignores any exercises that occurred before now - duration', () async {
      const exerciseId = 'abc123';
      final timestamp = DateTime.now();
      const duration = Duration(days: 7);

      when(() => mockDatabase.rawQuery(any(), any())).thenAnswer((_) async => [
            {
              'passed': 1,
              'timestamp': timestamp.millisecondsSinceEpoch -
                  (duration.inMilliseconds + 1)
            },
            {'passed': 1, 'timestamp': timestamp.millisecondsSinceEpoch},
            {'passed': 0, 'timestamp': timestamp.millisecondsSinceEpoch},
          ]);

      final result = await testObject.getExercisePassRate(exerciseId, duration);

      expect(result, 0.5);
    });
  });
}
