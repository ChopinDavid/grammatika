import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/screens/exercise_page.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';

import '../mocks.dart';

main() {
  late ExerciseBloc mockDatabaseBloc;

  setUp(() {
    mockDatabaseBloc = MockExerciseBloc();
  });

  testWidgets(
      'displays progress indicator when state is ExerciseRetrievingRandomNounState',
      (widgetTester) async {
    whenListen(
      mockDatabaseBloc,
      Stream.fromIterable(
        <ExerciseState>[
          ExerciseRetrievingRandomNounState(),
        ],
      ),
      initialState: ExerciseInitial(),
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockDatabaseBloc,
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
      mockDatabaseBloc,
      Stream.fromIterable(
        <ExerciseState>[
          ExerciseRandomNounRetrievedState(noun: Noun.testValue(), word: word),
        ],
      ),
      initialState: ExerciseInitial(),
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockDatabaseBloc,
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
        mockDatabaseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseExerciseGradedState(
              answer: Answer<Gender>.testValue(
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
          value: mockDatabaseBloc,
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
        mockDatabaseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseRandomNounRetrievedState(
              noun: Noun.testValue(),
              word: word,
            ),
          ],
        ),
        initialState: ExerciseInitial());
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockDatabaseBloc,
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
        mockDatabaseBloc,
        Stream.fromIterable(
          <ExerciseState>[
            ExerciseExerciseGradedState(
              answer: Answer<Gender>.testValue(
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
          value: mockDatabaseBloc,
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
}
