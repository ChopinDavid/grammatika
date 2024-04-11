import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/extensions/gender_extension.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/widgets/gender_card.dart';

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

  testWidgets(
    'throws when Gender.pl passed as gender',
    (widgetTester) async {
      expect(() => GenderCard(gender: Gender.pl, onTap: () {}),
          throwsAssertionError);
    },
  );

  testWidgets(
    'throws when Gender.both passed as gender',
    (widgetTester) async {
      expect(() => GenderCard(gender: Gender.both, onTap: () {}),
          throwsAssertionError);
    },
  );

  group('color', () {
    testWidgets(
      'is green when gender is both the answer and the correctAnswer',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseExerciseGradedState(
                answer: Answer<Gender>.testValue(
                  answer: Gender.m,
                  correctAnswer: Gender.m,
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
              child: GenderCard(
                gender: Gender.m,
                onTap: () {},
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
      'is green when gender is both the correctAnswer but not the answer',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseExerciseGradedState(
                answer: Answer<Gender>.testValue(
                  answer: Gender.f,
                  correctAnswer: Gender.m,
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
              child: GenderCard(
                gender: Gender.m,
                onTap: () {},
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
      'is red when gender is the answer but not the correctAnswer',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseExerciseGradedState(
                answer: Answer<Gender>.testValue(
                  answer: Gender.m,
                  correctAnswer: Gender.f,
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
              child: GenderCard(
                gender: Gender.m,
                onTap: () {},
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widget<Card>(find.byType(Card)).color, Colors.red);
      },
    );

    testWidgets(
      'has no color when the state is ExerciseInitial',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseInitial(),
            ],
          ),
          initialState: ExerciseInitial(),
        );

        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: GenderCard(
                gender: Gender.m,
                onTap: () {},
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widget<Card>(find.byType(Card)).color, null);
      },
    );

    testWidgets(
      'has no color when the state is ExerciseRandomNounRetrievedState',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseRandomNounRetrievedState(
                  noun: Noun.testValue(), word: Word.testValue()),
            ],
          ),
          initialState: ExerciseInitial(),
        );

        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: GenderCard(
                gender: Gender.m,
                onTap: () {},
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widget<Card>(find.byType(Card)).color, null);
      },
    );

    testWidgets(
      'has no color when the state is ExerciseRetrievingRandomNounState',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseRetrievingRandomNounState(),
            ],
          ),
          initialState: ExerciseInitial(),
        );

        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: GenderCard(
                gender: Gender.m,
                onTap: () {},
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widget<Card>(find.byType(Card)).color, null);
      },
    );

    testWidgets(
      'has no color when the state is ExerciseErrorState',
      (widgetTester) async {
        whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            [
              ExerciseErrorState(errorString: 'some error'),
            ],
          ),
          initialState: ExerciseInitial(),
        );

        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: mockExerciseBloc,
              child: GenderCard(
                gender: Gender.m,
                onTap: () {},
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widget<Card>(find.byType(Card)).color, null);
      },
    );
  });

  testWidgets(
    'invokes onTap when tapped',
    (widgetTester) async {
      int onTapCalledCount = 0;

      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: GenderCard(
              gender: Gender.m,
              onTap: () {
                onTapCalledCount++;
              },
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(Card));

      expect(onTapCalledCount, 1);
    },
  );

  testWidgets(
    "displays gender's displayString",
    (widgetTester) async {
      final expected = Gender.m.displayString;

      await widgetTester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ExerciseBloc>.value(
            value: mockExerciseBloc,
            child: GenderCard(
              gender: Gender.m,
              onTap: () {},
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(Card));

      expect(find.text(expected!), findsOneWidget);
    },
  );
}
