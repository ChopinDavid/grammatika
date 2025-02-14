import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uchu/services/enabled_exercises_service.dart';
import 'package:uchu/services/navigation_service.dart';
import 'package:uchu/services/statistics_service.dart';
import 'package:uchu/services/theme_service.dart';
import 'package:uchu/services/translation_service.dart';
import 'package:uchu/utilities/db_helper.dart';
import 'package:uchu/utilities/explanation_helper.dart';
import 'package:uchu/utilities/url_helper.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.instance.registerSingleton<DbHelper>(DbHelper());
  GetIt.instance.registerSingleton<ExplanationHelper>(ExplanationHelper());
  GetIt.instance.registerSingleton<UrlHelper>(const UrlHelper());
  GetIt.instance.registerSingleton<TranslationService>(TranslationService());
  GetIt.instance.registerSingleton<NavigationService>(NavigationService());
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  GetIt.instance.registerSingleton<ThemeService>(
      ThemeService(sharedPreferences: sharedPreferences));
  GetIt.instance.registerSingleton<EnabledExercisesService>(
      EnabledExercisesService(sharedPreferences: sharedPreferences));
  GetIt.instance.registerSingleton<StatisticsService>(StatisticsService());

  runApp(MyApp());
}
