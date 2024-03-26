import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/models/word.dart';

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
  });
}
