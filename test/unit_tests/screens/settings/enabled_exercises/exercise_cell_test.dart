import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/up_and_right_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/vertical_and_right_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/vertical_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/exercise_cell.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';

import '../../../mocks.dart';

main() {
  late EnabledExercisesService mockEnabledExercisesService;
  setUp(() async {
    await GetIt.instance.reset();

    mockEnabledExercisesService = MockEnabledExercisesService();

    GetIt.instance.registerSingleton<EnabledExercisesService>(
      mockEnabledExercisesService,
    );
  });

  testWidgets(
    'displays second value of passed exercise record',
    (widgetTester) async {
      const expectedTitle = 'Gerund';
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseCell(
              exercise: ('gerund', expectedTitle),
              depth: 1,
              isLastExerciseInList: false,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      expect(find.text(expectedTitle), findsOneWidget);
    },
  );

  testWidgets(
    'invokes EnabledExercisesService.toggleExerciseEnabled with first value of exercise record when tapped',
    (widgetTester) async {
      const exerciseId = 'm';
      when(() => GetIt.instance
          .get<EnabledExercisesService>()
          .getExerciseEnabled(exerciseId)).thenReturn(false);

      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseCell(
              exercise: (exerciseId, 'Male'),
              depth: 2,
              isLastExerciseInList: false,
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(ExerciseCell));
      await widgetTester.pumpAndSettle();

      verify(() =>
              mockEnabledExercisesService.toggleExerciseEnabled(exerciseId))
          .called(1);
    },
  );

  testWidgets(
    'toggles checkbox isEnabled when EnabledExercisesService notifies listeners',
    (widgetTester) async {
      await GetIt.instance.reset();

      const exerciseId = 'm';

      final mockSharedPreferences = MockSharedPreferences();
      final List<List<String>> disabledExercisesReturnValues = [
        [exerciseId],
        [],
        [exerciseId]
      ];

      when(() => mockSharedPreferences
              .getStringList(disabledExercisesSharedPreferencesKey))
          .thenAnswer((_) => disabledExercisesReturnValues.removeAt(0));
      final enabledExercisesService =
          EnabledExercisesService(sharedPreferences: mockSharedPreferences);
      GetIt.instance
          .registerSingleton<EnabledExercisesService>(enabledExercisesService);

      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseCell(
              exercise: (exerciseId, 'Male'),
              depth: 2,
              isLastExerciseInList: false,
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();

      expect(
          widgetTester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);

      enabledExercisesService.notifyListeners();
      await widgetTester.pumpAndSettle();

      expect(
          widgetTester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);

      enabledExercisesService.notifyListeners();
      await widgetTester.pumpAndSettle();

      expect(
          widgetTester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    },
  );

  group(
    'BoxDrawingCharacterWidgets',
    () {
      testWidgets(
        'displays depth - 1 VerticalBoxDrawingCharacterWidget and one UpAndRightBoxDrawingCharacterWidget when isLastExerciseInList is true',
        (widgetTester) async {
          const depth = 8;
          await widgetTester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ExerciseCell(
                  exercise: ('m', 'Male'),
                  depth: depth,
                  isLastExerciseInList: true,
                ),
              ),
            ),
          );
          await widgetTester.pumpAndSettle();

          expect(find.byType(VerticalBoxDrawingCharacterWidget),
              findsNWidgets(depth - 1));
          expect(
              find.byType(UpAndRightBoxDrawingCharacterWidget), findsOneWidget);
          expect(find.byType(VerticalAndRightBoxDrawingCharacterWidget),
              findsNothing);
        },
      );

      testWidgets(
        'displays depth - 1 VerticalBoxDrawingCharacterWidget and one VerticalAndRightBoxDrawingCharacterWidget when isLastExerciseInList is false',
        (widgetTester) async {
          const depth = 8;
          await widgetTester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ExerciseCell(
                  exercise: ('m', 'Male'),
                  depth: depth,
                  isLastExerciseInList: false,
                ),
              ),
            ),
          );
          await widgetTester.pumpAndSettle();

          expect(find.byType(VerticalBoxDrawingCharacterWidget),
              findsNWidgets(depth - 1));
          expect(
              find.byType(UpAndRightBoxDrawingCharacterWidget), findsNothing);
          expect(find.byType(VerticalAndRightBoxDrawingCharacterWidget),
              findsOneWidget);
        },
      );
    },
  );

  group('checkbox', () {
    testWidgets(
      'is initially checked when EnabledExercisesService.getExerciseEnabled returns true',
      (widgetTester) async {
        const exerciseId = 'm';
        when(() => GetIt.instance
            .get<EnabledExercisesService>()
            .getExerciseEnabled(exerciseId)).thenReturn(true);

        await widgetTester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ExerciseCell(
                exercise: (exerciseId, 'Male'),
                depth: 2,
                isLastExerciseInList: false,
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(
            widgetTester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      },
    );

    testWidgets(
      'is not initially checked when EnabledExercisesService.getExerciseEnabled returns false',
      (widgetTester) async {
        const exerciseId = 'm';
        when(() => GetIt.instance
            .get<EnabledExercisesService>()
            .getExerciseEnabled(exerciseId)).thenReturn(false);

        await widgetTester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ExerciseCell(
                exercise: (exerciseId, 'Male'),
                depth: 2,
                isLastExerciseInList: false,
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(
            widgetTester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      },
    );
  });
}
