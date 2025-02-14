import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/blocs/exercise/exercise_bloc.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/services/enabled_exercises_service.dart';
import 'package:uchu/services/statistics_service.dart';
import 'package:uchu/utilities/db_helper.dart';
import 'package:uchu/utilities/explanation_helper.dart';

import '../../../test_utils.dart';
import '../../mocks.dart';

main() {
  late ExerciseBloc testObject;
  late DbHelper mockDbHelper;
  late Database mockDatabase;
  late Random mockRandom;
  late ExplanationHelper mockExplanationHelper;
  late EnabledExercisesService mockEnabledExercisesService;
  late StatisticsService mockStatisticsService;
  final Noun noun = Noun.testValue();
  final Sentence sentence = Sentence.testValue();

  const mockRandomNounQueryString = 'abc';
  const mockRandomSentenceQueryString = 'def';

  setUpAll(TestUtils.registerFallbackValues);

  setUp(() async {
    await GetIt.instance.reset();
    mockDatabase = MockDatabase();
    mockDbHelper = MockDbHelper();
    mockRandom = MockRandom();
    mockExplanationHelper = MockExplanationHelper();
    mockEnabledExercisesService = MockEnabledExercisesService();
    mockStatisticsService = MockStatisticsService();

    when(() => mockDbHelper.getDatabase())
        .thenAnswer((invocation) async => mockDatabase);
    when(() => mockDbHelper.randomNounQueryString())
        .thenReturn(mockRandomNounQueryString);
    when(() => mockDbHelper.randomSentenceQueryString())
        .thenReturn(mockRandomSentenceQueryString);
    when(() => mockDatabase.rawQuery(mockRandomNounQueryString))
        .thenAnswer((invocation) async => [noun.toJson()]);
    when(() => mockDatabase.rawQuery(mockRandomSentenceQueryString))
        .thenAnswer((invocation) async => [sentence.toJson()]);
    when(() => mockDatabase.rawQuery(
            'SELECT form_type, position AS word_form_position, form, _form_bare FROM words_forms WHERE word_id = ${sentence.word.id};'))
        .thenAnswer((invocation) async {
      return sentence.possibleAnswers.map((e) => e.toJson()).toList();
    });
    when(() => mockExplanationHelper.genderExplanation(
            bare: any(named: 'bare'),
            correctAnswer: any(named: 'correctAnswer')))
        .thenAnswer((invocation) => 'because I said so');
    when(() => mockExplanationHelper.sentenceExplanation(
            bare: any(named: 'bare'),
            correctAnswer: any(named: 'correctAnswer'),
            wordFormTypesToBareMap: any(named: 'wordFormTypesToBareMap')))
        .thenAnswer((invocation) => ('because I said so', 'сказ- ➡️ сказал'));
    when(() => mockStatisticsService.addExercisePassed(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockStatisticsService.addExerciseFailed(any(), any()))
        .thenAnswer((_) async {});

    GetIt.instance.registerSingleton<DbHelper>(mockDbHelper);
    GetIt.instance.registerSingleton<ExplanationHelper>(mockExplanationHelper);
    GetIt.instance.registerSingleton<EnabledExercisesService>(
        mockEnabledExercisesService);
    GetIt.instance.registerSingleton<StatisticsService>(mockStatisticsService);
    testObject = ExerciseBloc(mockRandom: mockRandom);
  });

  group('ExerciseRetrieveExerciseEvent', () {
    group('when random.nextInt returns 0', () {
      setUp(() {
        when(() => mockRandom.nextInt(any())).thenReturn(0);
      });
      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseExerciseRetrievedState with Exercise<Gender, Noun> when no exercises are disabled and db query succeeds',
        build: () => testObject,
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseExerciseRetrievedState(),
        ],
        tearDown: () {
          expect(
              testObject.exercise,
              Exercise<Gender, Noun>(
                question: noun,
                answers: null,
              ));
        },
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseExerciseRetrievedState with Exercise<WordForm, Sentence> when all gender exercises are disabled and db query succeeds',
        build: () => testObject,
        setUp: () {
          when(() => mockEnabledExercisesService.getDisabledExercises())
              .thenReturn(Gender.values
                  .map(
                    (e) => e.name,
                  )
                  .toList());
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseExerciseRetrievedState(),
        ],
        tearDown: () {
          expect(
              testObject.exercise,
              Exercise<WordForm, Sentence>(
                question: sentence,
                answers: null,
              ));
        },
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseExerciseRetrievedState with Exercise<Gender, Noun> when all word form type exercises are disabled and db query succeeds',
        build: () => testObject,
        setUp: () {
          when(() => mockEnabledExercisesService.getDisabledExercises())
              .thenReturn(WordFormType.values
                  .map(
                    (e) => e.name,
                  )
                  .toList());
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseExerciseRetrievedState(),
        ],
        tearDown: () {
          expect(
              testObject.exercise,
              Exercise<Gender, Noun>(
                question: noun,
                answers: null,
              ));
        },
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when DbHelper.getDatabase throws',
        build: () => testObject,
        setUp: () {
          when(() => mockDbHelper.getDatabase())
              .thenThrow(Exception('something went wrong!'));
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
        ],
        tearDown: () {
          expect(testObject.exercise, isNull);
        },
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when Database.rawQuery throws',
        build: () => testObject,
        setUp: () {
          when(() => mockDatabase.rawQuery(any()))
              .thenThrow(Exception('something went wrong!'));
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
        ],
        tearDown: () {
          expect(testObject.exercise, isNull);
        },
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExplanationHelper.genderExplanation throws',
        build: () => testObject,
        setUp: () {
          when(() => mockExplanationHelper.genderExplanation(
                  bare: any(named: 'bare'),
                  correctAnswer: any(named: 'correctAnswer')))
              .thenThrow(Exception());
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
        ],
        tearDown: () {
          expect(testObject.exercise, isNull);
        },
      );
    });

    group('when random.nextInt returns 1', () {
      setUp(() {
        when(() => mockRandom.nextInt(any())).thenReturn(1);
      });
      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseExerciseRetrievedState with Exercise<WordForm, Sentence> when db query succeeds',
        build: () => testObject,
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseExerciseRetrievedState(),
        ],
        tearDown: () {
          expect(
              testObject.exercise,
              Exercise<WordForm, Sentence>(
                question: sentence,
                answers: null,
              ));
        },
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when DbHelper.getDatabase throws',
        build: () => testObject,
        setUp: () {
          when(() => mockDbHelper.getDatabase())
              .thenThrow(Exception('something went wrong!'));
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseErrorState(errorString: 'Unable to parse sentence from JSON'),
        ],
        tearDown: () {
          expect(testObject.exercise, isNull);
        },
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when Database.rawQuery throws',
        build: () => testObject,
        setUp: () {
          when(() => mockDatabase.rawQuery(any()))
              .thenThrow(Exception('something went wrong!'));
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseErrorState(errorString: 'Unable to parse sentence from JSON'),
        ],
        tearDown: () {
          expect(testObject.exercise, isNull);
        },
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExplanationHelper.sentenceExplanation throws',
        build: () => testObject,
        setUp: () {
          when(() => mockExplanationHelper.sentenceExplanation(
                  bare: any(named: 'bare'),
                  correctAnswer: any(named: 'correctAnswer'),
                  wordFormTypesToBareMap: any(named: 'wordFormTypesToBareMap')))
              .thenThrow(Exception());
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseErrorState(errorString: 'Unable to parse sentence from JSON'),
        ],
        tearDown: () {
          expect(testObject.exercise, isNull);
        },
      );
    });
  });

  group('ExerciseRetrieveRandomNounEvent', () {
    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseExerciseRetrievedState with Exercise<Gender, Noun> when db query succeeds',
      build: () => testObject,
      act: (bloc) => bloc.add(ExerciseRetrieveRandomNounEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseExerciseRetrievedState(),
      ],
      tearDown: () {
        expect(
            testObject.exercise,
            Exercise<Gender, Noun>(
              question: noun,
              answers: null,
            ));
      },
    );

    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when DbHelper.getDatabase throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDbHelper.getDatabase())
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomNounEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
      tearDown: () {
        expect(testObject.exercise, isNull);
      },
    );

    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when Database.rawQuery throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDatabase.rawQuery(any()))
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomNounEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
      tearDown: () {
        expect(testObject.exercise, isNull);
      },
    );

    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExplanationHelper.genderExplanation throws',
      build: () => testObject,
      setUp: () {
        when(() => mockExplanationHelper.genderExplanation(
            bare: any(named: 'bare'),
            correctAnswer: any(named: 'correctAnswer'))).thenThrow(Exception());
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomNounEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
      tearDown: () {
        expect(testObject.exercise, isNull);
      },
    );
  });

  group('ExerciseRetrieveRandomSentenceEvent', () {
    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseExerciseRetrievedState with Exercise<WordForm, Sentence> when db query succeeds',
      build: () => testObject,
      act: (bloc) => bloc.add(ExerciseRetrieveRandomSentenceEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseExerciseRetrievedState(),
      ],
      tearDown: () {
        expect(
            testObject.exercise,
            Exercise<WordForm, Sentence>(
              question: sentence,
              answers: null,
            ));
      },
    );

    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when DbHelper.getDatabase throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDbHelper.getDatabase())
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomSentenceEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseErrorState(errorString: 'Unable to parse sentence from JSON'),
      ],
      tearDown: () {
        expect(testObject.exercise, isNull);
      },
    );

    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when Database.rawQuery throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDatabase.rawQuery(any()))
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomSentenceEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseErrorState(errorString: 'Unable to parse sentence from JSON'),
      ],
      tearDown: () {
        expect(testObject.exercise, isNull);
      },
    );

    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExplanationHelper.sentenceExplanation throws',
      build: () => testObject,
      setUp: () {
        when(() => mockExplanationHelper.sentenceExplanation(
                bare: any(named: 'bare'),
                correctAnswer: any(named: 'correctAnswer'),
                wordFormTypesToBareMap: any(named: 'wordFormTypesToBareMap')))
            .thenThrow(Exception());
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomSentenceEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseErrorState(errorString: 'Unable to parse sentence from JSON'),
      ],
      tearDown: () {
        expect(testObject.exercise, isNull);
      },
    );
  });

  group('ExerciseSubmitAnswerEvent', () {
    final initialExercise = Exercise<WordForm, Sentence>(
      question: sentence,
      answers: null,
    );
    final answersToAdd = [WordForm.testValue()];
    blocTest(
      'emits ExerciseAnswerSelectedState, appending answers to existing Exercise',
      build: () => testObject,
      setUp: () {
        testObject.exercise = initialExercise;
      },
      act: (bloc) => bloc.add(ExerciseSubmitAnswerEvent(answers: answersToAdd)),
      expect: () => [
        ExerciseAnswerSelectedState(),
      ],
      tearDown: () {
        expect(
          testObject.exercise,
          Exercise<WordForm, Sentence>(
            question: initialExercise.question,
            answers: answersToAdd,
          ),
        );
      },
    );

    blocTest(
      'invokes StatisticsService.addExercisePassed when correct answer is selected',
      build: () => testObject,
      setUp: () {
        testObject.exercise = initialExercise;
      },
      act: (bloc) => bloc.add(
        ExerciseSubmitAnswerEvent(
          answers: [
            testObject.exercise!.question.correctAnswer as WordForm,
          ],
        ),
      ),
      verify: (_) {
        final correctAnswer = initialExercise.question.correctAnswer.type.name;

        verify(() =>
                mockStatisticsService.addExercisePassed(correctAnswer, any()))
            .called(1);
        verifyNever(() =>
            mockStatisticsService.addExerciseFailed(correctAnswer, any()));
      },
    );

    blocTest(
      'invokes StatisticsService.addExerciseFailed when incorrect answer is selected',
      build: () => testObject,
      setUp: () {
        testObject.exercise = initialExercise;
      },
      act: (bloc) => bloc.add(
        ExerciseSubmitAnswerEvent(
          answers: [
            WordForm.testValue(
              type: WordFormType.ruVerbGerundPresent,
            )
          ],
        ),
      ),
      verify: (_) {
        final correctAnswer = initialExercise.question.correctAnswer.type.name;

        verifyNever(() =>
            mockStatisticsService.addExercisePassed(correctAnswer, any()));
        verify(() =>
                mockStatisticsService.addExerciseFailed(correctAnswer, any()))
            .called(1);
      },
    );
  });
}
