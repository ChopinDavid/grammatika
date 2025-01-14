import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/blocs/exercise/exercise_bloc.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/screens/exercise_page.dart';
import 'package:uchu/widgets/exercise_footer.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';
import 'package:uchu/widgets/sentence_exercise_widget.dart';
import 'package:uchu/widgets/uchu_drawer.dart';

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

      final exerciseFooterFinder = find.byType(ExerciseFooter);
      expect(exerciseFooterFinder, findsOneWidget);
      expect(
          widgetTester.widget<ExerciseFooter>(exerciseFooterFinder).explanation,
          explanation);
    });
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

          expect(find.byType(UchuDrawer), findsNothing);

          final menuIconFinder = find.byIcon(Icons.menu);
          expect(menuIconFinder, findsOneWidget);
          await widgetTester.tap(menuIconFinder);
          await widgetTester.pump();
          await widgetTester.idle();

          expect(find.byType(UchuDrawer), findsOneWidget);
        },
      );
    },
  );
}
