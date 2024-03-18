import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'database_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseBloc databaseBloc = DatabaseBloc()
    ..add(DatabaseRetrieveExerciseEvent());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: BlocBuilder<DatabaseBloc, DatabaseState>(
          bloc: databaseBloc,
          builder: (context, state) {
            if (state is DatabaseRandomNounRetrievedState) {
              return Text('What is the gender of: «${state.word.bare}»?');
            }
            return CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}
