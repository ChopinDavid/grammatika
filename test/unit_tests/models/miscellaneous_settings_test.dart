import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/models/miscellaneous_settings.dart';

main() {
  group('defaultSettings factory', () {
    test(
      'returns expected object',
      () {
        const expected =
            MiscellaneousSettings(automaticallyShowExplanation: false);
        final actual = MiscellaneousSettings.defaultSettings();
        expect(actual, expected);
      },
    );
  });

  group(
    'copyWith',
    () {
      test(
        'returns a new object with the updated value',
        () {
          const original =
              MiscellaneousSettings(automaticallyShowExplanation: false);
          const updated =
              MiscellaneousSettings(automaticallyShowExplanation: true);
          final result = original.copyWith(automaticallyShowExplanation: true);
          expect(result, updated);
        },
      );

      test(
        'returns the same object if no parameters are provided',
        () {
          const original =
              MiscellaneousSettings(automaticallyShowExplanation: false);
          final result = original.copyWith();
          expect(result, original);
        },
      );
    },
  );

  group(
    'fromJson',
    () {
      test('returns an object with the correct values', () {
        const json = {'automaticallyShowExplanation': true};
        final result = MiscellaneousSettings.fromJson(json);
        const expected =
            MiscellaneousSettings(automaticallyShowExplanation: true);
        expect(result, expected);
      });
    },
  );

  group(
    'toJson',
    () {
      test('returns a map with the correct values', () {
        const settings =
            MiscellaneousSettings(automaticallyShowExplanation: true);
        final result = settings.toJson();
        const expected = {'automaticallyShowExplanation': true};
        expect(result, expected);
      });
    },
  );
}
