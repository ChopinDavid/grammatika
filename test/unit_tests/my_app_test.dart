import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grammatika/blocs/exercise/exercise_bloc.dart';
import 'package:grammatika/my_app.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:grammatika/services/theme_service.dart';

import 'mocks.dart';

main() {
  late ExerciseBloc mockExerciseBloc;
  late SharedPreferences mockSharedPreferences;
  late ThemeService themeService;

  setUp(() async {
    await GetIt.instance.reset();

    mockExerciseBloc = MockExerciseBloc();
    whenListen(
      mockExerciseBloc,
      Stream.fromIterable(<ExerciseState>[]),
      initialState: ExerciseExerciseRetrievedState(),
    );

    mockSharedPreferences = MockSharedPreferences();
    when(() => mockSharedPreferences.setInt(any(), any()))
        .thenAnswer((_) async => true);

    themeService = ThemeService(sharedPreferences: mockSharedPreferences);
    GetIt.instance.registerSingleton<ThemeService>(themeService);
    GetIt.instance.registerSingleton<EnabledExercisesService>(
        MockEnabledExercisesService());
  });

  testWidgets(
    'ExerciseBloc.add(ExerciseRetrieveExerciseEvent) is called',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        MyApp(
          exerciseBloc: mockExerciseBloc,
        ),
      );
      await widgetTester.pump();
      await widgetTester.idle();

      verify(() => mockExerciseBloc.add(ExerciseRetrieveExerciseEvent()))
          .called(1);
    },
  );

  testWidgets(
    'Consumer<ThemeService> rebuilds on ThemeService.updateThemeMode',
    (WidgetTester tester) async {
      final List<int> getIntReturnValues = [
        ThemeMode.system.index,
        ThemeMode.light.index,
        ThemeMode.dark.index,
      ];
      when(() => mockSharedPreferences.getInt(any())).thenAnswer((_) {
        return getIntReturnValues.removeAt(0);
      });
      await tester.pumpWidget(
        MyApp(),
      );
      await tester.pump();
      await tester.idle();

      expect(find.byType(MyApp), findsOneWidget);
      final firstMaterialApp =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(firstMaterialApp.themeMode, ThemeMode.system);

      themeService.updateThemeMode(ThemeMode.light);
      await tester.pump();
      await tester.idle();

      final secondMaterialApp =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(secondMaterialApp.themeMode, ThemeMode.light);

      themeService.updateThemeMode(ThemeMode.dark);
      await tester.pump();
      await tester.idle();

      final thirdMaterialApp =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(thirdMaterialApp.themeMode, ThemeMode.dark);
    },
  );
}
