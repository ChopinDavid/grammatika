import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StatisticsService {
  StatisticsService({
    @visibleForTesting Database? database,
  }) : _database = database;
  Database? _database;

  Future<void> _initDatabase() async {
    if (_database != null) return;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'statistics.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE exercise_statistics(id INTEGER PRIMARY KEY AUTOINCREMENT, exercise_id TEXT, passed INTEGER, timestamp INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> addExercisePassed(String exerciseId, DateTime timestamp) async {
    await _initDatabase();
    await _database!.insert('exercise_statistics', {
      'exercise_id': exerciseId,
      'passed': 1,
      'timestamp': timestamp.millisecondsSinceEpoch,
    });
  }

  Future<void> addExerciseFailed(String exerciseId, DateTime timestamp) async {
    await _initDatabase();
    await _database!.insert('exercise_statistics', {
      'exercise_id': exerciseId,
      'passed': 0,
      'timestamp': timestamp.millisecondsSinceEpoch,
    });
  }

  Future<double?> getExercisePassRate(
      String exerciseId, Duration? duration) async {
    await _initDatabase();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int durationInMillis = duration?.inMilliseconds ?? 0;

    var result = await _database!.rawQuery(
      'SELECT * FROM exercise_statistics WHERE exercise_id = ?',
      [exerciseId],
    );

    if (result.isEmpty) {
      return null;
    } else {
      int passedCount = 0;
      int totalCount = 0;

      for (var row in result) {
        int timestamp = row['timestamp'] as int? ?? 0;
        if (duration == null || currentTime - timestamp <= durationInMillis) {
          totalCount++;
          if (row['passed'] == 1) {
            passedCount++;
          }
        }
      }

      if (totalCount == 0) {
        return null;
      }

      return passedCount / totalCount;
    }
  }
}
