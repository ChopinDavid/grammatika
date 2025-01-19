import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService with ChangeNotifier {
  SharedPreferencesService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  void updateThemeMode(ThemeMode themeMode) {
    _sharedPreferences.setInt(
        _SharedPreferencesKeys.themeMode, themeMode.index);
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    return ThemeMode.values[
        _sharedPreferences.getInt(_SharedPreferencesKeys.themeMode) ??
            ThemeMode.system.index];
  }
}

class _SharedPreferencesKeys {
  static const String themeMode = 'theme_mode';
}
