import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';

import 'mocks.dart';

main() {
  late ExerciseBloc testObject;
  late DbHelper mockDbHelper;
  late Database mockDatabase;
  final Noun noun = Noun.testValue();
  final Word word = Word.testValue();

  setUp(() async {
    await GetIt.instance.reset();
    mockDatabase = MockDatabase();
    mockDbHelper = MockDbHelper();
    when(() => mockDbHelper.getDatabase())
        .thenAnswer((invocation) async => mockDatabase);
    when(() => mockDatabase.rawQuery(
            'SELECT * FROM nouns WHERE gender IS NOT NULL ORDER BY RANDOM() LIMIT 1;'))
        .thenAnswer((invocation) async => [noun.toJson()]);
    when(() => mockDatabase
            .rawQuery('SELECT * FROM words WHERE id = ${noun.wordId}'))
        .thenAnswer((invocation) async => [word.toJson()]);
    GetIt.instance.registerSingleton<DbHelper>(mockDbHelper);
    testObject = ExerciseBloc();
  });

  group('ExerciseRetrieveExerciseEvent', () {
    blocTest(
      'emits ExerciseRetrievingRandomNounState, ExerciseRandomNounRetrievedState when db query succeeds',
      build: () => testObject,
      act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
      expect: () => [
        ExerciseRetrievingRandomNounState(),
        ExerciseRandomNounRetrievedState(noun: noun, word: word),
      ],
    );

    blocTest(
      'emits ExerciseRetrievingRandomNounState, ExerciseErrorState when DbHelper.getDatabase throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDbHelper.getDatabase())
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
      expect: () => [
        ExerciseRetrievingRandomNounState(),
        ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
    );

    blocTest(
      'emits ExerciseRetrievingRandomNounState, ExerciseErrorState when Database.rawQuery throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDatabase.rawQuery(any()))
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveExerciseEvent()),
      expect: () => [
        ExerciseRetrievingRandomNounState(),
        ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
    );
  });

  group('ExerciseRetrieveRandomNounEvent', () {
    blocTest(
      'emits ExerciseRetrievingRandomNounState, ExerciseRandomNounRetrievedState when db query succeeds',
      build: () => testObject,
      act: (bloc) => bloc.add(ExerciseRetrieveRandomNounEvent()),
      expect: () => [
        ExerciseRetrievingRandomNounState(),
        ExerciseRandomNounRetrievedState(noun: noun, word: word),
      ],
    );

    blocTest(
      'emits ExerciseRetrievingRandomNounState, ExerciseErrorState when DbHelper.getDatabase throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDbHelper.getDatabase())
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomNounEvent()),
      expect: () => [
        ExerciseRetrievingRandomNounState(),
        ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
    );

    blocTest(
      'emits ExerciseRetrievingRandomNounState, ExerciseErrorState when Database.rawQuery throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDatabase.rawQuery(any()))
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(ExerciseRetrieveRandomNounEvent()),
      expect: () => [
        ExerciseRetrievingRandomNounState(),
        ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
    );
  });
}
