import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/database_bloc.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';

import 'mocks.dart';

main() {
  late DatabaseBloc testObject;
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
    when(() => mockDatabase
            .rawQuery('SELECT * FROM nouns ORDER BY RANDOM() LIMIT 1;'))
        .thenAnswer((invocation) async => [noun.toJson()]);
    when(() => mockDatabase
            .rawQuery('SELECT * FROM words WHERE id = ${noun.wordId}'))
        .thenAnswer((invocation) async => [word.toJson()]);
    GetIt.instance.registerSingleton<DbHelper>(mockDbHelper);
    testObject = DatabaseBloc();
  });

  group('DatabaseRetrieveExerciseEvent', () {
    blocTest(
      'emits DatabaseRetrievingRandomNounState, DatabaseRandomNounRetrievedState when db query succeeds',
      build: () => testObject,
      act: (bloc) => bloc.add(DatabaseRetrieveExerciseEvent()),
      expect: () => [
        DatabaseRetrievingRandomNounState(),
        DatabaseRandomNounRetrievedState(noun: noun, word: word),
      ],
    );

    blocTest(
      'emits DatabaseRetrievingRandomNounState, DatabaseErrorState when DbHelper.getDatabase throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDbHelper.getDatabase())
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(DatabaseRetrieveExerciseEvent()),
      expect: () => [
        DatabaseRetrievingRandomNounState(),
        DatabaseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
    );

    blocTest(
      'emits DatabaseRetrievingRandomNounState, DatabaseErrorState when Database.rawQuery throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDatabase.rawQuery(any()))
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(DatabaseRetrieveExerciseEvent()),
      expect: () => [
        DatabaseRetrievingRandomNounState(),
        DatabaseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
    );
  });

  group('DatabaseRetrieveRandomNounEvent', () {
    blocTest(
      'emits DatabaseRetrievingRandomNounState, DatabaseRandomNounRetrievedState when db query succeeds',
      build: () => testObject,
      act: (bloc) => bloc.add(DatabaseRetrieveRandomNounEvent()),
      expect: () => [
        DatabaseRetrievingRandomNounState(),
        DatabaseRandomNounRetrievedState(noun: noun, word: word),
      ],
    );

    blocTest(
      'emits DatabaseRetrievingRandomNounState, DatabaseErrorState when DbHelper.getDatabase throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDbHelper.getDatabase())
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(DatabaseRetrieveRandomNounEvent()),
      expect: () => [
        DatabaseRetrievingRandomNounState(),
        DatabaseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
    );

    blocTest(
      'emits DatabaseRetrievingRandomNounState, DatabaseErrorState when Database.rawQuery throws',
      build: () => testObject,
      setUp: () {
        when(() => mockDatabase.rawQuery(any()))
            .thenThrow(Exception('something went wrong!'));
      },
      act: (bloc) => bloc.add(DatabaseRetrieveRandomNounEvent()),
      expect: () => [
        DatabaseRetrievingRandomNounState(),
        DatabaseErrorState(errorString: 'Unable to parse noun from JSON'),
      ],
    );
  });
}
