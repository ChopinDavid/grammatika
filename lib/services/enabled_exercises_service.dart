import 'package:grammatika/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnabledExercisesService {
  EnabledExercisesService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  void setEnabledExercises(List<String> exerciseIds) {
    _sharedPreferences.setStringList(
        enabledExercisesSharedPreferencesKey, exerciseIds);
  }

  List<String> getEnabledExercises() {
    return _sharedPreferences
            .getStringList(enabledExercisesSharedPreferencesKey) ??
        getAllExerciseIds();
  }

  List<String> getDisabledExercises() {
    final enabledExercises = getEnabledExercises();
    return getAllExerciseIds()
        .where((exerciseId) => !enabledExercises.contains(exerciseId))
        .toList();
  }
}
