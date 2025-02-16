import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/services/theme_service.dart';

import '../mocks.dart';

main() {
  late SharedPreferences mockSharedPreferences;
  late ThemeService testObject;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    testObject = ThemeService(sharedPreferences: mockSharedPreferences);

    when(() => mockSharedPreferences.setInt(any(), any()))
        .thenAnswer((_) async => true);
  });

  group('updateThemeMode', () {
    for (int i = 0; i < ThemeMode.values.length; i++) {
      final themeMode = ThemeMode.values[i];
      test(
          'invokes SharedPreferences.setInt, setting ${themeMode.index} when ${themeMode.name} is passed',
          () {
        testObject.updateThemeMode(themeMode);
        verify(() => mockSharedPreferences.setInt(
            themeModeSharedPreferencesKey, themeMode.index));
      });
    }

    test('notifies listeners', () {
      int listenerNotifiedCallCount = 0;
      testObject.addListener(() => listenerNotifiedCallCount++);

      testObject.updateThemeMode(ThemeMode.light);
      expect(listenerNotifiedCallCount, 1);
    });
  });

  group('getThemeMode', () {
    for (int i = 0; i < ThemeMode.values.length; i++) {
      final themeMode = ThemeMode.values[i];
      test(
          'returns ${themeMode.name} when SharedPreferences.getInt returns ${themeMode.index}',
          () {
        when(() => mockSharedPreferences.getInt(any()))
            .thenReturn(themeMode.index);
        expect(testObject.getThemeMode(), themeMode);
      });
    }
  });
}
