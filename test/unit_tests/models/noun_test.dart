import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/level.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word_type.dart';

main() {
  group('fromJson', () {
    group('gender', () {
      test('parses lowercase identifiers correctly', () {
        const expectedGender = Gender.n;
        final actual = Noun.fromJson(const {
          'id': 0,
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'gender': 'n',
        });
        expect(actual.correctAnswer, expectedGender);
      });

      test('parses capital identifiers correctly', () {
        const expectedGender = Gender.n;
        final actual = Noun.fromJson(const {
          'id': 0,
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'gender': 'N',
        });
        expect(actual.correctAnswer, expectedGender);
      });

      test('throws when null', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': null,
                }),
            throwsArgumentError);
      });

      test('throws when empty string', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': '',
                }),
            throwsArgumentError);
      });

      test('throws when passed unknown identifier', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'q',
          }),
          throwsArgumentError,
        );
      });
    });

    group('explanation', () {
      test('parses String correctly', () {
        const expectedExplanation = 'because I said so';
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': expectedExplanation,
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.explanation, expectedExplanation);
      });

      test('throws when null', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': null,
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsA(isA<TypeError>()));
      });

      test('throws TypeError if int', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'n',
            'explanation': 1,
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'n',
            'explanation': true,
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'n',
            'explanation': {},
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'n',
            'explanation': [],
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('partner', () {
      test('parses String correctly', () {
        const expectedPartner = 'муж';
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'partner': expectedPartner,
        });
        expect(actual.partner, expectedPartner);
      });

      test('parses null correctly', () {
        const expectedPartner = null;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'partner': expectedPartner,
        });
        expect(actual.partner, expectedPartner);
      });

      test('throws TypeError if int', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
            'partner': 1,
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
            'partner': true,
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
            'partner': {},
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Noun.fromJson(const {
            'id': 0,
            'gender': 'n',
            'accented': "ра'дио",
            'bare': 'радио',
            'partner': [],
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('animate', () {
      test('parses int (0) correctly', () {
        const expectedAnimate = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'animate': 0,
        });
        expect(actual.animate, expectedAnimate);
      });

      test('parses int (1) correctly', () {
        const expectedAnimate = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'animate': 1,
        });
        expect(actual.animate, expectedAnimate);
      });

      test('throws AssertionError when parsing an int that is not 0 or 1', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'animate': 2,
                }),
            throwsAssertionError);
      });

      test('parses bool correctly', () {
        const expectedAnimate = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'animate': expectedAnimate,
        });
        expect(actual.animate, expectedAnimate);
      });

      test('parses String ("0") correctly', () {
        const expectedAnimate = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'animate': '0',
        });
        expect(actual.animate, expectedAnimate);
      });

      test('parses String ("1") correctly', () {
        const expectedAnimate = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'animate': '1',
        });
        expect(actual.animate, expectedAnimate);
      });

      test('throws AssertionError if String (not "0" or "1")', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'animate': '2',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'animate': {},
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'animate': [],
                }),
            throwsAssertionError);
      });
    });

    group('indeclinable', () {
      test('parses int (0) correctly', () {
        const expectedIndeclinable = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'indeclinable': 0,
        });
        expect(actual.indeclinable, expectedIndeclinable);
      });

      test('parses int (1) correctly', () {
        const expectedIndeclinable = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'indeclinable': 1,
        });
        expect(actual.indeclinable, expectedIndeclinable);
      });

      test('throws AssertionError when parsing an int that is not 0 or 1', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'indeclinable': 2,
                }),
            throwsAssertionError);
      });

      test('parses null as false', () {
        const expectedPlOnly = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'indeclinable': null,
        });
        expect(actual.plOnly, expectedPlOnly);
      });

      test('parses bool correctly', () {
        const expectedIndeclinable = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'indeclinable': expectedIndeclinable,
        });
        expect(actual.indeclinable, expectedIndeclinable);
      });

      test('parses String ("0") correctly', () {
        const expectedIndeclinable = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'indeclinable': '0',
        });
        expect(actual.indeclinable, expectedIndeclinable);
      });

      test('parses String ("1") correctly', () {
        const expectedIndeclinable = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'indeclinable': '1',
        });
        expect(actual.indeclinable, expectedIndeclinable);
      });

      test('throws AssertionError if String (not "0" or "1")', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'indeclinable': '2',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'indeclinable': {},
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'indeclinable': [],
                }),
            throwsAssertionError);
      });
    });

    group('sg_only', () {
      test('parses int (0) correctly', () {
        const expectedSgOnly = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'sg_only': 0,
        });
        expect(actual.sgOnly, expectedSgOnly);
      });

      test('parses int (1) correctly', () {
        const expectedSgOnly = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'sg_only': 1,
        });
        expect(actual.sgOnly, expectedSgOnly);
      });

      test('throws AssertionError when parsing an int that is not 0 or 1', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'sg_only': 2,
                }),
            throwsAssertionError);
      });

      test('parses null as false', () {
        const expectedPlOnly = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'sg_only': null,
        });
        expect(actual.plOnly, expectedPlOnly);
      });

      test('parses bool correctly', () {
        const expectedSgOnly = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'sg_only': expectedSgOnly,
        });
        expect(actual.sgOnly, expectedSgOnly);
      });

      test('parses String ("0") correctly', () {
        const expectedSgOnly = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'sg_only': '0',
        });
        expect(actual.sgOnly, expectedSgOnly);
      });

      test('parses String ("1") correctly', () {
        const expectedSgOnly = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'sg_only': '1',
        });
        expect(actual.sgOnly, expectedSgOnly);
      });

      test('throws AssertionError if String (not "0" or "1")', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'sg_only': '2',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'sg_only': {},
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'sg_only': [],
                }),
            throwsAssertionError);
      });
    });

    group('pl_only', () {
      test('parses int (0) correctly', () {
        const expectedPlOnly = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'pl_only': 0,
        });
        expect(actual.plOnly, expectedPlOnly);
      });

      test('parses int (1) correctly', () {
        const expectedPlOnly = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'pl_only': 1,
        });
        expect(actual.plOnly, expectedPlOnly);
      });

      test('throws AssertionError when parsing an int that is not 0 or 1', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'pl_only': 2,
                }),
            throwsAssertionError);
      });

      test('parses null as false', () {
        const expectedPlOnly = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'pl_only': null,
        });
        expect(actual.plOnly, expectedPlOnly);
      });

      test('parses bool correctly', () {
        const expectedPlOnly = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'pl_only': expectedPlOnly,
        });
        expect(actual.plOnly, expectedPlOnly);
      });

      test('parses String ("0") correctly', () {
        const expectedPlOnly = false;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'pl_only': '0',
        });
        expect(actual.plOnly, expectedPlOnly);
      });

      test('parses String ("1") correctly', () {
        const expectedPlOnly = true;
        final actual = Noun.fromJson(const {
          'id': 0,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
          'pl_only': '1',
        });
        expect(actual.plOnly, expectedPlOnly);
      });

      test('throws AssertionError if String (not "0" or "1")', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'pl_only': '2',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'pl_only': {},
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'id': 0,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                  'pl_only': [],
                }),
            throwsAssertionError);
      });
    });
  });

  group('word', () {
    group('id', () {
      test('parses String correctly', () {
        const expectedId = 999;
        final actual = Noun.fromJson({
          'id': expectedId.toString(),
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.id, expectedId);
      });

      test('parses int correctly', () {
        const expectedId = 999;
        final actual = Noun.fromJson(const {
          'id': expectedId,
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.id, expectedId);
      });

      test('throws AssertionError if null', () {
        expect(
            () => Noun.fromJson(const {
                  'id': null,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Noun.fromJson(const {
                  'id': true,
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'id': {},
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'id': [],
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });
    });

    group('position', () {
      test('parses String correctly', () {
        const expectedPosition = 999;
        final actual = Noun.fromJson(const {
          'position': expectedPosition,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.position, expectedPosition);
      });

      test('parses int correctly', () {
        const expectedPosition = 999;
        final actual = Noun.fromJson(const {
          'position': expectedPosition,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.position, expectedPosition);
      });

      test('does not throw when null', () {
        const expectedPosition = null;
        final actual = Noun.fromJson(const {
          'position': expectedPosition,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.position, expectedPosition);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Noun.fromJson(const {
                  'position': true,
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'position': {},
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'position': [],
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });
    });

    group('bare', () {
      test('parses String correctly', () {
        const expectedBare = 'муж';
        final actual = Noun.fromJson(const {
          'bare': expectedBare,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
        });
        expect(actual.word.bare, expectedBare);
      });

      test('throws TypeError when null', () {
        expect(
            () => Noun.fromJson(const {
                  'bare': null,
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                }),
            throwsA(isA<TypeError>()));
      });

      test('throws TypeError if int', () {
        expect(
          () => Noun.fromJson(const {
            'bare': 1,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Noun.fromJson(const {
            'bare': true,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Noun.fromJson(const {
            'bare': {},
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Noun.fromJson(const {
            'bare': [],
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('accented', () {
      test('parses String correctly', () {
        const expectedAccented = 'муж';
        final actual = Noun.fromJson(const {
          'accented': expectedAccented,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'bare': 'радио',
        });
        expect(actual.word.accented, expectedAccented);
      });

      test('throws TypeError when null', () {
        expect(
            () => Noun.fromJson(const {
                  'accented': null,
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'bare': 'радио',
                }),
            throwsA(isA<TypeError>()));
      });

      test('throws TypeError if int', () {
        expect(
          () => Noun.fromJson(const {
            'accented': 1,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Noun.fromJson(const {
            'accented': true,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Noun.fromJson(const {
            'accented': {},
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Noun.fromJson(const {
            'accented': [],
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('derived_from_word_id', () {
      test('parses String correctly', () {
        const expectedDerivedFromWordId = 999;
        final actual = Noun.fromJson(const {
          'derived_from_word_id': expectedDerivedFromWordId,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.derivedFromWordId, expectedDerivedFromWordId);
      });

      test('parses int correctly', () {
        const expectedDerivedFromWordId = 999;
        final actual = Noun.fromJson(const {
          'derived_from_word_id': expectedDerivedFromWordId,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.derivedFromWordId, expectedDerivedFromWordId);
      });

      test('does not throw when null', () {
        const expectedDerivedFromWordId = null;
        final actual = Noun.fromJson(const {
          'derived_from_word_id': expectedDerivedFromWordId,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.derivedFromWordId, expectedDerivedFromWordId);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Noun.fromJson(const {
                  'derived_from_word_id': true,
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'derived_from_word_id': {},
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'derived_from_word_id': [],
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });
    });

    group('rank', () {
      test('parses String correctly', () {
        const expectedRank = 999;
        final actual = Noun.fromJson(const {
          'rank': expectedRank,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.rank, expectedRank);
      });

      test('parses int correctly', () {
        const expectedRank = 999;
        final actual = Noun.fromJson(const {
          'rank': expectedRank,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.rank, expectedRank);
      });

      test('does not throw when null', () {
        const expectedRank = null;
        final actual = Noun.fromJson(const {
          'rank': expectedRank,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.derivedFromWordId, expectedRank);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Noun.fromJson(const {
                  'rank': true,
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'rank': {},
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'rank': [],
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });
    });

    group('disabled', () {
      test('parses int (0) correctly', () {
        const expectedDisabled = false;
        final actual = Noun.fromJson(const {
          'disabled': 0,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.disabled, expectedDisabled);
      });

      test('parses int (1) correctly', () {
        const expectedDisabled = true;
        final actual = Noun.fromJson(const {
          'disabled': 1,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.disabled, expectedDisabled);
      });

      test('throws AssertionError when parsing an int that is not 0 or 1', () {
        expect(
            () => Noun.fromJson(const {
                  'disabled': 2,
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('parses bool correctly', () {
        const expectedDisabled = true;
        final actual = Noun.fromJson(const {
          'disabled': expectedDisabled,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.disabled, expectedDisabled);
      });

      test('parses String ("0") correctly', () {
        const expectedDisabled = false;
        final actual = Noun.fromJson(const {
          'disabled': expectedDisabled,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.disabled, expectedDisabled);
      });

      test('parses String ("1") correctly', () {
        const expectedDisabled = true;
        final actual = Noun.fromJson(const {
          'disabled': '1',
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.disabled, expectedDisabled);
      });

      test('throws AssertionError if String (not "0" or "1")', () {
        expect(
            () => Noun.fromJson(const {
                  'disabled': '2',
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'disabled': {},
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'disabled': [],
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });
    });

    group('audio', () {
      test('parses String correctly', () {
        const expectedAudio =
            'https://www.somewebsite.com/somepath/somefile.mp3';
        final actual = Noun.fromJson(const {
          'audio': expectedAudio,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.audio, expectedAudio);
      });

      test('parses null correctly', () {
        const expectedAudio = null;
        final actual = Noun.fromJson(const {
          'audio': expectedAudio,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.audio, expectedAudio);
      });

      test('throws TypeError if int', () {
        expect(
          () => Noun.fromJson(const {
            'audio': 1,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Noun.fromJson(const {
            'audio': true,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Noun.fromJson(const {
            'audio': {},
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Noun.fromJson(const {
            'audio': [],
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('usage_en', () {
      test('parses String correctly', () {
        const expectedUsageEn = 'you use this word some way';
        final actual = Noun.fromJson(const {
          'usage_en': expectedUsageEn,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.usageEn, expectedUsageEn);
      });

      test('parses null correctly', () {
        const expectedUsageEn = null;
        final actual = Noun.fromJson(const {
          'usage_en': expectedUsageEn,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.usageEn, expectedUsageEn);
      });

      test('throws TypeError if int', () {
        expect(
          () => Noun.fromJson(const {
            'usage_en': 1,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Noun.fromJson(const {
            'usage_en': true,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Noun.fromJson(const {
            'usage_en': {},
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Noun.fromJson(const {
            'usage_en': [],
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('usage_de', () {
      test('parses String correctly', () {
        const expectedUsageDe = 'guten tag';
        final actual = Noun.fromJson(const {
          'usage_de': expectedUsageDe,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.usageDe, expectedUsageDe);
      });

      test('parses null correctly', () {
        const expectedUsageDe = null;
        final actual = Noun.fromJson(const {
          'usage_de': expectedUsageDe,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.usageDe, expectedUsageDe);
      });

      test('throws TypeError if int', () {
        expect(
          () => Noun.fromJson(const {
            'usage_de': 1,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Noun.fromJson(const {
            'usage_de': true,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Noun.fromJson(const {
            'usage_de': {},
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Noun.fromJson(const {
            'usage_de': [],
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('number_value', () {
      test('parses String correctly', () {
        const expectedNumberValue = 999;
        final actual = Noun.fromJson(const {
          'number_value': expectedNumberValue,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.numberValue, expectedNumberValue);
      });

      test('parses int correctly', () {
        const expectedNumberValue = 999;
        final actual = Noun.fromJson(const {
          'number_value': expectedNumberValue,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.numberValue, expectedNumberValue);
      });

      test('does not throw when null', () {
        const expectedNumberValue = null;
        final actual = Noun.fromJson(const {
          'number_value': expectedNumberValue,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.numberValue, expectedNumberValue);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Noun.fromJson(const {
                  'number_value': true,
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Noun.fromJson(const {
                  'number_value': {},
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Noun.fromJson(const {
                  'number_value': [],
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsAssertionError);
      });
    });

    group('type', () {
      test('parses lowercase identifiers correctly', () {
        const expectedType = WordType.adverb;
        final actual = Noun.fromJson({
          'type': expectedType.name,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.type, expectedType);
      });

      test('parses nulls correctly', () {
        const expectedType = null;
        final actual = Noun.fromJson(const {
          'type': expectedType,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.type, expectedType);
      });

      test('parses empty-strings correctly', () {
        const expectedType = null;
        final actual = Noun.fromJson(const {
          'type': '',
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.type, expectedType);
      });

      test('throws when passed unknown identifier', () {
        expect(
          () => Noun.fromJson(const {
            'type': 'spaghetti',
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsArgumentError,
        );
      });
    });

    group('level', () {
      test('parses lowercase identifiers correctly', () {
        const expectedLevel = Level.A1;
        final actual = Noun.fromJson({
          'level': expectedLevel.name,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.level, expectedLevel);
      });

      test('parses capital identifiers correctly', () {
        const expectedLevel = Level.C2;
        final actual = Noun.fromJson({
          'level': expectedLevel.name.toUpperCase(),
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.level, expectedLevel);
      });

      test('parses nulls correctly', () {
        const expectedLevel = null;
        final actual = Noun.fromJson(const {
          'level': expectedLevel,
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.level, expectedLevel);
      });

      test('parses empty-strings correctly', () {
        const expectedLevel = null;
        final actual = Noun.fromJson(const {
          'level': '',
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.level, expectedLevel);
      });

      test('throws when passed unknown identifier', () {
        expect(
          () => Noun.fromJson(const {
            'level': 'spaghetti',
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsArgumentError,
        );
      });
    });

    group('created_at', () {
      test('does not throw if null', () {
        const expectedCreatedAt = null;
        final actual = Noun.fromJson(const {
          'created_at': '',
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.createdAt, expectedCreatedAt);
      });

      test('parses valid date correctly', () {
        final expectedCreatedAt = DateTime.now();
        final actual = Noun.fromJson({
          'created_at': expectedCreatedAt.toIso8601String(),
          'id': '1',
          'gender': 'n',
          'explanation': 'because I said so',
          'accented': "ра'дио",
          'bare': 'радио',
        });
        expect(actual.word.createdAt, expectedCreatedAt);
      });

      test('throws when passed invalid Iso8601 String', () {
        expect(
            () => Noun.fromJson(const {
                  'created_at': 'spaghetti',
                  'id': '1',
                  'gender': 'n',
                  'explanation': 'because I said so',
                  'accented': "ра'дио",
                  'bare': 'радио',
                }),
            throwsFormatException);
      });

      test('throws TypeError if int', () {
        expect(
          () => Noun.fromJson(const {
            'created_at': 1,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Noun.fromJson(const {
            'created_at': true,
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Noun.fromJson(const {
            'created_at': {},
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Noun.fromJson(const {
            'created_at': [],
            'id': '1',
            'gender': 'n',
            'explanation': 'because I said so',
            'accented': "ра'дио",
            'bare': 'радио',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });

  group('toJson', () {
    test('removes null values', () {
      final testValue = Noun.testValueSimple();
      final expected = {
        'gender': testValue.correctAnswer.name,
        'explanation': testValue.explanation,
        'id': testValue.word.id,
        'bare': testValue.word.bare,
        'accented': testValue.word.accented,
        'disabled': testValue.word.disabled,
        'animate': testValue.animate,
        'indeclinable': testValue.indeclinable,
        'sg_only': testValue.sgOnly,
        'pl_only': testValue.plOnly,
      };
      final actual = testValue.toJson();
      expect(actual, expected);
    });

    test('maps values correctly', () {
      final testValue = Noun.testValue();
      final expected = {
        'gender': testValue.correctAnswer.name,
        'explanation': testValue.explanation,
        'visual_explanation': testValue.visualExplanation,
        'id': testValue.word.id,
        'position': testValue.word.position,
        'bare': testValue.word.bare,
        'accented': testValue.word.accented,
        'derived_from_word_id': testValue.word.derivedFromWordId,
        'rank': testValue.word.rank,
        'disabled': testValue.word.disabled,
        'audio': testValue.word.audio,
        'usage_en': testValue.word.usageEn,
        'usage_de': testValue.word.usageDe,
        'number_value': testValue.word.numberValue,
        'type': testValue.word.type?.name,
        'level': testValue.word.level?.name,
        'created_at': testValue.word.createdAt?.toIso8601String(),
        'partner': testValue.partner,
        'animate': testValue.animate,
        'indeclinable': testValue.indeclinable,
        'sg_only': testValue.sgOnly,
        'pl_only': testValue.plOnly,
      };

      final actual = testValue.toJson();
      expect(actual, expected);
    });
  });

  test('toJson and fromJson translate back and forth', () {
    final noun = Noun.testValue();
    expect(
        noun,
        Noun.fromJson(
          noun.toJson(),
        ));
  });
}
