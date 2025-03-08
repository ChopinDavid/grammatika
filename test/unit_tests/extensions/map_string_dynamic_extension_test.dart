import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/extensions/map_string_dynamic_extension.dart';

main() {
  group('parseIntForKey', () {
    test('parses int from json', () {
      const expectedParsedInt = 1;
      const key = 'key';
      final json = {key: expectedParsedInt};
      final actual = json.parseIntForKey(key);
      expect(actual, expectedParsedInt);
    });

    test('parses String from json if it represents an int', () {
      const expectedParsedInt = 1;
      const key = 'key';
      final json = {key: expectedParsedInt.toString()};
      final actual = json.parseIntForKey(key);
      expect(actual, expectedParsedInt);
    });

    test('throws if value is String that does not represent an int', () {
      const key = 'key';
      expect(
          () => {key: 'spaghetti'}.parseIntForKey(key), throwsAssertionError);
    });

    test('throws if value is bool', () {
      const key = 'key';
      expect(() => {key: true}.parseIntForKey(key), throwsAssertionError);
    });

    test('throws if value is object', () {
      const key = 'key';
      expect(() => {key: {}}.parseIntForKey(key), throwsAssertionError);
    });

    test('throws if value is array', () {
      const key = 'key';
      expect(() => {key: []}.parseIntForKey(key), throwsAssertionError);
    });

    test('throws if value is null', () {
      const key = 'key';
      expect(() => {key: null}.parseIntForKey(key), throwsAssertionError);
    });
  });

  group('parseOptionalIntForKey', () {
    test('parses int from json', () {
      const expectedParsedOptionalInt = 1;
      const key = 'key';
      final json = {key: expectedParsedOptionalInt};
      final actual = json.parseOptionalIntForKey(key);
      expect(actual, expectedParsedOptionalInt);
    });

    test('parses String from json if it represents an int', () {
      const expectedParsedOptionalInt = 1;
      const key = 'key';
      final json = {key: expectedParsedOptionalInt.toString()};
      final actual = json.parseOptionalIntForKey(key);
      expect(actual, expectedParsedOptionalInt);
    });

    test(
        'throws AssertionError if value is String that does not represent an int',
        () {
      const key = 'key';
      expect(() => {key: 'spaghetti'}.parseOptionalIntForKey(key),
          throwsA(isA<AssertionError>()));
    });

    test('throws AssertionError if value is bool', () {
      const key = 'key';
      expect(
          () => {key: true}.parseOptionalIntForKey(key), throwsAssertionError);
    });

    test('throws AssertionError if value is object', () {
      const key = 'key';
      expect(() => {key: {}}.parseOptionalIntForKey(key), throwsAssertionError);
    });

    test('throws AssertionError if value is array', () {
      const key = 'key';
      expect(() => {key: []}.parseOptionalIntForKey(key), throwsAssertionError);
    });

    test('does not throw if value is null', () {
      const expectedParsedOptionalInt = null;
      const key = 'key';
      final json = {key: expectedParsedOptionalInt};
      final actual = json.parseOptionalIntForKey(key);
      expect(actual, expectedParsedOptionalInt);
    });

    test('throws if value is empty String', () {
      const expectedParsedOptionalInt = null;
      const key = 'key';
      final json = {key: ''};
      final actual = json.parseOptionalIntForKey(key);
      expect(actual, expectedParsedOptionalInt);
    });
  });

  group('parseBoolForKey', () {
    test('parses bool from json (true)', () {
      const expectedParsedBool = true;
      const key = 'key';
      final json = {key: expectedParsedBool};
      final actual = json.parseBoolForKey(key);
      expect(actual, expectedParsedBool);
    });

    test('parses bool from json (false)', () {
      const expectedParsedBool = false;
      const key = 'key';
      final json = {key: expectedParsedBool};
      final actual = json.parseBoolForKey(key);
      expect(actual, expectedParsedBool);
    });

    test('parses int from json (0)', () {
      const expectedParsedBool = false;
      const key = 'key';
      final json = {key: 0};
      final actual = json.parseBoolForKey(key);
      expect(actual, expectedParsedBool);
    });

    test('parses int from json (1)', () {
      const expectedParsedBool = true;
      const key = 'key';
      final json = {key: 1};
      final actual = json.parseBoolForKey(key);
      expect(actual, expectedParsedBool);
    });

    test('throws if value is int that is not 0 or 1', () {
      const key = 'key';
      final json = {key: 2};
      expect(() => json.parseBoolForKey(key), throwsAssertionError);
    });

    test('parses String from json ("0")', () {
      const expectedParsedBool = false;
      const key = 'key';
      final json = {key: '0'};
      final actual = json.parseBoolForKey(key);
      expect(actual, expectedParsedBool);
    });

    test('parses String from json ("1")', () {
      const expectedParsedBool = true;
      const key = 'key';
      final json = {key: '1'};
      final actual = json.parseBoolForKey(key);
      expect(actual, expectedParsedBool);
    });

    test('parses String from json ("")', () {
      const expectedParsedBool = false;
      const key = 'key';
      final json = {key: ''};
      final actual = json.parseBoolForKey(key);
      expect(actual, expectedParsedBool);
    });

    test('throws if value is String that is not "0" or "1"', () {
      const key = 'key';
      final json = {key: '2'};
      expect(() => json.parseBoolForKey(key), throwsAssertionError);
    });

    test('parses null as false', () {
      const expectedParsedBool = false;
      const key = 'key';
      final json = {key: null};
      final actual = json.parseBoolForKey(key);
      expect(actual, expectedParsedBool);
    });
  });
}
