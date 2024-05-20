import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/screens/exercise_page.dart';
import 'package:uchu/widgets/exercise_footer.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';
import 'package:uchu/widgets/sentence_exercise_widget.dart';

import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;

  setUp(() {
    mockExerciseBloc = MockExerciseBloc();
  });

  testWidgets(
      'displays progress indicator when state is ExerciseRetrievingRandomNounState',
      (widgetTester) async {
    whenListen(
      mockExerciseBloc,
      Stream.fromIterable(
        <ExerciseState>[
          ExerciseRetrievingExerciseState(),
        ],
      ),
      initialState: ExerciseInitial(),
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockExerciseBloc,
          child: const ExercisePage(),
        ),
      ),
    );

    await widgetTester.pump();
    await widgetTester.idle();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  group('when state is ExerciseExerciseRetrievedState', () {
    testWidgets(
        "displays GenderExerciseWidget when state's exercise is of type Exercise<Gender, Noun>",
        (widgetTester) async {
      final exercise = Exercise<Gender, Noun>(
        question: Noun.testValue(),
        answer: null,
      );
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseExerciseRetrievedState(
              exercise: exercise,
            ),
          ],
        ),
        initialState: ExerciseInitial(),
      );
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final genderExerciseWidgetFinder = find.byType(GenderExerciseWidget);
      expect(genderExerciseWidgetFinder, findsOneWidget);
      expect(
          widgetTester
              .widget<GenderExerciseWidget>(genderExerciseWidgetFinder)
              .exercise,
          exercise);
      expect(find.byType(SentenceExerciseWidget), findsNothing);
      expect(find.byType(ExerciseFooter), findsNothing);
    });

    testWidgets(
        "displays SentenceExerciseWidget when state's exercise is of type Exercise<WordForm, Sentence>",
        (widgetTester) async {
      final exercise = Exercise<WordForm, Sentence>(
        question: Sentence.testValue(),
        answer: null,
      );
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseExerciseRetrievedState(
              exercise: exercise,
            ),
          ],
        ),
        initialState: ExerciseInitial(),
      );
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final sentenceExerciseWidgetFinder = find.byType(SentenceExerciseWidget);
      expect(sentenceExerciseWidgetFinder, findsOneWidget);
      expect(
          widgetTester
              .widget<SentenceExerciseWidget>(sentenceExerciseWidgetFinder)
              .exercise,
          exercise);
      expect(find.byType(GenderExerciseWidget), findsNothing);
      expect(find.byType(ExerciseFooter), findsNothing);
    });
  });

  group('when state is ExerciseAnswerSelectedState', () {
    testWidgets(
        "displays GenderExerciseWidget when state's exercise is of type Exercise<Gender, Noun>",
        (widgetTester) async {
      final noun = Noun.testValue();
      final exercise = Exercise<Gender, Noun>(
        question: noun,
        answer: noun.correctAnswer,
      );
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseExerciseRetrievedState(
              exercise: exercise,
            ),
          ],
        ),
        initialState: ExerciseInitial(),
      );
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final genderExerciseWidgetFinder = find.byType(GenderExerciseWidget);
      expect(genderExerciseWidgetFinder, findsOneWidget);
      expect(
          widgetTester
              .widget<GenderExerciseWidget>(genderExerciseWidgetFinder)
              .exercise,
          exercise);
      expect(find.byType(SentenceExerciseWidget), findsNothing);
    });

    testWidgets(
        "displays SentenceExerciseWidget when state's exercise is of type Exercise<WordForm, Sentence>",
        (widgetTester) async {
      final sentence = Sentence.testValue();
      final exercise = Exercise<WordForm, Sentence>(
        question: sentence,
        answer: sentence.correctAnswer,
      );
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseAnswerSelectedState(
              exercise: exercise,
            ),
          ],
        ),
        initialState: ExerciseInitial(),
      );
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final sentenceExerciseWidgetFinder = find.byType(SentenceExerciseWidget);
      expect(sentenceExerciseWidgetFinder, findsOneWidget);
      expect(
          widgetTester
              .widget<SentenceExerciseWidget>(sentenceExerciseWidgetFinder)
              .exercise,
          exercise);
      expect(find.byType(GenderExerciseWidget), findsNothing);
    });

    testWidgets("displays ExerciseFooter with correct explanation",
        (widgetTester) async {
      final noun = Noun.testValue();
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseAnswerSelectedState(
              exercise: Exercise<Gender, Noun>(
                question: noun,
                answer: noun.correctAnswer,
              ),
            ),
          ],
        ),
        initialState: ExerciseInitial(),
      );
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final exerciseFooterFinder = find.byType(ExerciseFooter);
      expect(exerciseFooterFinder, findsOneWidget);
      expect(
          widgetTester.widget<ExerciseFooter>(exerciseFooterFinder).explanation,
          noun.explanation);
    });
  });

  group('"Next" button', () {
    testWidgets('displays when state is ExerciseExerciseGradedState',
        (widgetTester) async {
      final noun = Noun.testValue();
      whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            <ExerciseState>[
              ExerciseAnswerSelectedState(
                exercise: Exercise<Gender, Noun>(
                  question: noun,
                  answer: noun.correctAnswer,
                ),
              ),
            ],
          ),
          initialState: ExerciseInitial());
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final textButtonFinder = find.byType(TextButton);
      expect(textButtonFinder, findsOneWidget);
      expect(
          (widgetTester.widget<TextButton>(textButtonFinder).child as Text)
              .data,
          "Next");
    });

    testWidgets(
        'does not display when state is not ExerciseExerciseGradedState',
        (widgetTester) async {
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseRetrievingExerciseState(),
          ],
        ),
        initialState: ExerciseInitial(),
      );
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );
      await widgetTester.pump();
      await widgetTester.idle();

      final textButtonFinder = find.byType(TextButton);
      expect(textButtonFinder, findsNothing);
    });

    testWidgets(
        'adds ExerciseRetrieveExerciseEvent to ExerciseBloc when tapped',
        (widgetTester) async {
      final noun = Noun.testValue();
      whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            <ExerciseState>[
              ExerciseAnswerSelectedState(
                exercise: Exercise<Gender, Noun>(
                  question: noun,
                  answer: noun.correctAnswer,
                ),
              ),
            ],
          ),
          initialState: ExerciseInitial());
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(TextButton));
      mocktail
          .verify(() => mockExerciseBloc.add(ExerciseRetrieveExerciseEvent()));
    });
  });
}
