import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/database_bloc.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<DatabaseBloc, DatabaseState>(
          builder: (context, state) {
            if (state is DatabaseRandomNounRetrievedState) {
              return Text('What is the gender of: «${state.word.bare}»?');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
