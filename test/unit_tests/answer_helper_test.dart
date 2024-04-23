import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:sqflite/sqflite.dart';
import 'package:uchu/answer_helper.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/level.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/models/word_type.dart';

import 'mocks.dart';

main() {
  late AnswerHelper testObject;
  late DbHelper mockDbHelper;
  late Database mockDatabase;

  setUp(() async {
    await GetIt.instance.reset();
    testObject = const AnswerHelper();
    mockDbHelper = MockDbHelper();
    mockDatabase = MockDatabase();

    mocktail
        .when(() => mockDbHelper.getDatabase())
        .thenAnswer((invocation) async => mockDatabase);

    GetIt.instance.registerSingleton<DbHelper>(mockDbHelper);
  });
  group('processAnswer', () {
    group('type Gender', () {
      final word = Word.testValueSimple(
        id: 157,
        bare: 'вода',
        accented: "вода'",
        rank: 141,
        audio: 'https://openrussian.org/audio-shtooka/вода.mp3',
        type: WordType.noun,
        level: Level.A1,
      );
      late Noun noun;

      setUp(() {
        mocktail
            .when(() => mockDatabase
                .rawQuery("SELECT * FROM nouns WHERE word_id=${word.id};"))
            .thenAnswer((invocation) async => [noun.toJson()]);

        noun = Noun.testValueSimple(
          wordId: word.id,
          gender: Gender.f,
          animate: false,
          indeclinable: false,
          sgOnly: false,
          plOnly: false,
        );
      });

      test('assigns correct gender as correctAnswer', () async {
        final expected = Answer.testValue(
          answer: Gender.m,
          word: word,
          correctAnswer: noun.gender,
          explanation: 'Feminine nouns normally end with -а or -я.',
        );
        final actual = await testObject.processAnswer(
          answer: Answer<Gender>.testValue(
            answer: expected.answer,
            word: word,
          ),
        );

        expect(actual, expected);
      });

      test('throws when the queried noun has a pl gender', () async {
        noun = Noun.testValueSimple(
          wordId: noun.wordId,
          gender: Gender.pl,
          animate: noun.animate,
          indeclinable: noun.indeclinable,
          sgOnly: noun.sgOnly,
          plOnly: noun.plOnly,
        );

        expect(
            () async => await testObject.processAnswer(
                  answer: Answer<Gender>.testValue(
                    answer: Gender.m,
                    word: word,
                  ),
                ),
            throwsException);
      });

      test('throws when the queried noun has a both gender', () async {
        noun = Noun.testValueSimple(
          wordId: noun.wordId,
          gender: Gender.both,
          animate: noun.animate,
          indeclinable: noun.indeclinable,
          sgOnly: noun.sgOnly,
          plOnly: noun.plOnly,
        );

        expect(
            () async => await testObject.processAnswer(
                  answer: Answer<Gender>.testValue(
                    answer: Gender.m,
                    word: word,
                  ),
                ),
            throwsException);
      });

      test('throws when the queried noun has a null gender', () async {
        noun = Noun.testValueSimple(
          wordId: noun.wordId,
          gender: null,
          animate: noun.animate,
          indeclinable: noun.indeclinable,
          sgOnly: noun.sgOnly,
          plOnly: noun.plOnly,
        );

        expect(
            () async => await testObject.processAnswer(
                  answer: Answer<Gender>.testValue(
                    answer: Gender.m,
                    word: word,
                  ),
                ),
            throwsException);
      });

      test('throws when DbHelper.getDatabase throws', () async {
        mocktail
            .when(() => mockDbHelper.getDatabase())
            .thenThrow(Exception('something went wrong!'));

        expect(
            () async => await testObject.processAnswer(
                  answer: Answer<Gender>.testValue(
                    answer: Gender.m,
                    word: word,
                  ),
                ),
            throwsException);
      });

      test('throws when Database.rawQuery throws', () async {
        mocktail
            .when(() => mockDatabase.rawQuery(mocktail.any()))
            .thenThrow(Exception('something went wrong!'));

        expect(
            () async => await testObject.processAnswer(
                  answer: Answer<Gender>.testValue(
                    answer: Gender.m,
                    word: word,
                  ),
                ),
            throwsException);
      });
    });
  });

  // TODO(DC): write tests covering _getGenderExplanation
}
