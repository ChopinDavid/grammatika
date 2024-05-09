import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:sqflite/sqflite.dart';
import 'package:uchu/answer_helper.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/explanation_helper.dart';
import 'package:uchu/models/exercise.dart';
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
  late ExplanationHelper mockExplanationHelper;

  setUpAll(() {
    mocktail.registerFallbackValue(Gender.m);
  });

  setUp(() async {
    await GetIt.instance.reset();
    testObject = const AnswerHelper();
    mockDbHelper = MockDbHelper();
    mockDatabase = MockDatabase();
    mockExplanationHelper = MockExplanationHelper();

    mocktail
        .when(() => mockDbHelper.getDatabase())
        .thenAnswer((invocation) async => mockDatabase);

    GetIt.instance.registerSingleton<DbHelper>(mockDbHelper);
    GetIt.instance.registerSingleton<ExplanationHelper>(mockExplanationHelper);
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
        final expected = Exercise.testValue(
          answer: Gender.m,
          word: word,
          correctAnswer: noun.gender,
        );
        final actual = await testObject.processGenderAnswer(
          answer: Exercise<Gender>.testValue(
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
            () async => await testObject.processGenderAnswer(
                  answer: Exercise<Gender>.testValue(
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
            () async => await testObject.processGenderAnswer(
                  answer: Exercise<Gender>.testValue(
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
            () async => await testObject.processGenderAnswer(
                  answer: Exercise<Gender>.testValue(
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
            () async => await testObject.processGenderAnswer(
                  answer: Exercise<Gender>.testValue(
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
            () async => await testObject.processGenderAnswer(
                  answer: Exercise<Gender>.testValue(
                    answer: Gender.m,
                    word: word,
                  ),
                ),
            throwsException);
      });

      test('assigns explanation', () async {
        const expected = 'because I said so';
        mocktail
            .when(() => mockExplanationHelper.genderExplanation(
                bare: mocktail.any(named: 'bare'),
                gender: mocktail.any(named: 'gender')))
            .thenReturn(expected);
        final actual = (await testObject.processGenderAnswer(
                answer:
                    Exercise<Gender>.testValue(answer: Gender.m, word: word)))
            .explanation;
        expect(actual, expected);
      });
    });
  });
}
