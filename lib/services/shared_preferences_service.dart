import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uchu/models/word_form_type.dart';

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

  bool getWordFormTypeEnabled(WordFormType type) {
    return _sharedPreferences.getBool(type.name) ?? true;
  }

  void toggleWordFormTypeEnabled(WordFormType type) {
    final currentValue = getWordFormTypeEnabled(type);
    _sharedPreferences.setBool(type.name, !currentValue);
  }
}

@visibleForTesting
class SharedPreferencesKeys {
  static const String themeMode = 'theme_mode';
}
