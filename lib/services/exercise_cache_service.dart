import 'dart:convert';

import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/utilities/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseCacheService {
  final DbHelper _dbHelper = DbHelper();

  Future<List<Exercise<WordForm, Sentence>>> cachedSentenceExercises() async {
    final db = await _dbHelper.getDatabase();

    // Check if the table exists
    await db.execute('''
    CREATE TABLE IF NOT EXISTS sentence_exercises (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exercise TEXT NOT NULL
    );
  ''');

    final List<Map<String, dynamic>> maps =
        await db.query('sentence_exercises');

    if (maps.isEmpty) {
      return [];
    }

    return List<Exercise<WordForm, Sentence>>.from(
      maps.map(
        (map) => Exercise.fromJson<WordForm, Sentence>(
          jsonDecode(map['exercise']),
        ),
      ),
    );
  }

  Future<List<Exercise<Gender, Noun>>> cachedGenderExercises() async {
    final db = await _dbHelper.getDatabase();

    // Check if the table exists
    await db.execute('''
    CREATE TABLE IF NOT EXISTS noun_exercises (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exercise TEXT NOT NULL
    );
  ''');

    final List<Map<String, dynamic>> maps = await db.query('noun_exercises');

    if (maps.isEmpty) {
      return [];
    }

    return List<Exercise<Gender, Noun>>.from(
      maps.map(
        (map) => Exercise.fromJson<Gender, Noun>(
          jsonDecode(map['exercise']),
        ),
      ),
    );
  }

  Future<void> updateExercises(List<Exercise> exercises) async {
    final db = await _dbHelper.getDatabase();
    final batch = db.batch();

    final tableName = exercises is List<Exercise<WordForm, Sentence>>
        ? 'sentence_exercises'
        : exercises is List<Exercise<Gender, Noun>>
            ? 'noun_exercises'
            : throw Exception();

    // Clear the table
    await db.delete(tableName);

    for (var exercise in exercises) {
      final json = exercise.toJson();
      final jsonExercise = jsonEncode(json);

      batch.insert(
        tableName,
        {'exercise': jsonExercise},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
