import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/blocs/exercise/exercise_bloc.dart';
import 'package:grammatika/models/answer.dart' as Answer;
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/question.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:grammatika/services/exercise_cache_service.dart';
import 'package:grammatika/services/statistics_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_utils.dart';
import '../../mocks.dart';

main() {
  late ExerciseBloc testObject;
  late ExerciseCacheService mockExerciseCacheService;
  late Random mockRandom;
  late EnabledExercisesService mockEnabledExercisesService;
  late StatisticsService mockStatisticsService;
  final Noun noun = Noun.testValue();
  final Sentence sentence = Sentence.testValue();

  setUpAll(TestUtils.registerFallbackValues);

  setUp(() async {
    await GetIt.instance.reset();
    mockExerciseCacheService = MockExerciseCacheService();
    mockRandom = MockRandom();
    mockEnabledExercisesService = MockEnabledExercisesService();
    mockStatisticsService = MockStatisticsService();

    when(() => mockExerciseCacheService.getCachedSentenceExercise()).thenAnswer(
      (_) async => Exercise<WordForm, Sentence>(
        question: sentence,
        answers: null,
      ),
    );
    when(() => mockExerciseCacheService.getCachedGenderExercise()).thenAnswer(
      (_) async => Exercise<Gender, Noun>(
        question: noun,
        answers: null,
      ),
    );
    when(() => mockExerciseCacheService.reCacheSentenceExercisesIfNeeded())
        .thenAnswer((_) async {});
    when(() => mockExerciseCacheService.reCacheGenderExercisesIfNeeded())
        .thenAnswer((_) async {});
    when(() => mockStatisticsService.addExercisePassed(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockStatisticsService.addExerciseFailed(any(), any()))
        .thenAnswer((_) async {});

    GetIt.instance
        .registerSingleton<ExerciseCacheService>(mockExerciseCacheService);
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
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExerciseCacheService.getCachedGenderExercise throws',
        build: () => testObject,
        setUp: () {
          when(() => mockExerciseCacheService.getCachedGenderExercise())
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
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExerciseCacheService.reCacheGenderExercisesIfNeeded throws',
        build: () => testObject,
        setUp: () {
          when(() => mockExerciseCacheService.reCacheGenderExercisesIfNeeded())
              .thenThrow(Exception('something went wrong!'));
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseExerciseRetrievedState(),
          ExerciseErrorState(
              errorString: 'Unable to re-cache gender exercises'),
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
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExerciseCacheService.getCachedSentenceExercise throws',
        build: () => testObject,
        setUp: () {
          when(() => mockExerciseCacheService.getCachedSentenceExercise())
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
        'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExerciseCacheService.reCacheSentenceExercisesIfNeeded throws',
        build: () => testObject,
        setUp: () {
          when(() =>
                  mockExerciseCacheService.reCacheSentenceExercisesIfNeeded())
              .thenThrow(Exception('something went wrong!'));
        },
        act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
        expect: () => [
          ExerciseRetrievingExerciseState(),
          ExerciseExerciseRetrievedState(),
          ExerciseErrorState(
              errorString: 'Unable to re-cache sentence exercises'),
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
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExerciseCacheService.getCachedGenderExercise throws',
      build: () => testObject,
      setUp: () {
        when(() => mockExerciseCacheService.getCachedGenderExercise())
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
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExerciseCacheService.reCacheGenderExercisesIfNeeded throws',
      build: () => testObject,
      setUp: () {
        when(() => mockExerciseCacheService.reCacheGenderExercisesIfNeeded())
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomNounEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseExerciseRetrievedState(),
        ExerciseErrorState(errorString: 'Unable to re-cache gender exercises'),
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
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExerciseCacheService.getCachedSentenceExercise throws',
      build: () => testObject,
      setUp: () {
        when(() => mockExerciseCacheService.getCachedSentenceExercise())
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
      'emits ExerciseRetrievingExerciseState, ExerciseErrorState when ExerciseCacheService.reCacheSentenceExercisesIfNeeded throws',
      build: () => testObject,
      setUp: () {
        when(() => mockExerciseCacheService.reCacheSentenceExercisesIfNeeded())
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomSentenceEvent()),
      expect: () => [
        ExerciseRetrievingExerciseState(),
        ExerciseExerciseRetrievedState(),
        ExerciseErrorState(
            errorString: 'Unable to re-cache sentence exercises'),
      ],
    );
  });

  group('ExerciseSubmitAnswerEvent', () {
    final initialSentenceExercise = Exercise<WordForm, Sentence>(
      question: sentence,
      answers: null,
    );
    final initialGenderExercise = Exercise<Gender, Noun>(
      question: noun,
      answers: null,
    );
    final initialMockExercise = Exercise<_MockAnswer, _MockQuestion>(
      question: _MockQuestion(
          correctAnswer: _MockAnswer(),
          answerSynonyms: const [],
          possibleAnswers: const [],
          explanation: '',
          visualExplanation: ''),
      answers: null,
    );
    final sentenceAnswersToAdd = [WordForm.testValue()];
    blocTest(
      'emits ExerciseAnswerSelectedState, appending answers to existing Exercise, when correctAnswer is WordForm',
      build: () => testObject,
      setUp: () {
        testObject.exercise = initialSentenceExercise;
      },
      act: (bloc) =>
          bloc.add(ExerciseSubmitAnswerEvent(answers: sentenceAnswersToAdd)),
      expect: () => [
        ExerciseAnswerSelectedState(),
      ],
      tearDown: () {
        expect(
          testObject.exercise,
          Exercise<WordForm, Sentence>(
            question: initialSentenceExercise.question,
            answers: sentenceAnswersToAdd,
          ),
        );
      },
    );

    final genderAnswersToAdd = [Gender.f];
    blocTest(
      'emits ExerciseAnswerSelectedState, appending answers to existing Exercise, when correctAnswer is Gender',
      build: () => testObject,
      setUp: () {
        testObject.exercise = initialGenderExercise;
      },
      act: (bloc) =>
          bloc.add(ExerciseSubmitAnswerEvent(answers: genderAnswersToAdd)),
      expect: () => [
        ExerciseAnswerSelectedState(),
      ],
      tearDown: () {
        expect(
          testObject.exercise,
          Exercise<Gender, Noun>(
            question: initialGenderExercise.question,
            answers: genderAnswersToAdd,
          ),
        );
      },
    );

    blocTest(
      'emits ExerciseErrorState when correctAnswer is neither WordForm nor Gender',
      build: () => testObject,
      setUp: () {
        testObject.exercise = initialMockExercise;
      },
      act: (bloc) =>
          bloc.add(ExerciseSubmitAnswerEvent(answers: genderAnswersToAdd)),
      expect: () => [
        ExerciseErrorState(
            errorString: 'Unable to determine exercise answer ID.')
      ],
      tearDown: () {
        expect(
          testObject.exercise,
          initialMockExercise,
        );
      },
    );

    blocTest(
      'invokes StatisticsService.addExercisePassed when correct answer is selected',
      build: () => testObject,
      setUp: () {
        testObject.exercise = initialSentenceExercise;
      },
      act: (bloc) => bloc.add(
        ExerciseSubmitAnswerEvent(
          answers: [
            testObject.exercise!.question.correctAnswer as WordForm,
          ],
        ),
      ),
      verify: (_) {
        final correctAnswer =
            initialSentenceExercise.question.correctAnswer.type.name;

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
        testObject.exercise = initialSentenceExercise;
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
        final correctAnswer =
            initialSentenceExercise.question.correctAnswer.type.name;

        verifyNever(() =>
            mockStatisticsService.addExercisePassed(correctAnswer, any()));
        verify(() =>
                mockStatisticsService.addExerciseFailed(correctAnswer, any()))
            .called(1);
      },
    );
  });
}

class _MockQuestion extends Question<_MockAnswer> {
  const _MockQuestion(
      {required super.correctAnswer,
      required super.answerSynonyms,
      required super.possibleAnswers,
      required super.explanation,
      required super.visualExplanation});

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class _MockAnswer extends Answer.Answer {
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
