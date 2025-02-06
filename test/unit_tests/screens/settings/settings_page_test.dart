import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/screens/settings/appearance_setting_widget.dart';
import 'package:uchu/screens/settings/settings_page.dart';
import 'package:uchu/services/theme_service.dart';

import '../../mocks.dart';

main() {
  late ThemeService mockSharedPreferencesService;

  setUp(() async {
    await GetIt.instance.reset();

    mockSharedPreferencesService = MockSharedPreferencesService();
    when(() => mockSharedPreferencesService.getThemeMode())
        .thenReturn(ThemeMode.system);
    GetIt.instance.registerSingleton<ThemeService>(
      mockSharedPreferencesService,
    );
  });
  group('appearance section', () {
    group('"Light mode" AppearanceSettingWidget', () {
      testWidgets(
          'isSelected when SharedPreferencesService.getThemeMode returns ThemeMode.light',
          (tester) async {
        when(() => mockSharedPreferencesService.getThemeMode())
            .thenReturn(ThemeMode.light);
        await tester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();

        final lightModeAppearanceSettingWidget =
            tester.widget<AppearanceSettingWidget>(
          find.byKey(const Key('light_mode_appearance_setting_widget')),
        );
        expect(lightModeAppearanceSettingWidget.isSelected, isTrue);
      });

      testWidgets(
          'isSelected when SharedPreferencesService.getThemeMode returns ThemeMode.system and platformBrightness is Brightness.light',
          (tester) async {
        when(() => mockSharedPreferencesService.getThemeMode())
            .thenReturn(ThemeMode.system);
        const mediaQueryData = MediaQueryData(
          platformBrightness: Brightness.light,
        );
        await tester.pumpWidget(
          const MediaQuery(
            data: mediaQueryData,
            child: MaterialApp(
              home: SettingsPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final lightModeAppearanceSettingWidget =
            tester.widget<AppearanceSettingWidget>(
          find.byKey(const Key('light_mode_appearance_setting_widget')),
        );
        expect(lightModeAppearanceSettingWidget.isSelected, isTrue);
      });

      testWidgets(
          'is not selected when SharedPreferencesService.getThemeMode returns ThemeMode.dark',
          (tester) async {
        when(() => mockSharedPreferencesService.getThemeMode())
            .thenReturn(ThemeMode.dark);
        await tester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();

        final lightModeAppearanceSettingWidget =
            tester.widget<AppearanceSettingWidget>(
          find.byKey(const Key('light_mode_appearance_setting_widget')),
        );
        expect(lightModeAppearanceSettingWidget.isSelected, isFalse);
      });

      testWidgets(
          'is not selected when SharedPreferencesService.getThemeMode returns ThemeMode.system and platformBrightness is Brightness.dark',
          (tester) async {
        when(() => mockSharedPreferencesService.getThemeMode())
            .thenReturn(ThemeMode.system);
        const mediaQueryData = MediaQueryData(
          platformBrightness: Brightness.dark,
        );
        await tester.pumpWidget(
          const MediaQuery(
            data: mediaQueryData,
            child: MaterialApp(
              home: SettingsPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final lightModeAppearanceSettingWidget =
            tester.widget<AppearanceSettingWidget>(
          find.byKey(const Key('light_mode_appearance_setting_widget')),
        );
        expect(lightModeAppearanceSettingWidget.isSelected, isFalse);
      });

      testWidgets(
          'invokes SharedPreferencesService.updateThemeMode with ThemeMode.light when tapped',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();

        await tester
            .tap(find.byKey(const Key('light_mode_appearance_setting_widget')));

        verify(() =>
                mockSharedPreferencesService.updateThemeMode(ThemeMode.light))
            .called(1);
      });
    });

    group('"Dark mode" AppearanceSettingWidget', () {
      testWidgets(
          'isSelected when SharedPreferencesService.getThemeMode returns ThemeMode.dark',
          (tester) async {
        when(() => mockSharedPreferencesService.getThemeMode())
            .thenReturn(ThemeMode.dark);
        await tester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();

        final darkModeAppearanceSettingWidget =
            tester.widget<AppearanceSettingWidget>(
          find.byKey(const Key('dark_mode_appearance_setting_widget')),
        );
        expect(darkModeAppearanceSettingWidget.isSelected, isTrue);
      });

      testWidgets(
          'isSelected when SharedPreferencesService.getThemeMode returns ThemeMode.system and platformBrightness is Brightness.dark',
          (tester) async {
        when(() => mockSharedPreferencesService.getThemeMode())
            .thenReturn(ThemeMode.system);
        const mediaQueryData = MediaQueryData(
          platformBrightness: Brightness.dark,
        );
        await tester.pumpWidget(
          const MediaQuery(
            data: mediaQueryData,
            child: MaterialApp(
              home: SettingsPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final darkModeAppearanceSettingWidget =
            tester.widget<AppearanceSettingWidget>(
          find.byKey(const Key('dark_mode_appearance_setting_widget')),
        );
        expect(darkModeAppearanceSettingWidget.isSelected, isTrue);
      });

      testWidgets(
          'is not selected when SharedPreferencesService.getThemeMode returns ThemeMode.light',
          (tester) async {
        when(() => mockSharedPreferencesService.getThemeMode())
            .thenReturn(ThemeMode.light);
        await tester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();

        final darkModeAppearanceSettingWidget =
            tester.widget<AppearanceSettingWidget>(
          find.byKey(const Key('dark_mode_appearance_setting_widget')),
        );
        expect(darkModeAppearanceSettingWidget.isSelected, isFalse);
      });

      testWidgets(
          'is not selected when SharedPreferencesService.getThemeMode returns ThemeMode.system and platformBrightness is Brightness.light',
          (tester) async {
        when(() => mockSharedPreferencesService.getThemeMode())
            .thenReturn(ThemeMode.system);
        const mediaQueryData = MediaQueryData(
          platformBrightness: Brightness.light,
        );
        await tester.pumpWidget(
          const MediaQuery(
            data: mediaQueryData,
            child: MaterialApp(
              home: SettingsPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final darkModeAppearanceSettingWidget =
            tester.widget<AppearanceSettingWidget>(
          find.byKey(const Key('dark_mode_appearance_setting_widget')),
        );
        expect(darkModeAppearanceSettingWidget.isSelected, isFalse);
      });

      testWidgets(
          'invokes SharedPreferencesService.updateThemeMode with ThemeMode.dark when tapped',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();

        await tester
            .tap(find.byKey(const Key('dark_mode_appearance_setting_widget')));

        verify(() =>
                mockSharedPreferencesService.updateThemeMode(ThemeMode.dark))
            .called(1);
      });
    });

    group('"Automatic" Switch', () {});
  });
}
