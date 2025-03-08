import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/extensions/gender_extension.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/utilities/db_helper.dart';
import 'package:grammatika/utilities/explanation_helper.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseCacheService {
  ExerciseCacheService(
      {@visibleForTesting DbHelper? dbHelper,
      @visibleForTesting VoidCallback? onFetchSentenceExercises,
      @visibleForTesting VoidCallback? onFetchGenderExercises})
      : _dbHelper = dbHelper ?? DbHelper(),
        _onFetchSentenceExercises = onFetchSentenceExercises,
        _onFetchGenderExercises = onFetchGenderExercises;
  late final DbHelper _dbHelper;
  late final VoidCallback? _onFetchSentenceExercises;
  late final VoidCallback? _onFetchGenderExercises;

  @visibleForTesting
  bool updatingSentenceExercises = false;
  @visibleForTesting
  bool updatingGenderExercises = false;
  @visibleForTesting
  List<Exercise<WordForm, Sentence>>? cachedSentenceExercises;
  @visibleForTesting
  List<Exercise<Gender, Noun>>? cachedGenderExercises;

  @visibleForTesting
  Future<List<Exercise<WordForm, Sentence>>>
      cachedSQLiteSentenceExercises() async {
    if (cachedSentenceExercises != null) {
      return cachedSentenceExercises!;
    }
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

  @visibleForTesting
  Future<List<Exercise<Gender, Noun>>> cachedSQLiteGenderExercises() async {
    if (cachedGenderExercises != null) {
      return cachedGenderExercises!;
    }

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

  Future<Exercise<WordForm, Sentence>> getCachedSentenceExercise() async {
    if ((await cachedSQLiteSentenceExercises()).isNotEmpty == false) {
      await fetchSentenceExercises();
    }
    return cachedSentenceExercises!.removeAt(0);
  }

  Future<Exercise<Gender, Noun>> getCachedGenderExercise() async {
    if ((await cachedSQLiteGenderExercises()).isNotEmpty == false) {
      await fetchGenderExercises();
    }
    return cachedGenderExercises!.removeAt(0);
  }

  Future<void> reCacheSentenceExercisesIfNeeded() async {
    if (!updatingSentenceExercises) {
      if ((cachedSentenceExercises?.length ?? 0) < 10) {
        await fetchSentenceExercises();
      }
      updateExercises(cachedSentenceExercises ?? []);
      updatingSentenceExercises = false;
    }
  }

  Future<void> reCacheGenderExercisesIfNeeded() async {
    if (!updatingGenderExercises) {
      if ((cachedGenderExercises?.length ?? 0) < 10) {
        await fetchGenderExercises();
      }
      updateExercises(cachedGenderExercises ?? []);
      updatingGenderExercises = false;
    }
  }

  @visibleForTesting
  Future<void> fetchSentenceExercises() async {
    updatingSentenceExercises = true;
    _onFetchSentenceExercises?.call();
    final db = await _dbHelper.getDatabase();

    final List<Map<String, dynamic>> sentenceQueryRows = (await db.rawQuery(
      _dbHelper.randomSentenceQueryString(),
    ));

    List<Future<void>> futures = [];

    for (var sentenceQueryRow in sentenceQueryRows) {
      futures.add(Future(() async {
        try {
          final List<Map<String, dynamic>> answers = (await db.rawQuery(
              'SELECT form_type, position AS word_form_position, form, _form_bare FROM words_forms WHERE word_id = ${sentenceQueryRow['word_id']} AND _form_bare IS NOT NULL;'));
          final correctAnswer = WordForm.fromJson(sentenceQueryRow);
          final (
            explanation,
            visualExplanation
          ) = GetIt.instance.get<ExplanationHelper>().sentenceExplanation(
                correctAnswer: correctAnswer,
                bare: sentenceQueryRow['bare'],
                wordFormTypesToBareMap: <WordFormType, String>{
                  for (var answer in answers)
                    WordFormTypeExt.fromString(answer['form_type']):
                        answer['_form_bare'],
                },
                gender: GenderExtension.fromString(sentenceQueryRow['gender']),
              );
          final json = {
            ...sentenceQueryRow,
            'answer_synonyms': answers.where((element) {
              return element['_form_bare'] == sentenceQueryRow['_form_bare'] &&
                  element['form_type'] != sentenceQueryRow['form_type'];
            }),
            'possible_answers': answers,
            'explanation': explanation,
            'visual_explanation': visualExplanation,
            ...correctAnswer.toJson(),
          };
          final sentence = Sentence.fromJson(json);
          final exercise = Exercise<WordForm, Sentence>(
            question: sentence,
            answers: null,
          );
          cachedSentenceExercises == null
              ? cachedSentenceExercises = [exercise]
              : cachedSentenceExercises?.add(exercise);
        } catch (e) {
          log('Error: $e');
        }
      }));
    }

    await Future.wait(futures);

    updatingSentenceExercises = false;
  }

  @visibleForTesting
  Future<void> fetchGenderExercises() async {
    updatingGenderExercises = true;
    _onFetchGenderExercises?.call();
    final db = await _dbHelper.getDatabase();

    final List<Map<String, dynamic>> nounQueryRows = (await db.rawQuery(
      _dbHelper.randomNounQueryString(),
    ));

    for (var nounQueryRow in nounQueryRows) {
      try {
        final answers = Gender.values.map((gender) => gender.name);
        final explanation = GetIt.instance
            .get<ExplanationHelper>()
            .genderExplanation(
                bare: nounQueryRow['bare'],
                correctAnswer: Gender.values.byName(nounQueryRow['gender']));
        final json = {
          ...nounQueryRow,
          'possible_answers': answers,
          'explanation': explanation,
        };
        final noun = Noun.fromJson(json);
        final exercise = Exercise<Gender, Noun>(
          question: noun,
          answers: null,
        );
        cachedGenderExercises == null
            ? cachedGenderExercises = [exercise]
            : cachedGenderExercises?.add(exercise);
      } catch (e) {
        log('Error: $e');
      }
    }

    updatingGenderExercises = false;
  }

  @visibleForTesting
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
