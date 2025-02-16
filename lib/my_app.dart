import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/screens/exercise_page.dart';
import 'package:grammatika/services/theme_service.dart';
import 'package:provider/provider.dart';

import 'blocs/exercise/exercise_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key, @visibleForTesting ExerciseBloc? exerciseBloc})
      : _exerciseBloc = exerciseBloc ?? ExerciseBloc() {
    _exerciseBloc.add(ExerciseRetrieveExerciseEvent());
  }

  final ExerciseBloc _exerciseBloc;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.instance.get<ThemeService>(),
      child: Consumer<ThemeService>(
        builder: (context, sharedPreferencesService, child) {
          final themeMode = sharedPreferencesService.getThemeMode();
          return MaterialApp(
            home: BlocProvider<ExerciseBloc>.value(
              value: _exerciseBloc,
              child: const ExercisePage(),
            ),
            theme: _applyFontSizesTo(themeData: ThemeData.light()),
            darkTheme: _applyFontSizesTo(themeData: ThemeData.dark()),
            themeMode: themeMode,
          );
        },
      ),
    );
  }

  ThemeData _applyFontSizesTo({required ThemeData themeData}) {
    return themeData.copyWith(
      listTileTheme: const ListTileThemeData(minVerticalPadding: 0.0),
      textTheme: themeData.textTheme.copyWith(
        bodyMedium: TextStyle(
            fontSize: 18.0, color: themeData.textTheme.bodyMedium?.color),
      ),
    );
  }
}
