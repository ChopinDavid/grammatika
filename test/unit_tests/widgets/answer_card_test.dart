import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/extensions/gender_extension.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/widgets/answer_card.dart';

import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;

  setUp(() async {
    mockExerciseBloc = MockExerciseBloc();

    whenListen(
      mockExerciseBloc,
      Stream.fromIterable(
        <ExerciseState>[],
      ),
      initialState: ExerciseInitial(),
    );
  });

  group('color', () {
    testWidgets(
      'is green when isCorrect',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: const AnswerCard<Gender>(
                isCorrect: true,
                answers: [],
                displayString: '',
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(
            widgetTester.widget<Card>(find.byType(Card)).color, Colors.green);
      },
    );

    testWidgets(
      'is red when !isCorrect',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: const AnswerCard<Gender>(
                isCorrect: false,
                answers: [],
                displayString: '',
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widget<Card>(find.byType(Card)).color, Colors.red);
      },
    );

    testWidgets(
      'is null when isCorrect is null',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: const AnswerCard<Gender>(
                isCorrect: null,
                answers: [],
                displayString: '',
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widget<Card>(find.byType(Card)).color, null);
      },
    );
  });

  group('InkWell onTap', () {
    testWidgets(
      'does not add ExerciseSubmitAnswerEvent when ExerciseBloc state is ExerciseAnswerSelectedState',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseAnswerSelectedState(),
            ],
          ),
        );

        final answers = [Gender.m];

        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: AnswerCard<Gender>(
                isCorrect: null,
                answers: answers,
                displayString: '',
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        await widgetTester.tap(find.byType(Card));

        verifyNever(
          () => mockExerciseBloc.add(
            ExerciseSubmitAnswerEvent<Gender>(
              answers: answers,
            ),
          ),
        );
      },
    );

    testWidgets(
      'does add ExerciseSubmitAnswerEvent when ExerciseBloc state is ExerciseExerciseRetrievedState',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseExerciseRetrievedState(),
            ],
          ),
        );

        final answers = [Gender.m];

        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: AnswerCard<Gender>(
                isCorrect: null,
                answers: answers,
                displayString: '',
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        await widgetTester.tap(find.byType(Card));

        verify(
          () => mockExerciseBloc.add(
            ExerciseSubmitAnswerEvent<Gender>(
              answers: answers,
            ),
          ),
        );
      },
    );
  });

  testWidgets(
    "displays displayString",
    (widgetTester) async {
      final expected = Gender.m.displayString;

      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: AnswerCard<Gender>(
              isCorrect: null,
              answers: const [],
              displayString: expected,
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(Card));

      expect(find.text(expected), findsOneWidget);
    },
  );
}
