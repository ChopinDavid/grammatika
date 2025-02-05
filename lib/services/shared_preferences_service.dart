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
    return _sharedPreferences.getBool(exerciseIdentifier) ?? true;
  }

  void toggleExerciseEnabled(String exerciseIdentifier) {
    final currentValue = getExerciseEnabled(exerciseIdentifier);
    _sharedPreferences.setBool(exerciseIdentifier, !currentValue);
  }
}

@visibleForTesting
class SharedPreferencesKeys {
  static const String themeMode = 'theme_mode';
}
