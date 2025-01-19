import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uchu/screens/exercise_page.dart';
import 'package:uchu/services/navigation_service.dart';
import 'package:uchu/services/shared_preferences_service.dart';
import 'package:uchu/services/translation_service.dart';
import 'package:uchu/utilities/db_helper.dart';
import 'package:uchu/utilities/explanation_helper.dart';
import 'package:uchu/utilities/url_helper.dart';

import 'blocs/exercise/exercise_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.instance.registerSingleton<DbHelper>(DbHelper());
  GetIt.instance.registerSingleton<ExplanationHelper>(ExplanationHelper());
  GetIt.instance.registerSingleton<UrlHelper>(const UrlHelper());
  GetIt.instance.registerSingleton<TranslationService>(TranslationService());
  GetIt.instance.registerSingleton<NavigationService>(NavigationService());
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  GetIt.instance.registerSingleton<SharedPreferencesService>(
      SharedPreferencesService(sharedPreferences: sharedPreferences));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.instance.get<SharedPreferencesService>(),
      child: Consumer<SharedPreferencesService>(
        builder: (context, sharedPreferencesService, child) {
          return MaterialApp(
            home: BlocProvider<ExerciseBloc>(
              create: (context) =>
                  ExerciseBloc()..add(ExerciseRetrieveExerciseEvent()),
              child: const ExercisePage(),
            ),
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: sharedPreferencesService.getThemeMode(),
          );
        },
      ),
    );
  }
}
