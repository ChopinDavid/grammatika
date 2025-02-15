import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/blocs/exercise/exercise_bloc.dart';
import 'package:uchu/widgets/explanations_widget.dart';

import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;

  setUpAll(() {
    mockExerciseBloc = MockExerciseBloc();
    whenListen(mockExerciseBloc, Stream.fromIterable(<ExerciseState>[]),
        initialState: ExerciseInitial());
  });
  testWidgets('does not display explanation if null', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: ExplanationsWidget(
      explanation: null,
      visualExplanation: null,
    )));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('explanation-text')), findsNothing);
  });
  testWidgets('does not display visual explanation if null',
      (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: ExplanationsWidget(
      explanation: null,
      visualExplanation: null,
    )));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('visual-explanation-text')), findsNothing);
  });
  testWidgets('displays explanation if not null', (widgetTester) async {
    const explanation = 'some explanation';
    await widgetTester.pumpWidget(const MaterialApp(
        home: ExplanationsWidget(
      explanation: explanation,
      visualExplanation: null,
    )));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('explanation-text')), findsOneWidget);
    expect(find.text(explanation), findsOneWidget);
  });

  testWidgets('displays visual explanation if not null', (widgetTester) async {
    const visualExplanation = 'wordRoot- ➡️ word';
    await widgetTester.pumpWidget(const MaterialApp(
        home: ExplanationsWidget(
      explanation: null,
      visualExplanation: visualExplanation,
    )));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('visual-explanation-text')), findsOneWidget);
    expect(find.text(visualExplanation), findsOneWidget);
  });
}
