import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uchu/consts.dart';

class EnabledExercisesService with ChangeNotifier {
  EnabledExercisesService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  List<String> getDisabledExercises() {
    return _sharedPreferences
            .getStringList(disabledExercisesSharedPreferencesKey) ??
        [];
  }

  bool getExerciseEnabled(String exerciseIdentifier) {
    return _sharedPreferences
            .getStringList(disabledExercisesSharedPreferencesKey)
            ?.contains(exerciseIdentifier) !=
        true;
  }

  void addDisabledExercises(List<String> exerciseIds) {
    var disabledExercises = getDisabledExercises();
    disabledExercises.addAll(exerciseIds);
    disabledExercises = disabledExercises.toSet().toList();
    _sharedPreferences.setStringList(
        disabledExercisesSharedPreferencesKey, disabledExercises);
    notifyListeners();
  }

  void removeDisabledExercises(List<String> exerciseIds) {
    final disabledExercises = getDisabledExercises();
    disabledExercises.removeWhere(
      (element) => exerciseIds.contains(element),
    );
    _sharedPreferences.setStringList(
        disabledExercisesSharedPreferencesKey, disabledExercises);
    notifyListeners();
  }

  void toggleExerciseEnabled(String exerciseIdentifier) {
    var disabledExercises =
        _sharedPreferences.getStringList(disabledExercisesSharedPreferencesKey);
    if (disabledExercises == null) {
      disabledExercises = [exerciseIdentifier];
    } else if (disabledExercises.contains(exerciseIdentifier)) {
      disabledExercises.remove(exerciseIdentifier);
    } else {
      disabledExercises.add(exerciseIdentifier);
    }

    _sharedPreferences.setStringList(
        disabledExercisesSharedPreferencesKey, disabledExercises);
    notifyListeners();
  }
}
