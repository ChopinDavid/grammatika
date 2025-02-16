import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/blocs/exercise/exercise_bloc.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/utilities/exercise_helper.dart';
import 'package:uchu/utilities/url_helper.dart';
import 'package:uchu/widgets/answer_card.dart';
import 'package:uchu/widgets/sentence_exercise_widget.dart';
import 'package:uchu/widgets/translation_button.dart';

import '../../test_utils.dart';
import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;
  late ExerciseHelper mockExerciseHelper;
  late UrlHelper mockUrlHelper;

  setUpAll(TestUtils.registerFallbackValues);

  setUp(
    () async {
      await GetIt.instance.reset();

      mockExerciseBloc = MockExerciseBloc();

      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(<ExerciseState>[]),
        initialState: ExerciseInitial(),
      );

      mockExerciseHelper = MockExerciseHelper();

      mockUrlHelper = MockUrlHelper();
      when(() => mockUrlHelper.launchWiktionaryPageFor(any())).thenAnswer(
        (invocation) async => true,
      );
      GetIt.instance.registerSingleton<UrlHelper>(mockUrlHelper);
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
                  answers: const [],
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
      const sentenceText = "Что ты де'лаешь?";
      final sentence = Sentence.testValue(ru: sentenceText);
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: Scaffold(
              body: SentenceExerciseWidget(
                exercise: Exercise.testValue(
                  question: sentence,
                  answers: const [],
                ),
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final RichText sentenceRichText = widgetTester
          .widget<RichText>(find.byKey(const Key('sentence-rich-text')));
      final firstWordRowChildren =
          (((sentenceRichText.text as TextSpan).children![0] as WidgetSpan)
                  .child as Row)
              .children;
      expect((firstWordRowChildren.first as Text).data, '«');
      expect(
          ((firstWordRowChildren.last as InkWell).child as Text).data, 'Что');
      expect(
          ((sentenceRichText.text as TextSpan).children![1] as TextSpan).text,
          '  ');
      expect(
          (((((sentenceRichText.text as TextSpan).children![2] as WidgetSpan)
                          .child as Row)
                      .children
                      .single as InkWell)
                  .child as Text)
              .data,
          'ты');
      expect(
          ((sentenceRichText.text as TextSpan).children![3] as TextSpan).text,
          '  ');
      final lastWordRowChildren =
          (((sentenceRichText.text as TextSpan).children![4] as WidgetSpan)
                  .child as Row)
              .children;
      expect(((lastWordRowChildren.first as InkWell).child as Text).data,
          'делаешь?');
      expect((lastWordRowChildren[1] as Text).data, '»');
      expect((lastWordRowChildren[2] as TranslationButton).tatoebaKey,
          sentence.tatoebaKey);
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
                  answers: const [],
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
        () => mockExerciseHelper.getSpansFromSentence(
          any(),
          sentenceExercise: any(named: 'sentenceExercise'),
          defaultTextStyle: any(named: 'defaultTextStyle'),
          tatoebaKey: any(named: 'tatoebaKey'),
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
                  answers: const [],
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

  testWidgets(
    "UrlHelper.launchWiktionaryPageFor is invoked when question's word is tapped",
    (widgetTester) async {
      const bare = 'яблоко';
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: Scaffold(
              body: SentenceExerciseWidget(
                exercise: Exercise<WordForm, Sentence>(
                  question: Sentence.testValue(bare: bare),
                  answers: const [],
                ),
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.text(bare, findRichText: true));
      await widgetTester.pumpAndSettle();
    },
  );
}
