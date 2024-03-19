import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/models/noun.dart';

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
    });
  });
}
