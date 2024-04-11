import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/widgets/gender_card.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';

import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;
  final word = Word.testValue();

  setUp(() async {
    mockExerciseBloc = MockExerciseBloc();

    whenListen(
      mockExerciseBloc,
      Stream.fromIterable(
        [
          ExerciseRetrievingRandomNounState(),
          ExerciseRandomNounRetrievedState(
              noun: Noun.testValue(), word: Word.testValue()),
        ],
      ),
      initialState: ExerciseInitial(),
    );
  });

  testWidgets("displays state's word.bare", (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockExerciseBloc,
          child: GenderExerciseWidget(
            word: word,
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(
        widgetTester
            .widget<Text>(
              find.byKey(
                const Key(
                  'bare-key',
                ),
              ),
            )
            .data,
        '${word.bare}?');
  });

  testWidgets("shows three GenderCards", (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockExerciseBloc,
          child: GenderExerciseWidget(
            word: word,
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    final genderCardFinder = find.byType(GenderCard);
    expect(genderCardFinder, findsNWidgets(3));
    expect(
      widgetTester.widget<GenderCard>(genderCardFinder.at(0)).gender,
      Gender.m,
    );
    expect(
      widgetTester.widget<GenderCard>(genderCardFinder.at(1)).gender,
      Gender.f,
    );
    expect(
      widgetTester.widget<GenderCard>(genderCardFinder.at(2)).gender,
      Gender.n,
    );
  });

  testWidgets(
      "tapping the first GenderCard adds ExerciseSubmitAnswerEvent with an answer of Gender.m to the ExerciseBloc",
      (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockExerciseBloc,
          child: GenderExerciseWidget(
            word: word,
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byType(GenderCard).at(0));

    mocktail.verify(
      () => mockExerciseBloc.add(
        ExerciseSubmitAnswerEvent(
          answer: Answer<Gender>.initial(
            answer: Gender.m,
            word: word,
          ),
        ),
      ),
    );
  });

  testWidgets(
      "tapping the second GenderCard adds ExerciseSubmitAnswerEvent with an answer of Gender.f to the ExerciseBloc",
      (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockExerciseBloc,
          child: GenderExerciseWidget(
            word: word,
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byType(GenderCard).at(1));

    mocktail.verify(
      () => mockExerciseBloc.add(
        ExerciseSubmitAnswerEvent(
          answer: Answer<Gender>.initial(
            answer: Gender.f,
            word: word,
          ),
        ),
      ),
    );
  });

  testWidgets(
      "tapping the third GenderCard adds ExerciseSubmitAnswerEvent with an answer of Gender.n to the ExerciseBloc",
      (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockExerciseBloc,
          child: GenderExerciseWidget(
            word: word,
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byType(GenderCard).at(2));

    mocktail.verify(
      () => mockExerciseBloc.add(
        ExerciseSubmitAnswerEvent(
          answer: Answer<Gender>.initial(
            answer: Gender.n,
            word: word,
          ),
        ),
      ),
    );
  });
}
