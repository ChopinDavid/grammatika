import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/blocs/exercise/exercise_bloc.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/screens/exercise_page.dart';
import 'package:grammatika/widgets/explanations_widget.dart';
import 'package:grammatika/widgets/gender_exercise_widget.dart';
import 'package:grammatika/widgets/grammatika_drawer.dart';
import 'package:grammatika/widgets/sentence_exercise_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;

  setUp(() {
    mockExerciseBloc = MockExerciseBloc();
  });

  group(
    'when state is ExerciseRetrievingExerciseState',
    () {
      testWidgets(
        'shows CircularProgressIndicator',
        (widgetTester) async {
          whenListen(
            mockExerciseBloc,
            Stream.fromIterable(
              [
                ExerciseRetrievingExerciseState(),
              ],
            ),
            initialState: ExerciseInitial(),
          );

          await widgetTester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: mockExerciseBloc,
                child: const ExercisePage(),
              ),
            ),
          );
          await widgetTester.pump();
          await widgetTester.idle();

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );
    },
  );

  group('when state is ExerciseExerciseRetrievedState', () {
    testWidgets(
        "displays GenderExerciseWidget when bloc's exercise's type is .determineNounGender",
        (widgetTester) async {
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          [
            ExerciseExerciseRetrievedState(),
          ],
        ),
        initialState: ExerciseInitial(),
      );

      final noun = Noun.testValue();
      final exercise = Exercise<Gender, Noun>.testValue(
          question: noun, answers: [noun.correctAnswer]);
      when(() => mockExerciseBloc.exercise).thenReturn(exercise);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );
      await widgetTester.pump();
      await widgetTester.idle();

      final genderExerciseWidgetFinder = find.byType(GenderExerciseWidget);
      expect(genderExerciseWidgetFinder, findsOneWidget);
      expect(
          widgetTester
              .widget<GenderExerciseWidget>(genderExerciseWidgetFinder)
              .exercise,
          exercise);
    });

    testWidgets(
        "displays SentenceExerciseWidget when bloc's exercise's type is .determineWordForm",
        (widgetTester) async {
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          [
            ExerciseExerciseRetrievedState(),
          ],
        ),
        initialState: ExerciseInitial(),
      );

      final sentence = Sentence.testValue();
      final exercise = Exercise<WordForm, Sentence>.testValue(
          question: sentence,
          answers: [sentence.correctAnswer, ...sentence.answerSynonyms]);
      when(() => mockExerciseBloc.exercise).thenReturn(exercise);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );
      await widgetTester.pump();
      await widgetTester.idle();

      final sentenceExerciseWidgetFinder = find.byType(SentenceExerciseWidget);
      expect(sentenceExerciseWidgetFinder, findsOneWidget);
      expect(
          widgetTester
              .widget<SentenceExerciseWidget>(sentenceExerciseWidgetFinder)
              .exercise,
          exercise);
    });
  });

  group('when state is ExerciseAnswerSelectedState', () {
    testWidgets('displays ExerciseFooter', (widgetTester) async {
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          [
            ExerciseAnswerSelectedState(),
          ],
        ),
        initialState: ExerciseInitial(),
      );

      const explanation = 'because I said so';
      final sentence = Sentence.testValue(explanation: explanation);
      final exercise = Exercise<WordForm, Sentence>.testValue(
          question: sentence,
          answers: [sentence.correctAnswer, ...sentence.answerSynonyms]);
      when(() => mockExerciseBloc.exercise).thenReturn(exercise);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );
      await widgetTester.pump();
      await widgetTester.idle();

      final exerciseFooterFinder = find.byType(ExplanationsWidget);
      expect(exerciseFooterFinder, findsOneWidget);
      expect(
          widgetTester
              .widget<ExplanationsWidget>(exerciseFooterFinder)
              .explanation,
          explanation);
    });

    testWidgets(
        'tapping "Next" button adds ExerciseRetrieveExerciseEvent to ExerciseBloc',
        (widgetTester) async {
      whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          [
            ExerciseAnswerSelectedState(),
          ],
        ),
        initialState: ExerciseInitial(),
      );
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockExerciseBloc,
            child: const ExercisePage(),
          ),
        ),
      );
      await widgetTester.pump();
      await widgetTester.idle();

      final nextFinder = find.text('Next');
      expect(nextFinder, findsOneWidget);
      await widgetTester.tap(nextFinder);

      verify(() => mockExerciseBloc.add(ExerciseRetrieveExerciseEvent()));
    });
  });

  group('when state is ExerciseErrorState', () {
    testWidgets(
      'shows error SnackBar',
      (widgetTester) async {
        const expectedErrorString = 'something went wrong!';
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            <ExerciseState>[
              ExerciseErrorState(errorString: expectedErrorString)
            ],
          ),
          initialState: ExerciseExerciseRetrievedState(),
        );

        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: mockExerciseBloc,
              child: const ExercisePage(),
            ),
          ),
        );
        await widgetTester.pump();
        await widgetTester.idle();

        final snackBarFinder = find.byType(SnackBar);
        expect(snackBarFinder, findsOneWidget);
        expect(
          (widgetTester.widget<SnackBar>(snackBarFinder).content as Text).data,
          'There was an error fetching exercise: $expectedErrorString',
        );
      },
    );
  });

  group(
    'drawer',
    () {
      testWidgets(
        'is shown when menu icon is tapped',
        (widgetTester) async {
          whenListen(
            mockExerciseBloc,
            Stream.fromIterable(
              <ExerciseState>[],
            ),
            initialState: ExerciseExerciseRetrievedState(),
          );

          await widgetTester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: mockExerciseBloc,
                child: const ExercisePage(),
              ),
            ),
          );
          await widgetTester.pump();
          await widgetTester.idle();

          expect(find.byType(GrammatikaDrawer), findsNothing);

          final menuIconFinder = find.byIcon(Icons.menu);
          expect(menuIconFinder, findsOneWidget);
          await widgetTester.tap(menuIconFinder);
          await widgetTester.pump();
          await widgetTester.idle();

          expect(find.byType(GrammatikaDrawer), findsOneWidget);
        },
      );
    },
  );
}
