import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/blocs/exercise/exercise_bloc.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
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
  final Noun noun = Noun.testValue();
  final Sentence sentence = Sentence.testValue();

  setUpAll(TestUtils.registerFallbackValues);

  setUp(() async {
    await GetIt.instance.reset();
    mockDatabase = MockDatabase();
    mockDbHelper = MockDbHelper();
    mockRandom = MockRandom();
    mockExplanationHelper = MockExplanationHelper();
    when(() => mockDbHelper.getDatabase())
        .thenAnswer((invocation) async => mockDatabase);
    when(() => mockDatabase.rawQuery(randomNounQueryString))
        .thenAnswer((invocation) async => [noun.toJson()]);
    when(() => mockDatabase.rawQuery(randomSentenceQueryString))
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
    GetIt.instance.registerSingleton<DbHelper>(mockDbHelper);
    GetIt.instance.registerSingleton<ExplanationHelper>(mockExplanationHelper);
    testObject = ExerciseBloc(mockRandom: mockRandom);
  });

  group('ExerciseRetrieveExerciseEvent', () {
    group('when random.nextInt returns 0', () {
      setUp(() {
        when(() => mockRandom.nextInt(any())).thenReturn(0);
      });
      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseExerciseRetrievedState with Exercise<Gender, Noun> when db query succeeds',
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
  });
}
