import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/screens/settings/enabled_exercises/exercise_section.dart';
import 'package:uchu/screens/settings/enabled_exercises/exercise_sections_widget.dart';
import 'package:uchu/screens/settings/enabled_exercises/section_widget.dart';
import 'package:uchu/services/enabled_exercises_service.dart';

import '../../../mocks.dart';

main() {
  setUp(() async {
    await GetIt.instance.reset();

    GetIt.instance.registerSingleton<EnabledExercisesService>(
        MockEnabledExercisesService());
  });

  testWidgets(
      'builds a SectionWidget for each ExerciseSection passed in the constructor',
      (widgetTester) async {
    const expectedSectionWidgetCount = 5;
    final sections = List.generate(
      expectedSectionWidgetCount,
      (index) => ExerciseSection(
        title: '$index',
        exercises: [],
      ),
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExerciseSectionsWidget(
            sections: sections,
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    final sectionWidgetFinder = find.byType(SectionWidget);
    expect(sectionWidgetFinder, findsNWidgets(expectedSectionWidgetCount));
    final sectionWidgets =
        widgetTester.widgetList<SectionWidget>(sectionWidgetFinder).toList();
    for (var i = 0; i < expectedSectionWidgetCount; i++) {
      expect(find.text('$i'), findsOneWidget);
      expect(sectionWidgets[i].section, sections[i]);
    }
  });

  testWidgets(
    'only last SectionWidget is isLastSubsection true',
    (widgetTester) async {
      final sections = List.generate(
        5,
        (index) => ExerciseSection(
          title: '$index',
          exercises: [],
        ),
      );
      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseSectionsWidget(
              sections: sections,
            ),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final sectionWidgetFinder = find.byType(SectionWidget);
      final sectionWidgets =
          widgetTester.widgetList<SectionWidget>(sectionWidgetFinder).toList();

      for (var i = 0; i < 5; i++) {
        expect(sectionWidgets[i].isLastSubSection, i == sections.length - 1);
      }
    },
  );
}
