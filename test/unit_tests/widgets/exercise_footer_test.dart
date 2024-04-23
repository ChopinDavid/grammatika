import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/widgets/exercise_footer.dart';

import '../mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;

  setUpAll(() {
    mockExerciseBloc = MockExerciseBloc();
    whenListen(mockExerciseBloc, Stream.fromIterable(<ExerciseState>[]),
        initialState: ExerciseInitial());
  });
  testWidgets('does not display explanation if not', (widgetTester) async {
    await widgetTester
        .pumpWidget(const MaterialApp(home: ExerciseFooter(explanation: null)));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('explanation-text')), findsNothing);
  });
  testWidgets('displays explanation if not null', (widgetTester) async {
    const explanation = 'some explanation';
    await widgetTester.pumpWidget(
        const MaterialApp(home: ExerciseFooter(explanation: explanation)));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('explanation-text')), findsOneWidget);
    expect(find.text(explanation), findsOneWidget);
  });

  testWidgets(
      'tapping "Next" button adds ExerciseRetrieveExerciseEvent to ExercisBloc',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ExerciseBloc>.value(
          value: mockExerciseBloc,
          child: const ExerciseFooter(explanation: null),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();

    final nextFinder = find.text('Next');
    expect(nextFinder, findsOneWidget);
    await widgetTester.tap(nextFinder);

    verify(() => mockExerciseBloc.add(ExerciseRetrieveExerciseEvent()));
  });
}
