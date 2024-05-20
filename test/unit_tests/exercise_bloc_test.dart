import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/explanation_helper.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';

import '../test_utils.dart';
import 'mocks.dart';

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
            'SELECT form_type, form, _form_bare FROM words_forms WHERE word_id = ${sentence.word.id};'))
        .thenAnswer((invocation) async => []);
    when(() => mockExplanationHelper.genderExplanation(
            bare: any(named: 'bare'),
            correctAnswer: any(named: 'correctAnswer')))
        .thenAnswer((invocation) => 'because I said so');
    when(() => mockExplanationHelper.sentenceExplanation())
        .thenAnswer((invocation) => 'because I said so');
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
          ExerciseExerciseRetrievedState(
              exercise: Exercise<Gender, Noun>(
            question: noun,
            answer: null,
          )),
        ],
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
          ExerciseExerciseRetrievedState(
              exercise: Exercise<WordForm, Sentence>(
            question: sentence,
            answer: null,
          )),
        ],
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
      );

      blocTest(
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExplanationHelper.sentenceExplanation throws',
        build: () => testObject,
        setUp: () {
          when(() => mockExplanationHelper.sentenceExplanation())
              .thenThrow(Exception());
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseErrorState(errorString: 'Unable to parse sentence from JSON'),
        ],
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
        ExerciseExerciseRetrievedState(
          exercise: Exercise<Gender, Noun>(
            question: noun,
            answer: null,
          ),
        ),
      ],
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
    );
  });

  group('ExerciseRetrieveRandomSentenceEvent', () {
    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseExerciseRetrievedState with Exercise<WordForm, Sentence> when db query succeeds',
      build: () => testObject,
      act: (bloc) => bloc.add(ExerciseRetrieveRandomSentenceEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseExerciseRetrievedState(
            exercise: Exercise<WordForm, Sentence>(
          question: sentence,
          answer: null,
        )),
      ],
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
    );

    blocTest(
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExplanationHelper.sentenceExplanation throws',
      build: () => testObject,
      setUp: () {
        when(() => mockExplanationHelper.sentenceExplanation())
            .thenThrow(Exception());
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomSentenceEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseErrorState(errorString: 'Unable to parse sentence from JSON'),
      ],
    );
  });
}
