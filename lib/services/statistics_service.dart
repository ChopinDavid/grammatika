import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StatisticsService {
  Database? _database;

  Future<void> _initDatabase() async {
    if (_database != null) return;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'statistics.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE exercise_statistics(exercise_id TEXT PRIMARY KEY, number_of_times_answered INTEGER, number_of_times_failed INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> addExercisePassed(String exerciseId) async {
    await _initDatabase();
    await _database!.transaction((txn) async {
      var result = await txn.rawQuery(
        'SELECT * FROM exercise_statistics WHERE exercise_id = ?',
        [exerciseId],
      );

      if (result.isEmpty) {
        await txn.insert('exercise_statistics', {
          'exercise_id': exerciseId,
          'number_of_times_answered': 1,
          'number_of_times_failed': 0,
        });
      } else {
        await txn.update(
          'exercise_statistics',
          {
            'number_of_times_answered':
                (result[0]['number_of_times_answered'] as int? ?? 0) + 1,
          },
          where: 'exercise_id = ?',
          whereArgs: [exerciseId],
        );
      }
    });
  }

  Future<void> addExerciseFailed(String exerciseId) async {
    await _initDatabase();
    await _database!.transaction((txn) async {
      var result = await txn.rawQuery(
        'SELECT * FROM exercise_statistics WHERE exercise_id = ?',
        [exerciseId],
      );

      if (result.isEmpty) {
        await txn.insert('exercise_statistics', {
          'exercise_id': exerciseId,
          'number_of_times_answered': 1,
          'number_of_times_failed': 1,
        });
      } else {
        await txn.update(
          'exercise_statistics',
          {
            'number_of_times_answered':
                (result[0]['number_of_times_answered'] as int? ?? 0) + 1,
            'number_of_times_failed':
                (result[0]['number_of_times_failed'] as int? ?? 0) + 1,
          },
          where: 'exercise_id = ?',
          whereArgs: [exerciseId],
        );
      }
    });
  }

  Future<double?> getExercisePassRate(String exerciseId) async {
    await _initDatabase();
    var result = await _database!.rawQuery(
      'SELECT * FROM exercise_statistics WHERE exercise_id = ?',
      [exerciseId],
    );

    if (result.isEmpty) {
      return null;
    } else {
      int numberOfTimesAnswered =
          result[0]['number_of_times_answered'] as int? ?? 0;
      int numberOfTimesFailed =
          result[0]['number_of_times_failed'] as int? ?? 0;
      int numberOfTimesPassed = numberOfTimesAnswered - numberOfTimesFailed;

      if (numberOfTimesAnswered == 0) {
        return null;
      }

      return numberOfTimesPassed / numberOfTimesAnswered;
    }
  }
}
