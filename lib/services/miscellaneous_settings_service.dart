import 'dart:convert';

import 'package:grammatika/consts.dart';
import 'package:grammatika/models/miscellaneous_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiscellaneousSettingsService {
  MiscellaneousSettingsService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  void updateSettings(MiscellaneousSettings settings) {
    _sharedPreferences.setString(
        miscellaneousSettingsPreferencesKey, jsonEncode(settings.toJson()));
  }

  MiscellaneousSettings getSettings() {
    var json = _sharedPreferences.getString('miscellaneousSettings');
    if (json == null) {
      return MiscellaneousSettings.defaultSettings();
    }
    return MiscellaneousSettings.fromJson(
        Map<String, dynamic>.from(jsonDecode(json)));
  }
}
