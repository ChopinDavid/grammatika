import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/up_and_right_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/vertical_and_right_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/box_drawing_character_widgets/vertical_box_drawing_character_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/exercise_cell.dart';
import 'package:grammatika/screens/settings/enabled_exercises/exercise_section.dart';
import 'package:grammatika/screens/settings/enabled_exercises/section_widget.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';

import '../../../mocks.dart';

main() {
  late ExerciseSection mockExerciseSection;
  late EnabledExercisesService mockEnabledExercisesService;

  setUp(() async {
    await GetIt.instance.reset();

    mockExerciseSection = MockExerciseSection();
    mockEnabledExercisesService = MockEnabledExercisesService();

    when(() => mockExerciseSection.title).thenReturn('some title');
    when(() => mockExerciseSection.subSections).thenReturn([]);
    when(() => mockExerciseSection.flattenExercises()).thenReturn([]);

    GetIt.instance.registerSingleton<EnabledExercisesService>(
        mockEnabledExercisesService);
  });

  group('Arrow Icon', () {
    testWidgets(
        'is arrow_drop_up when isFirstBuild is false and controller is expanded',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(ExpansionTile));
      await widgetTester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
    });

    testWidgets('is arrow_drop_down when controller is not expanded',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_drop_up), findsNothing);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });
  });

  group('Checkbox', () {
    for (var expectedSubSectionsEnabled in <bool?>[true, false, null]) {
      testWidgets(
          'has correct value when section.subSectionsEnabled is $expectedSubSectionsEnabled',
          (widgetTester) async {
        when(() => mockExerciseSection.subSectionsEnabled())
            .thenReturn(expectedSubSectionsEnabled);

        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionWidget(
                section: mockExerciseSection,
                isLastSubSection: true,
                sectionHasCheckBoxBuilder: (_) => true,
              ),
            ),
          ),
        );

        await widgetTester.pumpAndSettle();

        expect(widgetTester.widget<Checkbox>(find.byType(Checkbox)).value,
            expectedSubSectionsEnabled);
      });
    }

    testWidgets('is not shown when sectionHasCheckBoxBuilder is null',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
              sectionHasCheckBoxBuilder: null,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      expect(find.byType(Checkbox), findsNothing);
    });

    testWidgets('is not shown when sectionHasCheckBoxBuilder returns false',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
              sectionHasCheckBoxBuilder: (_) => false,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      expect(find.byType(Checkbox), findsNothing);
    });

    testWidgets(
        'invokes EnabledExercisesService.addDisabledExercises, passing all exercise ids from section.flattenExercises, when tapped and value is initially true',
        (widgetTester) async {
      final exercises = [
        ('A1', 'a1'),
        ('A2', 'a2'),
        ('C1', 'c1'),
      ];
      when(() => mockExerciseSection.subSectionsEnabled()).thenReturn(true);
      when(() => mockExerciseSection.flattenExercises()).thenReturn(exercises);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
              sectionHasCheckBoxBuilder: (_) => true,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(Checkbox));
      await widgetTester.pumpAndSettle();

      verify(() => mockEnabledExercisesService.addDisabledExercises(exercises
          .map(
            (e) => e.$1,
          )
          .toList()));
    });

    testWidgets(
        'invokes EnabledExercisesService.removeDisabledExercises, passing all exercise ids from section.flattenExercises, when tapped and value is initially false',
        (widgetTester) async {
      final exercises = [
        ('A1', 'a1'),
        ('A2', 'a2'),
        ('C1', 'c1'),
      ];
      when(() => mockExerciseSection.subSectionsEnabled()).thenReturn(false);
      when(() => mockExerciseSection.flattenExercises()).thenReturn(exercises);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
              sectionHasCheckBoxBuilder: (_) => true,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(Checkbox));
      await widgetTester.pumpAndSettle();

      verify(() => mockEnabledExercisesService.removeDisabledExercises(exercises
          .map(
            (e) => e.$1,
          )
          .toList()));
    });

    testWidgets(
        'invokes EnabledExercisesService.addDisabledExercises, passing all exercise ids from section.flattenExercises, when tapped and value is initially null',
        (widgetTester) async {
      final exercises = [
        ('A1', 'a1'),
        ('A2', 'a2'),
        ('C1', 'c1'),
      ];
      when(() => mockExerciseSection.subSectionsEnabled()).thenReturn(null);
      when(() => mockExerciseSection.flattenExercises()).thenReturn(exercises);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
              sectionHasCheckBoxBuilder: (_) => true,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(Checkbox));
      await widgetTester.pumpAndSettle();

      verify(() => mockEnabledExercisesService.addDisabledExercises(exercises
          .map(
            (e) => e.$1,
          )
          .toList()));
    });

    testWidgets('value becomes false when tapped and value is initially true',
        (widgetTester) async {
      const expectedInitialValue = true;
      const expectedFinalValue = false;
      when(() => mockExerciseSection.subSectionsEnabled())
          .thenReturn(expectedInitialValue);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
              sectionHasCheckBoxBuilder: (_) => true,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final checkboxFinder = find.byType(Checkbox);
      expect(widgetTester.widget<Checkbox>(checkboxFinder).value,
          expectedInitialValue);
      await widgetTester.tap(checkboxFinder);
      await widgetTester.pumpAndSettle();

      expect(widgetTester.widget<Checkbox>(checkboxFinder).value,
          expectedFinalValue);
    });

    testWidgets('value becomes true when tapped and value is initially false',
        (widgetTester) async {
      const expectedInitialValue = false;
      const expectedFinalValue = true;
      when(() => mockExerciseSection.subSectionsEnabled())
          .thenReturn(expectedInitialValue);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
              sectionHasCheckBoxBuilder: (_) => true,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final checkboxFinder = find.byType(Checkbox);
      expect(widgetTester.widget<Checkbox>(checkboxFinder).value,
          expectedInitialValue);
      await widgetTester.tap(checkboxFinder);
      await widgetTester.pumpAndSettle();

      expect(widgetTester.widget<Checkbox>(checkboxFinder).value,
          expectedFinalValue);
    });

    testWidgets('value becomes false when tapped and value is initially null',
        (widgetTester) async {
      const expectedInitialValue = null;
      const expectedFinalValue = false;
      when(() => mockExerciseSection.subSectionsEnabled())
          .thenReturn(expectedInitialValue);

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionWidget(
              section: mockExerciseSection,
              isLastSubSection: true,
              sectionHasCheckBoxBuilder: (_) => true,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final checkboxFinder = find.byType(Checkbox);
      expect(widgetTester.widget<Checkbox>(checkboxFinder).value,
          expectedInitialValue);
      await widgetTester.tap(checkboxFinder);
      await widgetTester.pumpAndSettle();

      expect(widgetTester.widget<Checkbox>(checkboxFinder).value,
          expectedFinalValue);
    });
  });

  group('BoxDrawingCharacterWidgets', () {
    testWidgets(
      'displays depth - 1 VerticalBoxDrawingCharacterWidgets and one UpAndRightBoxDrawingCharacterWidget when isLastSubSection and controller is not expanded',
      (widgetTester) async {
        const depth = 8;

        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionWidget(
                section: mockExerciseSection,
                isLastSubSection: true,
                sectionHasCheckBoxBuilder: (_) => true,
                depth: depth,
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
      'displays depth - 1 VerticalBoxDrawingCharacterWidgets and one VerticalAndRightBoxDrawingCharacterWidget when isLastSubSection and controller is expanded',
      (widgetTester) async {
        const depth = 8;

        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionWidget(
                section: mockExerciseSection,
                isLastSubSection: true,
                sectionHasCheckBoxBuilder: (_) => true,
                depth: depth,
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.byType(ExpansionTile));
        await widgetTester.pumpAndSettle();

        expect(find.byType(VerticalBoxDrawingCharacterWidget),
            findsNWidgets(depth - 1));
        expect(find.byType(UpAndRightBoxDrawingCharacterWidget), findsNothing);
        expect(find.byType(VerticalAndRightBoxDrawingCharacterWidget),
            findsOneWidget);
      },
    );

    testWidgets(
      'displays depth - 1 VerticalBoxDrawingCharacterWidgets and one VerticalAndRightBoxDrawingCharacterWidget when isLastSubSection is false and controller is not expanded',
      (widgetTester) async {
        const depth = 8;

        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionWidget(
                section: mockExerciseSection,
                isLastSubSection: false,
                sectionHasCheckBoxBuilder: (_) => true,
                depth: depth,
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();

        expect(find.byType(VerticalBoxDrawingCharacterWidget),
            findsNWidgets(depth - 1));
        expect(find.byType(UpAndRightBoxDrawingCharacterWidget), findsNothing);
        expect(find.byType(VerticalAndRightBoxDrawingCharacterWidget),
            findsOneWidget);
      },
    );
  });

  group('children', () {
    testWidgets(
      'maps all subSections to SectionWidgets with correct depth and isLastSubSection values when subSections is not null',
      (widgetTester) async {
        const originalDepth = 3;
        final subSections = List.generate(
          8,
          (index) => ExerciseSection(
            title: '$index',
            exercises: [],
          ),
        );
        when(() => mockExerciseSection.subSections).thenReturn(subSections);

        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionWidget(
                section: mockExerciseSection,
                isLastSubSection: false,
                sectionHasCheckBoxBuilder: (_) => true,
                depth: originalDepth,
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        await widgetTester.tap(find.byType(ExpansionTile));
        await widgetTester.pumpAndSettle();

        expect(
            find.byType(SectionWidget), findsNWidgets(subSections.length + 1));
        for (var i = 0; i < subSections.length; i++) {
          final sectionWidgetFinder = find.byWidgetPredicate((widget) =>
              widget is SectionWidget && widget.section == subSections[i]);
          expect(sectionWidgetFinder, findsOneWidget);
          expect(widgetTester.widget<SectionWidget>(sectionWidgetFinder).depth,
              originalDepth + 1);
          expect(
              widgetTester
                  .widget<SectionWidget>(sectionWidgetFinder)
                  .isLastSubSection,
              i == subSections.length - 1);
        }
      },
    );

    testWidgets(
      'maps all exercises to ExerciseCells with correct depth and isLastExerciseInList values when exercises is not null',
      (widgetTester) async {
        const originalDepth = 3;
        final exercises = List.generate(
          8,
          (index) => ('$index', '$index'),
        );
        when(() => mockExerciseSection.subSections).thenReturn(null);
        when(() => mockExerciseSection.exercises).thenReturn(exercises);

        await widgetTester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionWidget(
                section: mockExerciseSection,
                isLastSubSection: false,
                sectionHasCheckBoxBuilder: (_) => true,
                depth: originalDepth,
              ),
            ),
          ),
        );
        await widgetTester.pumpAndSettle();
        await widgetTester.tap(find.byType(ExpansionTile));
        await widgetTester.pumpAndSettle();

        expect(find.byType(ExerciseCell), findsNWidgets(exercises.length));
        for (var i = 0; i < exercises.length; i++) {
          final exerciseCellFinder = find.byWidgetPredicate((widget) =>
              widget is ExerciseCell && widget.exercise == exercises[i]);
          expect(exerciseCellFinder, findsOneWidget);
          expect(widgetTester.widget<ExerciseCell>(exerciseCellFinder).depth,
              originalDepth + 1);
          expect(
              widgetTester
                  .widget<ExerciseCell>(exerciseCellFinder)
                  .isLastExerciseInList,
              i == exercises.length - 1);
        }
      },
    );
  });
}
