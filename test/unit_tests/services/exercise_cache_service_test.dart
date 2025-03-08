import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/services/exercise_cache_service.dart';
import 'package:grammatika/utilities/db_helper.dart';
import 'package:grammatika/utilities/explanation_helper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import '../../test_utils.dart';
import '../mocks.dart';

main() {
  late Batch mockBatch;
  late Database mockDatabase;
  late DbHelper mockDbHelper;
  late ExplanationHelper mockExplanationHelper;
  late ExerciseCacheService testObject;

  setUpAll(TestUtils.registerFallbackValues);

  setUp(() async {
    await GetIt.instance.reset();

    mockBatch = MockBatch();
    when(() => mockBatch.insert(any(), any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm')))
        .thenAnswer((_) async => 0);
    when(() => mockBatch.commit(noResult: true)).thenAnswer((_) async => []);

    mockDatabase = MockDatabase();
    when(() => mockDatabase.execute(any())).thenAnswer((_) async {});
    when(() => mockDatabase.query(any())).thenAnswer((_) async => []);
    when(() => mockDatabase.rawQuery(any())).thenAnswer((_) async => []);
    when(() => mockDatabase.batch()).thenReturn(mockBatch);
    when(() => mockDatabase.delete(any())).thenAnswer((_) async => 0);

    mockDbHelper = MockDbHelper();
    when(() => mockDbHelper.getDatabase())
        .thenAnswer((_) async => mockDatabase);
    when(() => mockDbHelper.randomSentenceQueryString()).thenAnswer(
      (_) => 'some string',
    );
    when(() => mockDbHelper.randomNounQueryString()).thenAnswer(
      (_) => 'some other string',
    );

    mockExplanationHelper = MockExplanationHelper();
    when(
      () => mockExplanationHelper.sentenceExplanation(
        bare: any(named: 'bare'),
        correctAnswer: any(named: 'correctAnswer'),
        wordFormTypesToBareMap: any(named: 'wordFormTypesToBareMap'),
        gender: any(named: 'gender'),
      ),
    ).thenReturn(('explanation', 'visual explanation'));

    GetIt.instance.registerSingleton<ExplanationHelper>(mockExplanationHelper);

    testObject = ExerciseCacheService(dbHelper: mockDbHelper);
  });

  group('cachedSQLiteSentenceExercises', () {
    test(
      'returns cachedSentenceExercises when not null',
      () async {
        final expectedCachedSentenceExercises = [
          Exercise<WordForm, Sentence>(
            question: Sentence.testValue(),
            answers: [WordForm.testValue()],
          ),
        ];
        testObject.cachedSentenceExercises = expectedCachedSentenceExercises;

        expect(await testObject.cachedSQLiteSentenceExercises(),
            expectedCachedSentenceExercises);
      },
    );

    test(
      'gets database and executes expected queries when cachedSentenceExercises is null',
      () async {
        await testObject.cachedSQLiteSentenceExercises();
        verify(() => mockDbHelper.getDatabase()).called(1);
        verify(() => mockDatabase.execute('''
    CREATE TABLE IF NOT EXISTS sentence_exercises (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exercise TEXT NOT NULL
    );
  ''')).called(1);
        verify(() => mockDatabase.query('sentence_exercises')).called(1);
      },
    );

    test(
      'converts db response to List of Sentence Exercises when db response is not empty',
      () async {
        final expectedSentenceExercises = [
          Exercise<WordForm, Sentence>(
            question: Sentence.testValue(),
            answers: null,
          ),
        ];
        when(() => mockDatabase.query('sentence_exercises')).thenAnswer(
          (_) async => [
            {
              'exercise': jsonEncode(expectedSentenceExercises.first.toJson()),
            },
          ],
        );

        expect(await testObject.cachedSQLiteSentenceExercises(),
            expectedSentenceExercises);
      },
    );
  });

  group('cachedSQLiteGenderExercises', () {
    test(
      'returns cachedGenderExercises when not null',
      () async {
        final expectedCachedGenderExercises = [
          Exercise<Gender, Noun>(
            question: Noun.testValue(),
            answers: const [
              Gender.m,
            ],
          ),
        ];
        testObject.cachedGenderExercises = expectedCachedGenderExercises;

        expect(await testObject.cachedSQLiteGenderExercises(),
            expectedCachedGenderExercises);
      },
    );

    test(
      'gets database and executes expected queries when cachedGenderExercises is null',
      () async {
        await testObject.cachedSQLiteGenderExercises();
        verify(() => mockDbHelper.getDatabase()).called(1);
        verify(() => mockDatabase.execute('''
    CREATE TABLE IF NOT EXISTS noun_exercises (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exercise TEXT NOT NULL
    );
  ''')).called(1);
        verify(() => mockDatabase.query('noun_exercises')).called(1);
      },
    );

    test(
      'converts db response to List of Gender Exercises when db response is not empty',
      () async {
        final expectedGenderExercises = [
          Exercise<Gender, Noun>(
            question: Noun.testValue(),
            answers: null,
          ),
        ];
        when(() => mockDatabase.query('noun_exercises')).thenAnswer(
          (_) async => [
            {
              'exercise': jsonEncode(expectedGenderExercises.first.toJson()),
            },
          ],
        );

        expect(await testObject.cachedSQLiteGenderExercises(),
            expectedGenderExercises);
      },
    );
  });

  group('getCachedSentenceExercise', () {
    test(
        'invokes fetchSentenceExercises when cachedSQLiteSentenceExercises is empty',
        () async {
      when(() => mockDatabase.rawQuery(any())).thenAnswer(
        (_) async => [
          Exercise<WordForm, Sentence>(
              question: Sentence.testValue(), answers: const [])
        ]
            .map(
              (e) => e.question.toJson(),
            )
            .toList(),
      );

      int fetchSentenceExercisesCallCount = 0;
      testObject = ExerciseCacheService(
        dbHelper: mockDbHelper,
        onFetchSentenceExercises: () async {
          fetchSentenceExercisesCallCount++;
        },
      );
      await testObject.getCachedSentenceExercise();
      expect(fetchSentenceExercisesCallCount, 1);
    });
    test(
        'removes element at index 0 when cachedSQLiteSentenceExercises is not empty',
        () async {
      final expectedCachedSentenceExercise = Exercise<WordForm, Sentence>(
        question: Sentence.testValue(),
        answers: [
          WordForm.testValue(),
        ],
      );
      testObject.cachedSentenceExercises = [expectedCachedSentenceExercise];

      final result = await testObject.getCachedSentenceExercise();
      expect(result, expectedCachedSentenceExercise);
      expect(testObject.cachedSentenceExercises, isEmpty);
    });
  });

  group('getCachedGenderExercise', () {
    test(
        'invokes fetchGenderExercises when cachedSQLiteSentenceExercises is empty',
        () async {
      when(() => mockExplanationHelper.genderExplanation(
              bare: any(named: 'bare'),
              correctAnswer: any(named: 'correctAnswer')))
          .thenReturn('some explanation');
      when(() => mockDatabase.rawQuery(any())).thenAnswer(
        (_) async => [
          Exercise<Gender, Noun>(question: Noun.testValue(), answers: const [])
        ]
            .map(
              (e) => e.question.toJson(),
            )
            .toList(),
      );

      int fetchGenderExercisesCallCount = 0;
      testObject = ExerciseCacheService(
        dbHelper: mockDbHelper,
        onFetchGenderExercises: () async {
          fetchGenderExercisesCallCount++;
        },
      );
      await testObject.getCachedGenderExercise();
      expect(fetchGenderExercisesCallCount, 1);
    });
    test(
        'removes element at index 0 when cachedSQLiteGenderExercises is not empty',
        () async {
      final expectedCachedGenderExercise = Exercise<Gender, Noun>(
        question: Noun.testValue(),
        answers: const [
          Gender.m,
        ],
      );
      testObject.cachedGenderExercises = [expectedCachedGenderExercise];

      final result = await testObject.getCachedGenderExercise();
      expect(result, expectedCachedGenderExercise);
      expect(testObject.cachedGenderExercises, isEmpty);
    });
  });

  group('reCacheSentenceExercisesIfNeeded', () {
    test('does nothing if updatingSentenceExercises', () {
      int fetchSentenceExercisesCallCount = 0;
      testObject = ExerciseCacheService(
        dbHelper: mockDbHelper,
        onFetchSentenceExercises: () => fetchSentenceExercisesCallCount++,
      );
      testObject.updatingSentenceExercises = true;
      testObject.reCacheSentenceExercisesIfNeeded();

      expect(fetchSentenceExercisesCallCount, 0);
      verifyNever(() => mockDbHelper.getDatabase());
    });

    test(
        'fetchesSentenceExercises and updates exercises when cachedSentenceExercises.length < 10',
        () {
      int fetchSentenceExercisesCallCount = 0;
      testObject = ExerciseCacheService(
        dbHelper: mockDbHelper,
        onFetchSentenceExercises: () => fetchSentenceExercisesCallCount++,
      );
      testObject.cachedSentenceExercises = List.generate(
          9,
          (index) => Exercise<WordForm, Sentence>(
                question: Sentence.testValue(wordId: index),
                answers: null,
              ));
      testObject.reCacheSentenceExercisesIfNeeded();

      expect(fetchSentenceExercisesCallCount, 1);
      verify(() => mockDbHelper.getDatabase());
    });

    test(
        'does not fetch Sentence Exercises but does update exercises when cachedSentenceExercises.length >= 10',
        () {
      int fetchSentenceExercisesCallCount = 0;
      testObject = ExerciseCacheService(
        dbHelper: mockDbHelper,
        onFetchSentenceExercises: () => fetchSentenceExercisesCallCount++,
      );
      testObject.cachedSentenceExercises = List.generate(
          10,
          (index) => Exercise<WordForm, Sentence>(
                question: Sentence.testValue(wordId: index),
                answers: null,
              ));
      testObject.reCacheSentenceExercisesIfNeeded();

      expect(fetchSentenceExercisesCallCount, 0);
      verify(() => mockDbHelper.getDatabase());
    });
  });

  group('reCacheGenderExercisesIfNeeded', () {
    test('does nothing if updatingGenderExercises', () {
      int fetchGenderExercisesCallCount = 0;
      testObject = ExerciseCacheService(
        dbHelper: mockDbHelper,
        onFetchGenderExercises: () => fetchGenderExercisesCallCount++,
      );
      testObject.updatingGenderExercises = true;
      testObject.reCacheGenderExercisesIfNeeded();

      expect(fetchGenderExercisesCallCount, 0);
      verifyNever(() => mockDbHelper.getDatabase());
    });

    test(
        'fetchesGenderExercises and updates exercises when cachedGenderExercises.length < 10',
        () {
      int fetchGenderExercisesCallCount = 0;
      testObject = ExerciseCacheService(
        dbHelper: mockDbHelper,
        onFetchGenderExercises: () => fetchGenderExercisesCallCount++,
      );
      testObject.cachedGenderExercises = List.generate(
          9,
          (index) => Exercise<Gender, Noun>(
                question: Noun.testValue(wordId: index),
                answers: null,
              ));
      testObject.reCacheGenderExercisesIfNeeded();

      expect(fetchGenderExercisesCallCount, 1);
      verify(() => mockDbHelper.getDatabase());
    });

    test(
        'does not fetch Gender Exercises but does update exercises when cachedGenderExercises.length >= 10',
        () {
      int fetchGenderExercisesCallCount = 0;
      testObject = ExerciseCacheService(
        dbHelper: mockDbHelper,
        onFetchGenderExercises: () => fetchGenderExercisesCallCount++,
      );
      testObject.cachedGenderExercises = List.generate(
          10,
          (index) => Exercise<Gender, Noun>(
                question: Noun.testValue(wordId: index),
                answers: null,
              ));
      testObject.reCacheGenderExercisesIfNeeded();

      expect(fetchGenderExercisesCallCount, 0);
      verify(() => mockDbHelper.getDatabase());
    });
  });

  group('fetchSentenceExercises', () {
    test(
        'sets updatingSentenceExercises to true and back to false upon completion',
        () async {
      final fetchSentenceExercisesCompleter = Completer<void>();
      expect(testObject.updatingSentenceExercises, isFalse);
      testObject.fetchSentenceExercises().then(
        (value) {
          fetchSentenceExercisesCompleter.complete();
        },
      );
      expect(testObject.updatingSentenceExercises, isTrue);
      await fetchSentenceExercisesCompleter.future;
      expect(testObject.updatingSentenceExercises, isFalse);
    });

    test(
      'gets database and queries for answers for each sentence exercise',
      () async {
        final expectedSentenceExercises = [
          Exercise<WordForm, Sentence>(
            question: Sentence.testValue(wordId: 123),
            answers: null,
          ),
          Exercise<WordForm, Sentence>(
            question: Sentence.testValue(wordId: 456),
            answers: null,
          ),
        ];
        when(() => mockDatabase.rawQuery(any())).thenAnswer(
          (_) async => expectedSentenceExercises
              .map(
                (e) => e.question.toJson(),
              )
              .toList(),
        );

        await testObject.fetchSentenceExercises();
        verify(() => mockDbHelper.getDatabase()).called(1);
        for (var sentenceExercise in expectedSentenceExercises) {
          verify(() => mockDatabase.rawQuery(
              'SELECT form_type, position AS word_form_position, form, _form_bare FROM words_forms WHERE word_id = ${sentenceExercise.question.word.id} AND _form_bare IS NOT NULL;'));
        }
      },
    );

    test(
      'fetches explanation for each fetched sentence',
      () async {
        final expectedSentenceExercises = [
          Exercise<WordForm, Sentence>(
            question: Sentence.testValue(wordId: 123, bare: 'бежать'),
            answers: null,
          ),
          Exercise<WordForm, Sentence>(
            question: Sentence.testValue(wordId: 456, bare: 'прыгать'),
            answers: null,
          ),
        ];
        when(() => mockDatabase.rawQuery(any())).thenAnswer(
          (_) async => expectedSentenceExercises
              .map(
                (e) => e.question.toJson(),
              )
              .toList(),
        );

        await testObject.fetchSentenceExercises();
        for (var sentenceExercise in expectedSentenceExercises) {
          verify(
            () => mockExplanationHelper.sentenceExplanation(
              correctAnswer: sentenceExercise.question.correctAnswer,
              bare: sentenceExercise.question.word.bare,
              wordFormTypesToBareMap: any(named: 'wordFormTypesToBareMap'),
              gender: null,
            ),
          );
        }
      },
    );

    test(
      'sets cachedSentenceExercises to fetched sentence exercises',
      () async {
        final expectedSentenceExercises = [
          Exercise<WordForm, Sentence>(
            question: Sentence.testValue(wordId: 123, bare: 'бежать'),
            answers: null,
          ),
          Exercise<WordForm, Sentence>(
            question: Sentence.testValue(wordId: 456, bare: 'прыгать'),
            answers: null,
          ),
        ];
        when(() => mockDatabase.rawQuery(any())).thenAnswer(
          (_) async => expectedSentenceExercises
              .map(
                (e) => e.question.toJson(),
              )
              .toList(),
        );
        when(() => mockDatabase.rawQuery(
                '''SELECT form_type, position AS word_form_position, form, _form_bare FROM words_forms WHERE word_id = ${expectedSentenceExercises[0].question.word.id} AND _form_bare IS NOT NULL;'''))
            .thenAnswer((_) async => expectedSentenceExercises[0]
                .question
                .possibleAnswers
                .map(
                  (e) => e.toJson(),
                )
                .toList());
        when(() => mockDatabase.rawQuery(
                '''SELECT form_type, position AS word_form_position, form, _form_bare FROM words_forms WHERE word_id = ${expectedSentenceExercises[1].question.word.id} AND _form_bare IS NOT NULL;'''))
            .thenAnswer((_) async => expectedSentenceExercises[1]
                .question
                .possibleAnswers
                .map(
                  (e) => e.toJson(),
                )
                .toList());
        when(
          () => mockExplanationHelper.sentenceExplanation(
            bare: expectedSentenceExercises[0].question.word.bare,
            correctAnswer: any(named: 'correctAnswer'),
            wordFormTypesToBareMap: any(named: 'wordFormTypesToBareMap'),
            gender: any(named: 'gender'),
          ),
        ).thenReturn((
          expectedSentenceExercises[0].question.explanation,
          expectedSentenceExercises[0].question.visualExplanation
        ));
        when(() => mockExplanationHelper.sentenceExplanation(
              bare: expectedSentenceExercises[1].question.word.bare,
              correctAnswer: any(named: 'correctAnswer'),
              wordFormTypesToBareMap: any(named: 'wordFormTypesToBareMap'),
            )).thenReturn((
          expectedSentenceExercises[1].question.explanation,
          expectedSentenceExercises[1].question.visualExplanation
        ));

        await testObject.fetchSentenceExercises();

        expect(testObject.cachedSentenceExercises, expectedSentenceExercises);
      },
    );
  });

  group('fetchGenderExercises', () {
    test(
        'sets updatingGenderExercises to true and back to false upon completion',
        () async {
      final fetchGenderExercisesCompleter = Completer<void>();
      expect(testObject.updatingGenderExercises, isFalse);
      testObject.fetchGenderExercises().then(
        (value) {
          fetchGenderExercisesCompleter.complete();
        },
      );
      expect(testObject.updatingGenderExercises, isTrue);
      await fetchGenderExercisesCompleter.future;
      expect(testObject.updatingGenderExercises, isFalse);
    });

    test(
      'fetches explanation for each fetched noun',
      () async {
        final expectedGenderExercises = [
          Exercise<Gender, Noun>(
            question: Noun.testValue(wordId: 123, bare: 'книга'),
            answers: null,
          ),
          Exercise<Gender, Noun>(
            question: Noun.testValue(wordId: 456, bare: 'стол'),
            answers: null,
          ),
        ];
        when(() => mockDatabase.rawQuery(any())).thenAnswer(
          (_) async => expectedGenderExercises
              .map(
                (e) => e.question.toJson(),
              )
              .toList(),
        );

        await testObject.fetchGenderExercises();
        for (var genderExercise in expectedGenderExercises) {
          verify(
            () => mockExplanationHelper.genderExplanation(
              correctAnswer: genderExercise.question.correctAnswer,
              bare: genderExercise.question.word.bare,
            ),
          );
        }
      },
    );

    test(
      'sets cachedGenderExercises to fetched gender exercises',
      () async {
        final expectedGenderExercises = [
          Exercise<Gender, Noun>(
            question: Noun.testValue(wordId: 123, bare: 'книга'),
            answers: null,
          ),
          Exercise<Gender, Noun>(
            question: Noun.testValue(wordId: 456, bare: 'стол'),
            answers: null,
          ),
        ];
        when(() => mockDatabase.rawQuery(any())).thenAnswer(
          (_) async => expectedGenderExercises
              .map(
                (e) => e.question.toJson(),
              )
              .toList(),
        );
        when(
          () => mockExplanationHelper.genderExplanation(
            bare: expectedGenderExercises[0].question.word.bare,
            correctAnswer: any(named: 'correctAnswer'),
          ),
        ).thenReturn(expectedGenderExercises[0].question.explanation);
        when(() => mockExplanationHelper.genderExplanation(
              bare: expectedGenderExercises[1].question.word.bare,
              correctAnswer: any(named: 'correctAnswer'),
            )).thenReturn(
          expectedGenderExercises[1].question.explanation,
        );

        await testObject.fetchGenderExercises();

        expect(testObject.cachedGenderExercises, expectedGenderExercises);
      },
    );
  });

  group('updateExercises', () {
    test('gets Database', () {
      testObject.updateExercises(<Exercise<WordForm, Sentence>>[]);
      verify(() => mockDbHelper.getDatabase()).called(1);
    });

    test(
        'throws if exercises is not List<Exercise<WordForm, Sentence>> or List<Exercise<Gender, Noun>>',
        () async {
      try {
        await testObject.updateExercises([]);
      } catch (e) {
        expect(e, isA<Exception>());
        return;
      }

      fail('should have thrown');
    });
    test('does not throw if exercises is List<Exercise<WordForm, Sentence>>',
        () async {
      await testObject.updateExercises(<Exercise<WordForm, Sentence>>[]);
    });
    test('does not throw if exercises is List<Exercise<Gender, Noun>>',
        () async {
      await testObject.updateExercises(<Exercise<Gender, Noun>>[]);
    });

    test(
        'deletes sentence_exercises table when exercises is List<Exercise<WordForm, Sentence>>',
        () async {
      await testObject.updateExercises(<Exercise<WordForm, Sentence>>[]);

      verify(() => mockDatabase.delete('sentence_exercises'));
    });

    test(
        'deletes noun_exercises table when exercises is List<Exercise<Gender, Noun>>',
        () async {
      await testObject.updateExercises(<Exercise<Gender, Noun>>[]);

      verify(() => mockDatabase.delete('noun_exercises'));
    });

    test(
        'inserts each exercise into sentence_exercises table when exercises is List<Exercise<WordForm, Sentence>>',
        () async {
      final expectedExercises = [
        Exercise<WordForm, Sentence>(
          question: Sentence.testValue(wordId: 123),
          answers: null,
        ),
        Exercise<WordForm, Sentence>(
          question: Sentence.testValue(wordId: 456),
          answers: null,
        ),
      ];
      await testObject.updateExercises(expectedExercises);

      for (final exercise in expectedExercises) {
        verify(() => mockBatch.insert(
            'sentence_exercises', {'exercise': jsonEncode(exercise.toJson())},
            conflictAlgorithm: ConflictAlgorithm.replace));
      }
    });

    test(
        'inserts each exercise into noun_exercises table when exercises is List<Exercise<Gender, Noun>>',
        () async {
      final expectedExercises = [
        Exercise<Gender, Noun>(
          question: Noun.testValue(wordId: 123),
          answers: null,
        ),
        Exercise<Gender, Noun>(
          question: Noun.testValue(wordId: 456),
          answers: null,
        ),
      ];
      await testObject.updateExercises(expectedExercises);

      for (final exercise in expectedExercises) {
        verify(() => mockBatch.insert(
            'noun_exercises', {'exercise': jsonEncode(exercise.toJson())},
            conflictAlgorithm: ConflictAlgorithm.replace));
      }
    });

    test('batch commits', () async {
      await testObject.updateExercises(<Exercise<WordForm, Sentence>>[]);

      verify(() => mockBatch.commit(noResult: true));
    });
  });
}
