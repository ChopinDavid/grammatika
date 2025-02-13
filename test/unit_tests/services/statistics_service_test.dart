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
    when(() => mockDatabase.update(any(), any(),
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'))).thenAnswer((_) async => 1);
    when(() => mockDatabase.rawQuery(any(), any())).thenAnswer((_) async => []);

    testObject = StatisticsService(database: mockDatabase);
  });

  group('addExercisePassed', () {
    test(
        'inserts exercise with number_of_times_answered: 1 and number_of_times_failed: 0 when exercise does not yet exist in exercise_statistics table',
        () async {
      const exerciseId = 'abc123';
      when(() => mockDatabase.rawQuery(
            'SELECT * FROM exercise_statistics WHERE exercise_id = ?',
            [exerciseId],
          )).thenAnswer((_) async => []);

      await testObject.addExercisePassed(exerciseId);

      verify(() => mockDatabase.insert('exercise_statistics', {
            'exercise_id': exerciseId,
            'number_of_times_answered': 1,
            'number_of_times_failed': 0,
          }));
      verifyNever(() => mockDatabase.update(any(), any()));
    });

    test(
        'updates exercise, incrementing only number_of_times_answered when exercise does already exists in exercise_statistics table',
        () async {
      const exerciseId = 'abc123';
      const expectedNumberOfTimesAnswered = 6;
      when(() => mockDatabase.rawQuery(
            'SELECT * FROM exercise_statistics WHERE exercise_id = ?',
            [exerciseId],
          )).thenAnswer((_) async => [
            {
              'number_of_times_answered': expectedNumberOfTimesAnswered - 1,
              'number_of_times_failed': 3,
            }
          ]);
      await testObject.addExercisePassed(exerciseId);

      verifyNever(() => mockDatabase.insert(any(), any()));

      verify(() => mockDatabase.update(
            'exercise_statistics',
            {
              'number_of_times_answered': expectedNumberOfTimesAnswered,
            },
            where: 'exercise_id = ?',
            whereArgs: [exerciseId],
          ));
    });
  });
}
