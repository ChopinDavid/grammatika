import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/extensions/string_extension.dart';

main() {
  group('isNullOrEmpty', () {
    test('returns true if passed String is null', () {
      expect(StringExtension.isNullOrEmpty(null), isTrue);
    });

    test('returns true if passed String is ""', () {
      expect(StringExtension.isNullOrEmpty(''), isTrue);
    });

    test('returns true if passed String is "\n"', () {
      expect(StringExtension.isNullOrEmpty('\n'), isTrue);
    });

    test('returns false if passed String is not null, empty, or whitespace',
        () {
      expect(StringExtension.isNullOrEmpty('\nspaghetti\n'), isFalse);
    });
  });
}
