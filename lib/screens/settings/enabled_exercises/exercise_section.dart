import 'package:get_it/get_it.dart';
import 'package:uchu/services/enabled_exercises_service.dart';

class ExerciseSection {
  const ExerciseSection({required this.title, this.subSections, this.exercises})
      : assert(subSections == null || exercises == null,
            'ExerciseSection cannot have both subSections and exercises');
  final String title;
  final List<ExerciseSection>? subSections;
  final List<(String, String)>? exercises;

  List<(String, String)> flattenExercises() {
    final exercises = this.exercises;
    final subSections = this.subSections;
    return [
      if (exercises != null) ...exercises,
      if (subSections != null)
        ...subSections.expand((subSection) => subSection.flattenExercises())
    ];
  }

  bool? subSectionsEnabled() {
    final flattenedExercises = flattenExercises();
    final flattenedExerciseIds = flattenedExercises.map((e) => e.$1).toList();
    final disabledSubSections =
        GetIt.instance.get<EnabledExercisesService>().getDisabledExercises();
    final disabledExerciseIds = disabledSubSections
        .where((element) => flattenedExerciseIds.contains(element))
        .toList();
    return disabledExerciseIds.isEmpty
        ? true
        : disabledExerciseIds.length == flattenedExerciseIds.length
            ? false
            : null;
  }
}
