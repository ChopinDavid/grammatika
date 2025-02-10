import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/screens/settings/appearance_setting_widget.dart';
import 'package:uchu/screens/settings/settings_page.dart';
import 'package:uchu/services/enabled_exercises_service.dart';
import 'package:uchu/services/theme_service.dart';

import '../../mocks.dart';

main() {
  late ThemeService mockThemeService;
  late EnabledExercisesService mockEnabledExercisesService;

  setUp(() async {
    await GetIt.instance.reset();

    mockThemeService = MockThemeService();
    mockEnabledExercisesService = MockEnabledExercisesService();

    when(() => mockThemeService.getThemeMode()).thenReturn(ThemeMode.system);
    GetIt.instance.registerSingleton<ThemeService>(
      mockThemeService,
    );
    GetIt.instance.registerSingleton<EnabledExercisesService>(
        mockEnabledExercisesService);
  });
  group('appearance section', () {
    group('"Light mode" AppearanceSettingWidget', () {
      testWidgets(
          'isSelected when ThemeService.getThemeMode returns ThemeMode.light',
          (tester) async {
        when(() => mockThemeService.getThemeMode()).thenReturn(ThemeMode.light);
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
          'isSelected when ThemeService.getThemeMode returns ThemeMode.system and platformBrightness is Brightness.light',
          (tester) async {
        when(() => mockThemeService.getThemeMode())
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
          'is not selected when ThemeService.getThemeMode returns ThemeMode.dark',
          (tester) async {
        when(() => mockThemeService.getThemeMode()).thenReturn(ThemeMode.dark);
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
          'is not selected when ThemeService.getThemeMode returns ThemeMode.system and platformBrightness is Brightness.dark',
          (tester) async {
        when(() => mockThemeService.getThemeMode())
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
          'invokes ThemeService.updateThemeMode with ThemeMode.light when tapped',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();

        await tester
            .tap(find.byKey(const Key('light_mode_appearance_setting_widget')));

        verify(() => mockThemeService.updateThemeMode(ThemeMode.light))
            .called(1);
      });
    });

    group('"Dark mode" AppearanceSettingWidget', () {
      testWidgets(
          'isSelected when ThemeService.getThemeMode returns ThemeMode.dark',
          (tester) async {
        when(() => mockThemeService.getThemeMode()).thenReturn(ThemeMode.dark);
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
          'isSelected when ThemeService.getThemeMode returns ThemeMode.system and platformBrightness is Brightness.dark',
          (tester) async {
        when(() => mockThemeService.getThemeMode())
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
          'is not selected when ThemeService.getThemeMode returns ThemeMode.light',
          (tester) async {
        when(() => mockThemeService.getThemeMode()).thenReturn(ThemeMode.light);
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
          'is not selected when ThemeService.getThemeMode returns ThemeMode.system and platformBrightness is Brightness.light',
          (tester) async {
        when(() => mockThemeService.getThemeMode())
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
          'invokes ThemeService.updateThemeMode with ThemeMode.dark when tapped',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();

        await tester
            .tap(find.byKey(const Key('dark_mode_appearance_setting_widget')));

        verify(() => mockThemeService.updateThemeMode(ThemeMode.dark))
            .called(1);
      });
    });

    group('"Automatic" Switch', () {});
  });

  group('Enabled Exercises section', () {
    testWidgets(
      'displays "Enabled Exercises", "Inflection", and "Identifying Gender"',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          const MaterialApp(
            home: SettingsPage(),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(find.text('Enabled Exercises'), findsOneWidget);
        expect(find.text('Inflection'), findsOneWidget);
        expect(find.text('Identifying Gender'), findsOneWidget);
      },
    );
  });
}
