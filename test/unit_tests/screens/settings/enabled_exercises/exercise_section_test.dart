import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grammatika/screens/settings/enabled_exercises/exercise_section.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';

import '../../../mocks.dart';

main() {
  late EnabledExercisesService mockEnabledExercisesService;

  setUp(() async {
    await GetIt.instance.reset();

    mockEnabledExercisesService = MockEnabledExercisesService();

    GetIt.instance.registerSingleton<EnabledExercisesService>(
        mockEnabledExercisesService);
  });

  group('flatten exercises', () {
    test("returns all exercises when subSections is null", () {
      const ExerciseSection exerciseSection = ExerciseSection(
        title: 'title',
        exercises: [
          ('exercise1', 'id1'),
          ('exercise2', 'id2'),
        ],
      );
      expect(exerciseSection.flattenExercises(), [
        ('exercise1', 'id1'),
        ('exercise2', 'id2'),
      ]);
    });

    test(
        "returns a recursive list of all descendant subSections' exercises when subSections is not null",
        () {
      const ExerciseSection exerciseSection = ExerciseSection(
        title: 'title',
        subSections: [
          ExerciseSection(
            title: 'subSection1',
            exercises: [
              ('exercise1', 'id1'),
              ('exercise2', 'id2'),
            ],
          ),
          ExerciseSection(title: 'subSection2', subSections: [
            ExerciseSection(
              title: 'subSection3',
              exercises: [
                ('exercise3', 'id3'),
                ('exercise4', 'id4'),
              ],
            ),
          ]),
        ],
      );
      expect(exerciseSection.flattenExercises(), [
        ('exercise1', 'id1'),
        ('exercise2', 'id2'),
        ('exercise3', 'id3'),
        ('exercise4', 'id4'),
      ]);
    });
  });

  group('subSectionsEnabled', () {
    test("returns true when all descendant subSections' exercises are enabled",
        () {
      when(() => mockEnabledExercisesService.getDisabledExercises())
          .thenReturn([]);

      const ExerciseSection exerciseSection = ExerciseSection(
        title: 'title',
        subSections: [
          ExerciseSection(
            title: 'subSection1',
            exercises: [
              ('exercise1', 'id1'),
              ('exercise2', 'id2'),
            ],
          ),
          ExerciseSection(title: 'subSection2', subSections: [
            ExerciseSection(
              title: 'subSection3',
              exercises: [
                ('exercise3', 'id3'),
                ('exercise4', 'id4'),
              ],
            ),
          ]),
        ],
      );

      expect(exerciseSection.subSectionsEnabled(), true);
    });

    test(
        "returns false when all descendant subSections' exercises are disabled",
        () {
      const ExerciseSection exerciseSection = ExerciseSection(
        title: 'title',
        subSections: [
          ExerciseSection(
            title: 'subSection1',
            exercises: [
              ('exercise1', 'id1'),
              ('exercise2', 'id2'),
            ],
          ),
          ExerciseSection(title: 'subSection2', subSections: [
            ExerciseSection(
              title: 'subSection3',
              exercises: [
                ('exercise3', 'id3'),
                ('exercise4', 'id4'),
              ],
            ),
          ]),
        ],
      );

      when(() => mockEnabledExercisesService.getDisabledExercises())
          .thenReturn(exerciseSection
              .flattenExercises()
              .map(
                (e) => e.$1,
              )
              .toList());

      expect(exerciseSection.subSectionsEnabled(), false);
    });

    test(
        "returns null when some descendant subSections' exercises are disabled and some are enabled",
        () {
      const ExerciseSection exerciseSection = ExerciseSection(
        title: 'title',
        subSections: [
          ExerciseSection(
            title: 'subSection1',
            exercises: [
              ('exercise1', 'id1'),
              ('exercise2', 'id2'),
            ],
          ),
          ExerciseSection(title: 'subSection2', subSections: [
            ExerciseSection(
              title: 'subSection3',
              exercises: [
                ('exercise3', 'id3'),
                ('exercise4', 'id4'),
              ],
            ),
          ]),
        ],
      );

      var exercises = exerciseSection
          .flattenExercises()
          .map(
            (e) => e.$1,
          )
          .toList();
      exercises = exercises
          .where((exercise) => exercises.indexOf(exercise) % 2 == 0)
          .toList();

      when(() => mockEnabledExercisesService.getDisabledExercises())
          .thenReturn(exercises);

      expect(exerciseSection.subSectionsEnabled(), null);
    });
  });
}
