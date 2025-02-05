import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService with ChangeNotifier {
  SharedPreferencesService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  void updateThemeMode(ThemeMode themeMode) {
    _sharedPreferences.setInt(SharedPreferencesKeys.themeMode, themeMode.index);
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    return ThemeMode.values[
        _sharedPreferences.getInt(SharedPreferencesKeys.themeMode) ??
            ThemeMode.system.index];
  }

  bool getExerciseEnabled(String exerciseIdentifier) {
    return _sharedPreferences
            .getStringList(SharedPreferencesKeys.disabledExercises)
            ?.contains(exerciseIdentifier) !=
        true;
  }

  void toggleExerciseEnabled(String exerciseIdentifier) {
    var disabledExercises = _sharedPreferences
        .getStringList(SharedPreferencesKeys.disabledExercises);
    if (disabledExercises == null) {
      disabledExercises = [exerciseIdentifier];
    } else if (disabledExercises.contains(exerciseIdentifier)) {
      disabledExercises.remove(exerciseIdentifier);
    } else {
      disabledExercises.add(exerciseIdentifier);
    }

    _sharedPreferences.setStringList(
        SharedPreferencesKeys.disabledExercises, disabledExercises);
  }
}

@visibleForTesting
class SharedPreferencesKeys {
  static const String themeMode = 'theme_mode';
  static const String disabledExercises = 'disabled_exercises';
}
