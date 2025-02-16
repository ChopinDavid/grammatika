import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grammatika/screens/settings/settings_page.dart';
import 'package:grammatika/screens/statistics/statistics_page.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:grammatika/services/navigation_service.dart';
import 'package:grammatika/services/statistics_service.dart';
import 'package:grammatika/services/theme_service.dart';

import '../mocks.dart';

void main() {
  late NavigationService testObject;
  late ThemeService mockSharedPreferencesService;

  setUp(() async {
    await GetIt.instance.reset();

    testObject = NavigationService();

    mockSharedPreferencesService = MockThemeService();

    when(() => mockSharedPreferencesService.getThemeMode())
        .thenReturn(ThemeMode.system);

    GetIt.instance
        .registerSingleton<ThemeService>(mockSharedPreferencesService);
    GetIt.instance.registerSingleton<EnabledExercisesService>(
        MockEnabledExercisesService());
    GetIt.instance
        .registerSingleton<StatisticsService>(MockStatisticsService());
  });

  group('pushSettingsPage', () {
    testWidgets('navigates to SettingsPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    testObject.pushSettingsPage(context);
                  },
                  child: const Text('Navigate to Settings'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(SettingsPage), findsNothing);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
    });
  });

  group('pushStatisticsPage', () {
    testWidgets('navigates to StatisticsPage', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  testObject.pushStatisticsPage(context);
                },
                child: const Text('Navigate to Statistics'),
              );
            },
          ),
        ),
      ));

      expect(find.byType(StatisticsPage), findsNothing);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(StatisticsPage), findsOneWidget);
    });
  });
}
