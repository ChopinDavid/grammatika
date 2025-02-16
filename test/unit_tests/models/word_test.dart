import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/models/level.dart';
import 'package:grammatika/models/word.dart';
import 'package:grammatika/models/word_type.dart';

main() {
  group('fromJson', () {
    group('id', () {
      test('parses String correctly', () {
        const expectedId = 999;
        final actual = Word.fromJson({
          'id': expectedId.toString(),
          'accented': '',
          'bare': '',
        });
        expect(actual.id, expectedId);
      });

      test('parses int correctly', () {
        const expectedId = 999;
        final actual = Word.fromJson(const {
          'id': expectedId,
          'accented': '',
          'bare': '',
        });
        expect(actual.id, expectedId);
      });

      test('throws AssertionError if null', () {
        expect(
            () => Word.fromJson(const {
                  'id': null,
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Word.fromJson(const {
                  'id': true,
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Word.fromJson(const {
                  'id': {},
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Word.fromJson(const {
                  'id': [],
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });
    });

    group('position', () {
      test('parses String correctly', () {
        const expectedPosition = 999;
        final actual = Word.fromJson(const {
          'position': expectedPosition,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.position, expectedPosition);
      });

      test('parses int correctly', () {
        const expectedPosition = 999;
        final actual = Word.fromJson(const {
          'position': expectedPosition,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.position, expectedPosition);
      });

      test('does not throw when null', () {
        const expectedPosition = null;
        final actual = Word.fromJson(const {
          'position': expectedPosition,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.position, expectedPosition);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Word.fromJson(const {
                  'position': true,
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Word.fromJson(const {
                  'position': {},
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Word.fromJson(const {
                  'position': [],
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });
    });

    group('bare', () {
      test('parses String correctly', () {
        const expectedBare = 'муж';
        final actual = Word.fromJson(const {
          'bare': expectedBare,
          'id': '1',
          'accented': '',
        });
        expect(actual.bare, expectedBare);
      });

      test('throws TypeError when null', () {
        expect(
            () => Word.fromJson(const {
                  'bare': null,
                  'id': '1',
                  'accented': '',
                }),
            throwsA(isA<TypeError>()));
      });

      test('throws TypeError if int', () {
        expect(
          () => Word.fromJson(const {
            'bare': 1,
            'id': '1',
            'accented': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Word.fromJson(const {
            'bare': true,
            'id': '1',
            'accented': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Word.fromJson(const {
            'bare': {},
            'id': '1',
            'accented': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Word.fromJson(const {
            'bare': [],
            'id': '1',
            'accented': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('accented', () {
      test('parses String correctly', () {
        const expectedAccented = 'муж';
        final actual = Word.fromJson(const {
          'accented': expectedAccented,
          'id': '1',
          'bare': '',
        });
        expect(actual.accented, expectedAccented);
      });

      test('throws TypeError when null', () {
        expect(
            () => Word.fromJson(const {
                  'accented': null,
                  'id': '1',
                  'bare': '',
                }),
            throwsA(isA<TypeError>()));
      });

      test('throws TypeError if int', () {
        expect(
          () => Word.fromJson(const {
            'accented': 1,
            'id': '1',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Word.fromJson(const {
            'accented': true,
            'id': '1',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Word.fromJson(const {
            'accented': {},
            'id': '1',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Word.fromJson(const {
            'accented': [],
            'id': '1',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('derived_from_word_id', () {
      test('parses String correctly', () {
        const expectedDerivedFromWordId = 999;
        final actual = Word.fromJson(const {
          'derived_from_word_id': expectedDerivedFromWordId,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.derivedFromWordId, expectedDerivedFromWordId);
      });

      test('parses int correctly', () {
        const expectedDerivedFromWordId = 999;
        final actual = Word.fromJson(const {
          'derived_from_word_id': expectedDerivedFromWordId,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.derivedFromWordId, expectedDerivedFromWordId);
      });

      test('does not throw when null', () {
        const expectedDerivedFromWordId = null;
        final actual = Word.fromJson(const {
          'derived_from_word_id': expectedDerivedFromWordId,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.derivedFromWordId, expectedDerivedFromWordId);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Word.fromJson(const {
                  'derived_from_word_id': true,
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Word.fromJson(const {
                  'derived_from_word_id': {},
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Word.fromJson(const {
                  'derived_from_word_id': [],
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });
    });

    group('rank', () {
      test('parses String correctly', () {
        const expectedRank = 999;
        final actual = Word.fromJson(const {
          'rank': expectedRank,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.rank, expectedRank);
      });

      test('parses int correctly', () {
        const expectedRank = 999;
        final actual = Word.fromJson(const {
          'rank': expectedRank,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.rank, expectedRank);
      });

      test('does not throw when null', () {
        const expectedRank = null;
        final actual = Word.fromJson(const {
          'rank': expectedRank,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.derivedFromWordId, expectedRank);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Word.fromJson(const {
                  'rank': true,
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Word.fromJson(const {
                  'rank': {},
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Word.fromJson(const {
                  'rank': [],
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });
    });

    group('disabled', () {
      test('parses int (0) correctly', () {
        const expectedDisabled = false;
        final actual = Word.fromJson(const {
          'disabled': 0,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.disabled, expectedDisabled);
      });

      test('parses int (1) correctly', () {
        const expectedDisabled = true;
        final actual = Word.fromJson(const {
          'disabled': 1,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.disabled, expectedDisabled);
      });

      test('throws AssertionError when parsing an int that is not 0 or 1', () {
        expect(
            () => Word.fromJson(const {
                  'disabled': 2,
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('parses bool correctly', () {
        const expectedDisabled = true;
        final actual = Word.fromJson(const {
          'disabled': expectedDisabled,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.disabled, expectedDisabled);
      });

      test('parses String ("0") correctly', () {
        const expectedDisabled = false;
        final actual = Word.fromJson(const {
          'disabled': expectedDisabled,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.disabled, expectedDisabled);
      });

      test('parses String ("1") correctly', () {
        const expectedDisabled = true;
        final actual = Word.fromJson(const {
          'disabled': '1',
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.disabled, expectedDisabled);
      });

      test('throws AssertionError if String (not "0" or "1")', () {
        expect(
            () => Word.fromJson(const {
                  'disabled': '2',
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Word.fromJson(const {
                  'disabled': {},
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Word.fromJson(const {
                  'disabled': [],
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });
    });

    group('audio', () {
      test('parses String correctly', () {
        const expectedAudio =
            'https://www.somewebsite.com/somepath/somefile.mp3';
        final actual = Word.fromJson(const {
          'audio': expectedAudio,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.audio, expectedAudio);
      });

      test('parses null correctly', () {
        const expectedAudio = null;
        final actual = Word.fromJson(const {
          'audio': expectedAudio,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.audio, expectedAudio);
      });

      test('throws TypeError if int', () {
        expect(
          () => Word.fromJson(const {
            'audio': 1,
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Word.fromJson(const {
            'audio': true,
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Word.fromJson(const {
            'audio': {},
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Word.fromJson(const {
            'audio': [],
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('usage_en', () {
      test('parses String correctly', () {
        const expectedUsageEn = 'you use this word some way';
        final actual = Word.fromJson(const {
          'usage_en': expectedUsageEn,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.usageEn, expectedUsageEn);
      });

      test('parses null correctly', () {
        const expectedUsageEn = null;
        final actual = Word.fromJson(const {
          'usage_en': expectedUsageEn,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.usageEn, expectedUsageEn);
      });

      test('throws TypeError if int', () {
        expect(
          () => Word.fromJson(const {
            'usage_en': 1,
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Word.fromJson(const {
            'usage_en': true,
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Word.fromJson(const {
            'usage_en': {},
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Word.fromJson(const {
            'usage_en': [],
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('usage_de', () {
      test('parses String correctly', () {
        const expectedUsageDe = 'guten tag';
        final actual = Word.fromJson(const {
          'usage_de': expectedUsageDe,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.usageDe, expectedUsageDe);
      });

      test('parses null correctly', () {
        const expectedUsageDe = null;
        final actual = Word.fromJson(const {
          'usage_de': expectedUsageDe,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.usageDe, expectedUsageDe);
      });

      test('throws TypeError if int', () {
        expect(
          () => Word.fromJson(const {
            'usage_de': 1,
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Word.fromJson(const {
            'usage_de': true,
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Word.fromJson(const {
            'usage_de': {},
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Word.fromJson(const {
            'usage_de': [],
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('number_value', () {
      test('parses String correctly', () {
        const expectedNumberValue = 999;
        final actual = Word.fromJson(const {
          'number_value': expectedNumberValue,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.numberValue, expectedNumberValue);
      });

      test('parses int correctly', () {
        const expectedNumberValue = 999;
        final actual = Word.fromJson(const {
          'number_value': expectedNumberValue,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.numberValue, expectedNumberValue);
      });

      test('does not throw when null', () {
        const expectedNumberValue = null;
        final actual = Word.fromJson(const {
          'number_value': expectedNumberValue,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.numberValue, expectedNumberValue);
      });

      test('throws AssertionError if of type bool', () {
        expect(
            () => Word.fromJson(const {
                  'number_value': true,
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if object', () {
        expect(
            () => Word.fromJson(const {
                  'number_value': {},
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });

      test('throws AssertionError if array', () {
        expect(
            () => Word.fromJson(const {
                  'number_value': [],
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsAssertionError);
      });
    });

    group('type', () {
      test('parses lowercase identifiers correctly', () {
        const expectedType = WordType.adverb;
        final actual = Word.fromJson({
          'type': expectedType.name,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.type, expectedType);
      });

      test('parses nulls correctly', () {
        const expectedType = null;
        final actual = Word.fromJson(const {
          'type': expectedType,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.type, expectedType);
      });

      test('parses empty-strings correctly', () {
        const expectedType = null;
        final actual = Word.fromJson(const {
          'type': '',
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.type, expectedType);
      });

      test('throws when passed unknown identifier', () {
        expect(
          () => Word.fromJson(const {
            'type': 'spaghetti',
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsArgumentError,
        );
      });
    });

    group('level', () {
      test('parses lowercase identifiers correctly', () {
        const expectedLevel = Level.A1;
        final actual = Word.fromJson({
          'level': expectedLevel.name,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.level, expectedLevel);
      });

      test('parses capital identifiers correctly', () {
        const expectedLevel = Level.C2;
        final actual = Word.fromJson({
          'level': expectedLevel.name.toUpperCase(),
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.level, expectedLevel);
      });

      test('parses nulls correctly', () {
        const expectedLevel = null;
        final actual = Word.fromJson(const {
          'level': expectedLevel,
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.level, expectedLevel);
      });

      test('parses empty-strings correctly', () {
        const expectedLevel = null;
        final actual = Word.fromJson(const {
          'level': '',
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.level, expectedLevel);
      });

      test('throws when passed unknown identifier', () {
        expect(
          () => Word.fromJson(const {
            'level': 'spaghetti',
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsArgumentError,
        );
      });
    });

    group('created_at', () {
      test('does not throw if null', () {
        const expectedCreatedAt = null;
        final actual = Word.fromJson(const {
          'created_at': '',
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.createdAt, expectedCreatedAt);
      });

      test('parses valid date correctly', () {
        final expectedCreatedAt = DateTime.now();
        final actual = Word.fromJson({
          'created_at': expectedCreatedAt.toIso8601String(),
          'id': '1',
          'accented': '',
          'bare': '',
        });
        expect(actual.createdAt, expectedCreatedAt);
      });

      test('throws when passed invalid Iso8601 String', () {
        expect(
            () => Word.fromJson(const {
                  'created_at': 'spaghetti',
                  'id': '1',
                  'accented': '',
                  'bare': '',
                }),
            throwsFormatException);
      });

      test('throws TypeError if int', () {
        expect(
          () => Word.fromJson(const {
            'created_at': 1,
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if bool', () {
        expect(
          () => Word.fromJson(const {
            'created_at': true,
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if object', () {
        expect(
          () => Word.fromJson(const {
            'created_at': {},
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError if array', () {
        expect(
          () => Word.fromJson(const {
            'created_at': [],
            'id': '1',
            'accented': '',
            'bare': '',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });

  group('toJson', () {
    test('removes null values', () {
      final expected = {
        'id': 1411,
        'bare': 'тепло',
        'accented': 'тепло\'',
        'disabled': false,
      };
      final actual = Word.testValueSimple().toJson();
      expect(actual, expected);
    });

    test('converts created_at DateTime to Iso8601 String', () {
      final now = DateTime.now();
      final expected = {
        'id': 1411,
        'bare': 'тепло',
        'accented': 'тепло\'',
        'disabled': false,
        'created_at': now.toIso8601String(),
      };
      final actual = Word.testValueSimple(createdAt: now).toJson();
      expect(actual['created_at'], expected['created_at']);
    });

    test('maps values correctly', () {
      final testValue = Word.testValue();
      final expected = {
        'id': testValue.id,
        'position': testValue.position,
        'bare': testValue.bare,
        'accented': testValue.accented,
        'derived_from_word_id': testValue.derivedFromWordId,
        'rank': testValue.rank,
        'disabled': testValue.disabled,
        'audio': testValue.audio,
        'usage_en': testValue.usageEn,
        'usage_de': testValue.usageDe,
        'number_value': testValue.numberValue,
        'type': testValue.type?.name,
        'level': testValue.level?.name,
        'created_at': testValue.createdAt?.toIso8601String()
      };

      final actual = testValue.toJson();
      expect(actual, expected);
    });
  });

  test('toJson and fromJson translate back and forth', () {
    final word = Word.testValue();
    expect(
        word,
        Word.fromJson(
          word.toJson(),
        ));
  });
}
