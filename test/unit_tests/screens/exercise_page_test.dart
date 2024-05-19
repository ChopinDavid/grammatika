import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/screens/exercise_page.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';

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

  testWidgets(
      'displays correct text when state is ExerciseRandomNounRetrievedState',
      (widgetTester) async {
    final word = Word.testValue(bare: 'друг');
    whenListen(
      mockExerciseBloc,
      Stream.fromIterable(
        <ExerciseState>[
          ExerciseExerciseRetrievedState(noun: Noun.testValue(), word: word),
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

    expect(find.text('What is the gender of the word...'), findsOneWidget);
    expect(find.text('${word.bare}?'), findsOneWidget);
  });

  testWidgets('displays correct text when state is ExerciseExerciseGradedState',
      (widgetTester) async {
    final word = Word.testValue(bare: 'друг');
    whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseAnswerSelectedState(
              answer: Exercise<Gender>.testValue(
                answer: Gender.m,
                word: word,
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

    expect(find.text('What is the gender of the word...'), findsOneWidget);
    expect(find.text('${word.bare}?'), findsOneWidget);
  });

  testWidgets(
      'creates GenderExerciseWidget passing state.word when state is ExerciseRandomNounRetrievedState',
      (widgetTester) async {
    final word = Word.testValue(bare: 'друг');
    whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseExerciseRetrievedState(
              noun: Noun.testValue(),
              word: word,
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

    expect(
        widgetTester
            .widget<GenderExerciseWidget>(find.byType(GenderExerciseWidget))
            .word,
        word);
  });

  testWidgets(
      'creates GenderExerciseWidget passing state.answer.word when state is ExerciseExerciseGradedState',
      (widgetTester) async {
    final word = Word.testValue(bare: 'друг');
    whenListen(
        mockExerciseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseAnswerSelectedState(
              answer: Exercise<Gender>.testValue(
                answer: Gender.m,
                word: word,
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

    expect(
        widgetTester
            .widget<GenderExerciseWidget>(find.byType(GenderExerciseWidget))
            .word,
        word);
  });

  group('"Next" button', () {
    testWidgets('displays when state is ExerciseExerciseGradedState',
        (widgetTester) async {
      whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            <ExerciseState>[
              ExerciseAnswerSelectedState(
                answer: Exercise<Gender>.testValue(
                  answer: Gender.m,
                  word: Word.testValue(),
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
      whenListen(
          mockExerciseBloc,
          Stream.fromIterable(
            <ExerciseState>[
              ExerciseAnswerSelectedState(
                answer: Exercise<Gender>.testValue(
                  answer: Gender.m,
                  word: Word.testValue(),
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
