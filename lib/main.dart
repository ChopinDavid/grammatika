import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/screens/exercise_page.dart';

import 'database_bloc.dart';

void main() {
  GetIt.instance.registerSingleton<DbHelper>(DbHelper());
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
    return MaterialApp(
      home: BlocProvider<DatabaseBloc>(
        create: (context) =>
            DatabaseBloc()..add(DatabaseRetrieveExerciseEvent()),
        child: const ExercisePage(),
      ),
    );
  }
}
