import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/extensions/gender_extension.dart';
import 'package:grammatika/models/gender.dart';

main() {
  group('displayString', () {
    test('returns "Masculine" when gender is Gender.m', () {
      expect(Gender.m.displayString, 'Masculine');
    });
    test('returns "Feminine" when gender is Gender.f', () {
      expect(Gender.f.displayString, 'Feminine');
    });
    test('returns "Neuter" when gender is Gender.n', () {
      expect(Gender.n.displayString, 'Neuter');
    });
    test('returns null when gender is Gender.pl', () {
      expect(Gender.pl.displayString, 'Plural');
    });
    test('returns null when gender is Gender.both', () {
      expect(Gender.both.displayString, 'Both');
    });
  });
}
