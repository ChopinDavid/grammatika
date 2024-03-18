import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    getDatabasesPath().then((value) {
      print(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: BlocBuilder<DatabaseBloc, DatabaseState>(
          bloc: DatabaseBloc()
            ..add(DatabaseQueryEvent(
                query: "SELECT * FROM nouns ORDER BY RANDOM() LIMIT 1;")),
          builder: (context, state) {
            if (state is DatabaseQueryCompleteState) {
              return Text('complete');
            }
            return CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}
