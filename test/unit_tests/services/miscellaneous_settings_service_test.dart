import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/models/miscellaneous_settings.dart';
import 'package:grammatika/services/miscellaneous_settings_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks.dart';

main() {
  late SharedPreferences mockSharedPreferences;
  late MiscellaneousSettingsService testObject;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testObject =
        MiscellaneousSettingsService(sharedPreferences: mockSharedPreferences);

    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) async => true);
  });

  group(
    'updateSettings',
    () {
      test(
          'invokes SharedPreferences.setString with serialized MiscellaneousSettings',
          () {
        final settings = MiscellaneousSettings.defaultSettings();
        testObject.updateSettings(settings);
        verify(
          () => mockSharedPreferences.setString(
            miscellaneousSettingsPreferencesKey,
            jsonEncode(
              settings.toJson(),
            ),
          ),
        );
      });
    },
  );

  group('getSettings', () {
    test(
        'Returns default MiscellaneousSettings when SharedPreferences.getString returns null',
        () {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      final expected = MiscellaneousSettings.defaultSettings();
      final actual = testObject.getSettings();
      expect(actual, expected);
    });

    test(
        'Returns MiscellaneousSettings fromJson when SharedPreferences.getString does not return null',
        () {
      const expected =
          MiscellaneousSettings(automaticallyShowExplanation: true);

      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonEncode(expected.toJson()));
      final actual = testObject.getSettings();
      expect(actual, expected);
    });
  });
}
