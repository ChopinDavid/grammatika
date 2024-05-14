import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';

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

    // TODO(DC): Write group for 'explanation'

    // TODO(DC): Write group word Word

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
