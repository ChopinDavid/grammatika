import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/utilities/exercise_helper.dart';
import 'package:uchu/widgets/answer_card.dart';
import 'package:uchu/widgets/sentence_exercise_widget.dart';

import '../../test_utils.dart';
import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;
  late ExerciseHelper mockExerciseHelper;

  setUpAll(TestUtils.registerFallbackValues);

  setUp(
    () {
      mockExerciseBloc = MockExerciseBloc();

      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(<ExerciseState>[]),
        initialState: ExerciseInitial(),
      );

      mockExerciseHelper = MockExerciseHelper();
    },
  );

  testWidgets(
    'apostrophes are removed from sentences',
    (widgetTester) async {
      const sentence = "Что ты де'лаешь?";
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: Scaffold(
              body: SentenceExerciseWidget(
                exercise: Exercise.testValue(
                  question: Sentence.testValue(ru: sentence),
                  answers: [],
                ),
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(
          find.textContaining('делаешь?', findRichText: true), findsOneWidget);
      expect(
          find.textContaining("де'лаешь?", findRichText: true), findsNothing);
    },
  );

  testWidgets(
    'sentence segments are interpolated into RichText correctly',
    (widgetTester) async {
      const sentence = "Что ты де'лаешь?";
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: Scaffold(
              body: SentenceExerciseWidget(
                exercise: Exercise.testValue(
                  question: Sentence.testValue(ru: sentence),
                  answers: [],
                ),
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final RichText sentenceRichText = widgetTester
          .widget<RichText>(find.byKey(const Key('sentence-rich-text')));
      expect(
          ((sentenceRichText.text as TextSpan).children![0] as TextSpan).text,
          '«');
      expect(
          ((sentenceRichText.text as TextSpan).children![1] as TextSpan).text,
          'Что');
      expect(
          ((sentenceRichText.text as TextSpan).children![2] as TextSpan).text,
          '  ');
      expect(
          ((sentenceRichText.text as TextSpan).children![3] as TextSpan).text,
          'ты');
      expect(
          ((sentenceRichText.text as TextSpan).children![4] as TextSpan).text,
          '  ');
      expect(
          ((sentenceRichText.text as TextSpan).children![5] as TextSpan).text,
          'делаешь?');
      expect(
          ((sentenceRichText.text as TextSpan).children![6] as TextSpan).text,
          '»');
    },
  );

  testWidgets(
    'sentence word that matches the bare of the possible answer that is the correct type is replaced by placeholder text',
    (widgetTester) async {
      const sentence = "Что ты де'лаешь?";
      final Map<WordFormType, String> wordFormTypeToFormMap = {
        WordFormType.ruVerbGerundPresent: "де'лая",
        WordFormType.ruVerbGerundPast: "делав",
        WordFormType.ruVerbPresfutSg2: "де'лаешь"
      };
      final possibleAnswers = wordFormTypeToFormMap.entries
          .map(
            (entry) => WordForm.fromJson(
              {
                'form_type': entry.key.name,
                'word_form_position': 1,
                'form': entry.value,
                '_form_bare': entry.value.replaceAll("'", ''),
              },
            ),
          )
          .toList();
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: Scaffold(
              body: SentenceExerciseWidget(
                exercise: Exercise.testValue(
                  question: Sentence.testValue(
                    ru: sentence,
                    possibleAnswers: possibleAnswers,
                    formType: WordFormType.ruVerbPresfutSg2,
                  ),
                  answers: [],
                ),
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(find.textContaining('делаешь?', findRichText: true), findsNothing);
      expect(
          find.textContaining(sentenceWordPlaceholderText, findRichText: true),
          findsOneWidget);
    },
  );

  testWidgets(
    'One AnswerCard is returned for each answer group returned from ExerciseHelper',
    (widgetTester) async {
      final answerGroups = {
        'a': [WordForm.testValue()],
        'b': [WordForm.testValue()],
        'c': [WordForm.testValue()],
      };
      when(
        () => mockExerciseHelper.getAnswerGroupsForSentenceExercise(
          sentenceExercise: any(
            named: 'sentenceExercise',
          ),
        ),
      ).thenReturn(answerGroups);
      when(
        () => mockExerciseHelper.getTextSpansFromSentence(
          sentenceExercise: any(named: 'sentenceExercise'),
          defaultTextStyle: any(named: 'defaultTextStyle'),
        ),
      ).thenReturn([]);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: Scaffold(
              body: SentenceExerciseWidget(
                exerciseHelper: mockExerciseHelper,
                exercise: Exercise.testValue(
                  question: Sentence.testValue(),
                  answers: [],
                ),
              ),
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();
      expect(
        find.byType(AnswerCard<WordForm>),
        findsNWidgets(
          answerGroups.length,
        ),
      );
    },
  );
}
