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
            theme: _applyFontSizesTo(
              themeData: ThemeData.light().copyWith(
                dividerTheme: DividerThemeData(color: Colors.grey[600]),
                switchTheme: SwitchThemeData(
                  trackColor: WidgetStateProperty.all(Colors.grey[300]),
                  trackOutlineColor: WidgetStateProperty.all(Colors.grey[600]),
                ),
                listTileTheme: const ListTileThemeData(
                  titleTextStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  titleTextStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                ),
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.blue,
                  cardColor: Color.lerp(
                    Colors.white,
                    Colors.purple,
                    0.08,
                  ),
                ),
              ),
            ),
            darkTheme: _applyFontSizesTo(
              themeData: ThemeData.dark().copyWith(
                checkboxTheme: const CheckboxThemeData(
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                expansionTileTheme: const ExpansionTileThemeData(
                  textColor: Colors.white,
                  collapsedTextColor: Colors.white,
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                ),
                listTileTheme: const ListTileThemeData(
                  textColor: Colors.white,
                  titleTextStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  titleTextStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                ),
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.blue,
                  cardColor: Colors.grey[900],
                ),
              ),
            ),
            themeMode: themeMode,
          );
        },
      ),
    );
  }

  ThemeData _applyFontSizesTo({required ThemeData themeData}) {
    return themeData.copyWith(
      listTileTheme: themeData.listTileTheme.copyWith(minVerticalPadding: 0.0),
      textTheme: themeData.textTheme.copyWith(
        bodyMedium: TextStyle(
            fontSize: 18.0, color: themeData.textTheme.bodyMedium?.color),
      ),
    );
  }
}
