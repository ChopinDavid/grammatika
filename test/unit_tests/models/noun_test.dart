import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word.dart';

import '../mocks.dart';

main() {
  group('fromJson', () {
    group('word_id', () {
      test('parses String correctly', () {
        const expectedWordId = 999;
        final actual = Noun.fromJson({
          'word_id': expectedWordId.toString(),
        });
        expect(actual.wordId, expectedWordId);
      });

      test('parses int correctly', () {
        const expectedWordId = 999;
        final actual = Noun.fromJson({
          'word_id': expectedWordId,
        });
        expect(actual.wordId, expectedWordId);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Noun.fromJson({
                  'word_id': true,
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson({
                  'word_id': {},
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson({
                  'word_id': [],
                }),
            throwsAssertionError);
      });

      group('gender', () {
        test('parses lowercase identifiers correctly', () {
          const expectedGender = Gender.n;
          final actual = Noun.fromJson({
            'word_id': 0,
            'gender': 'n',
          });
          expect(actual.gender, expectedGender);
        });

        test('parses capital identifiers correctly', () {
          const expectedGender = Gender.n;
          final actual = Noun.fromJson({
            'word_id': 0,
            'gender': 'N',
          });
          expect(actual.gender, expectedGender);
        });

        test('parses nulls correctly', () {
          const expectedGender = null;
          final actual = Noun.fromJson({
            'word_id': 0,
            'gender': expectedGender,
          });
          expect(actual.gender, expectedGender);
        });

        test('parses empty-strings correctly', () {
          const expectedGender = null;
          final actual = Noun.fromJson({
            'word_id': 0,
            'gender': '',
          });
          expect(actual.gender, expectedGender);
        });

        test('throws when passed unknown identifier', () {
          expect(
            () => Noun.fromJson({
              'word_id': 0,
              'gender': 'q',
            }),
            throwsArgumentError,
          );
        });
      });

      group('partner', () {
        test('parses String correctly', () {
          const expectedPartner = 'муж';
          final actual = Noun.fromJson({
            'word_id': 0,
            'partner': expectedPartner,
          });
          expect(actual.partner, expectedPartner);
        });

        test('parses null correctly', () {
          const expectedPartner = null;
          final actual = Noun.fromJson({
            'word_id': 0,
            'partner': expectedPartner,
          });
          expect(actual.partner, expectedPartner);
        });

        test('throws TypeError if int', () {
          expect(
            () => Noun.fromJson({
              'word_id': 0,
              'partner': 1,
            }),
            throwsA(isA<TypeError>()),
          );
        });

        test('throws TypeError if bool', () {
          expect(
            () => Noun.fromJson({
              'word_id': 0,
              'partner': true,
            }),
            throwsA(isA<TypeError>()),
          );
        });

        test('throws TypeError if object', () {
          expect(
            () => Noun.fromJson({
              'word_id': 0,
              'partner': {},
            }),
            throwsA(isA<TypeError>()),
          );
        });

        test('throws TypeError if array', () {
          expect(
            () => Noun.fromJson({
              'word_id': 0,
              'partner': [],
            }),
            throwsA(isA<TypeError>()),
          );
        });
      });

      group('animate', () {
        test('parses int (0) correctly', () {
          const expectedAnimate = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'animate': 0,
          });
          expect(actual.animate, expectedAnimate);
        });

        test('parses int (1) correctly', () {
          const expectedAnimate = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'animate': 1,
          });
          expect(actual.animate, expectedAnimate);
        });

        test('throws AssertionError when parsing an int that is not 0 or 1',
            () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'animate': 2,
                  }),
              throwsAssertionError);
        });

        test('parses bool correctly', () {
          const expectedAnimate = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'animate': expectedAnimate,
          });
          expect(actual.animate, expectedAnimate);
        });

        test('parses String ("0") correctly', () {
          const expectedAnimate = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'animate': '0',
          });
          expect(actual.animate, expectedAnimate);
        });

        test('parses String ("1") correctly', () {
          const expectedAnimate = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'animate': '1',
          });
          expect(actual.animate, expectedAnimate);
        });

        test('throws AssertionError if String (not "0" or "1")', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'animate': '2',
                  }),
              throwsAssertionError);
        });

        test('throws AssertionError if object', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'animate': {},
                  }),
              throwsAssertionError);
        });

        test('throws AssertionError if array', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'animate': [],
                  }),
              throwsAssertionError);
        });
      });

      group('indeclinable', () {
        test('parses int (0) correctly', () {
          const expectedIndeclinable = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'indeclinable': 0,
          });
          expect(actual.indeclinable, expectedIndeclinable);
        });

        test('parses int (1) correctly', () {
          const expectedIndeclinable = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'indeclinable': 1,
          });
          expect(actual.indeclinable, expectedIndeclinable);
        });

        test('throws AssertionError when parsing an int that is not 0 or 1',
            () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'indeclinable': 2,
                  }),
              throwsAssertionError);
        });

        test('parses null as false', () {
          const expectedPlOnly = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'indeclinable': null,
          });
          expect(actual.plOnly, expectedPlOnly);
        });

        test('parses bool correctly', () {
          const expectedIndeclinable = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'indeclinable': expectedIndeclinable,
          });
          expect(actual.indeclinable, expectedIndeclinable);
        });

        test('parses String ("0") correctly', () {
          const expectedIndeclinable = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'indeclinable': '0',
          });
          expect(actual.indeclinable, expectedIndeclinable);
        });

        test('parses String ("1") correctly', () {
          const expectedIndeclinable = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'indeclinable': '1',
          });
          expect(actual.indeclinable, expectedIndeclinable);
        });

        test('throws AssertionError if String (not "0" or "1")', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'indeclinable': '2',
                  }),
              throwsAssertionError);
        });

        test('throws AssertionError if object', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'indeclinable': {},
                  }),
              throwsAssertionError);
        });

        test('throws AssertionError if array', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'indeclinable': [],
                  }),
              throwsAssertionError);
        });
      });

      group('sg_only', () {
        test('parses int (0) correctly', () {
          const expectedSgOnly = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'sg_only': 0,
          });
          expect(actual.sgOnly, expectedSgOnly);
        });

        test('parses int (1) correctly', () {
          const expectedSgOnly = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'sg_only': 1,
          });
          expect(actual.sgOnly, expectedSgOnly);
        });

        test('throws AssertionError when parsing an int that is not 0 or 1',
            () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'sg_only': 2,
                  }),
              throwsAssertionError);
        });

        test('parses null as false', () {
          const expectedPlOnly = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'sg_only': null,
          });
          expect(actual.plOnly, expectedPlOnly);
        });

        test('parses bool correctly', () {
          const expectedSgOnly = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'sg_only': expectedSgOnly,
          });
          expect(actual.sgOnly, expectedSgOnly);
        });

        test('parses String ("0") correctly', () {
          const expectedSgOnly = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'sg_only': '0',
          });
          expect(actual.sgOnly, expectedSgOnly);
        });

        test('parses String ("1") correctly', () {
          const expectedSgOnly = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'sg_only': '1',
          });
          expect(actual.sgOnly, expectedSgOnly);
        });

        test('throws AssertionError if String (not "0" or "1")', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'sg_only': '2',
                  }),
              throwsAssertionError);
        });

        test('throws AssertionError if object', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'sg_only': {},
                  }),
              throwsAssertionError);
        });

        test('throws AssertionError if array', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'sg_only': [],
                  }),
              throwsAssertionError);
        });
      });

      group('pl_only', () {
        test('parses int (0) correctly', () {
          const expectedPlOnly = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'pl_only': 0,
          });
          expect(actual.plOnly, expectedPlOnly);
        });

        test('parses int (1) correctly', () {
          const expectedPlOnly = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'pl_only': 1,
          });
          expect(actual.plOnly, expectedPlOnly);
        });

        test('throws AssertionError when parsing an int that is not 0 or 1',
            () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'pl_only': 2,
                  }),
              throwsAssertionError);
        });

        test('parses null as false', () {
          const expectedPlOnly = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'pl_only': null,
          });
          expect(actual.plOnly, expectedPlOnly);
        });

        test('parses bool correctly', () {
          const expectedPlOnly = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'pl_only': expectedPlOnly,
          });
          expect(actual.plOnly, expectedPlOnly);
        });

        test('parses String ("0") correctly', () {
          const expectedPlOnly = false;
          final actual = Noun.fromJson({
            'word_id': 0,
            'pl_only': '0',
          });
          expect(actual.plOnly, expectedPlOnly);
        });

        test('parses String ("1") correctly', () {
          const expectedPlOnly = true;
          final actual = Noun.fromJson({
            'word_id': 0,
            'pl_only': '1',
          });
          expect(actual.plOnly, expectedPlOnly);
        });

        test('throws AssertionError if String (not "0" or "1")', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'pl_only': '2',
                  }),
              throwsAssertionError);
        });

        test('throws AssertionError if object', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'pl_only': {},
                  }),
              throwsAssertionError);
        });

        test('throws AssertionError if array', () {
          expect(
              () => Noun.fromJson({
                    'word_id': 0,
                    'pl_only': [],
                  }),
              throwsAssertionError);
        });
      });
    });
  });

  group('word', () {
    test('returns word when sqlite query succeeds', () async {
      const wordId = 999;
      final expected = Word.testValue();

      final mockDbHelper = MockDbHelper();
      final mockDatabase = MockDatabase();
      when(() => mockDbHelper.getDatabase())
          .thenAnswer((invocation) async => mockDatabase);
      when(() =>
              mockDatabase.rawQuery('SELECT * FROM words WHERE id = $wordId'))
          .thenAnswer((invocation) async => [expected.toJson()]);
      final actual = await Noun.fromJson({
        'word_id': wordId,
      }, dbHelper: mockDbHelper)
          .word;
      expect(actual, expected);
    });

    test('throws when dbHelper.getDatabase throws', () async {
      final mockDbHelper = MockDbHelper();
      when(() => mockDbHelper.getDatabase()).thenThrow(Exception());
      expect(
          () => Noun.fromJson({
                'word_id': '999',
              }, dbHelper: mockDbHelper)
                  .word,
          throwsException);
    });

    test('throws when dbHelper.getDatabase throws', () async {
      const wordId = '999';
      final mockDbHelper = MockDbHelper();
      final mockDatabase = MockDatabase();
      when(() => mockDbHelper.getDatabase())
          .thenAnswer((invocation) async => mockDatabase);
      when(() =>
              mockDatabase.rawQuery('SELECT * FROM words WHERE id = $wordId'))
          .thenThrow(Exception());
      expect(
          () => Noun.fromJson({
                'word_id': wordId,
              }, dbHelper: mockDbHelper)
                  .word,
          throwsException);
    });

    test('throws when Word.fromJson throws', () async {
      const wordId = 999;

      final mockDbHelper = MockDbHelper();
      final mockDatabase = MockDatabase();
      when(() => mockDbHelper.getDatabase())
          .thenAnswer((invocation) async => mockDatabase);
      when(() =>
              mockDatabase.rawQuery('SELECT * FROM words WHERE id = $wordId'))
          .thenAnswer((invocation) async => [
                {'this': 'shouldThrow'}
              ]);
      expect(
        () => Noun.fromJson({
          'word_id': wordId,
        }, dbHelper: mockDbHelper)
            .word,
        throwsA(
          isA<TypeError>(),
        ),
      );
    });
  });
}
