import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/widgets/answer_card.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';

import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;

  setUp(() {
    mockExerciseBloc = MockExerciseBloc();
    whenListen(
      mockExerciseBloc,
      Stream.fromIterable([ExerciseExerciseRetrievedState()]),
      initialState: ExerciseInitial(),
    );
  });

  testWidgets(
    'bare word is displayed',
    (widgetTester) async {
      const bare = 'телефон';
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: GenderExerciseWidget(
              exercise: Exercise<Gender, Noun>.testValue(
                question: Noun.testValue(bare: bare),
                answers: const [],
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(widgetTester.widget<Text>(find.byKey(const Key('bare-key'))).data,
          '$bare?');
    },
  );

  group('isCorrect', () {
    testWidgets('isNull when answers is null', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: GenderExerciseWidget(
              exercise: Exercise<Gender, Noun>.testValueSimple(
                question: Noun.testValue(),
                answers: null,
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final answerCardFinder = find.byType(AnswerCard<Gender>);
      expect(answerCardFinder, findsNWidgets(3));
      widgetTester
          .widgetList<AnswerCard<Gender>>(answerCardFinder)
          .forEach((element) {
        expect(element.isCorrect, isNull);
      });
    });

    testWidgets('isNull when answers is empty', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: GenderExerciseWidget(
              exercise: Exercise<Gender, Noun>.testValue(
                question: Noun.testValue(),
                answers: const [],
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final answerCardFinder = find.byType(AnswerCard<Gender>);
      expect(answerCardFinder, findsNWidgets(3));
      widgetTester
          .widgetList<AnswerCard<Gender>>(answerCardFinder)
          .forEach((element) {
        expect(element.isCorrect, isNull);
      });
    });

    testWidgets(
        "isTrue when answers is not empty and answer is exercise's correctAnswer",
        (widgetTester) async {
      const correctAnswer = Gender.m;
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: GenderExerciseWidget(
              exercise: Exercise<Gender, Noun>.testValue(
                question: Noun.testValue(gender: Gender.m),
                answers: const [correctAnswer],
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final answerCardFinder = find.byType(AnswerCard<Gender>);
      expect(answerCardFinder, findsNWidgets(3));
      final foundAnswerCards =
          widgetTester.widgetList<AnswerCard<Gender>>(answerCardFinder);
      expect(
          foundAnswerCards
              .where((element) => element.answers.contains(correctAnswer))
              .single
              .isCorrect,
          isTrue);

      foundAnswerCards
          .where((element) => !element.answers.contains(correctAnswer))
          .forEach((element) {
        expect(element.isCorrect, isNull);
      });
    });

    testWidgets(
        "isFalse when answers is not empty and answer is not exercise's correctAnswer",
        (widgetTester) async {
      const correctAnswer = Gender.m;
      const givenAnswer = Gender.f;
      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: GenderExerciseWidget(
              exercise: Exercise<Gender, Noun>.testValue(
                question: Noun.testValue(gender: correctAnswer),
                answers: const [givenAnswer],
              ),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      final answerCardFinder = find.byType(AnswerCard<Gender>);
      expect(answerCardFinder, findsNWidgets(3));
      final foundAnswerCards =
          widgetTester.widgetList<AnswerCard<Gender>>(answerCardFinder);
      expect(
          foundAnswerCards
              .where((element) => element.answers.contains(givenAnswer))
              .single
              .isCorrect,
          isFalse);
    });
  });
}
