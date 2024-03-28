import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/database_bloc.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/screens/exercise_page.dart';

import '../mocks.dart';

main() {
  late DatabaseBloc mockDatabaseBloc;

  setUp(() {
    mockDatabaseBloc = MockDatabaseBloc();
  });

  testWidgets(
      'displays progress indicator when state is DatabaseRetrievingRandomNounState',
      (widgetTester) async {
    whenListen(
        mockDatabaseBloc,
        Stream.fromIterable(
            <DatabaseState>[DatabaseRetrievingRandomNounState()]),
        initialState: DatabaseInitial());
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DatabaseBloc>.value(
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
      'displays correct text when state is DatabaseRandomNounRetrievedState',
      (widgetTester) async {
    final word = Word.testValue(bare: 'друг');
    whenListen(
        mockDatabaseBloc,
        Stream.fromIterable(<DatabaseState>[
          DatabaseRandomNounRetrievedState(noun: Noun.testValue(), word: word)
        ]),
        initialState: DatabaseInitial());
    await widgetTester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DatabaseBloc>.value(
          value: mockDatabaseBloc,
          child: const ExercisePage(),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(find.text('What is the gender of: «${word.bare}»?'), findsOneWidget);
  });
}
