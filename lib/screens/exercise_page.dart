import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
            Word? word;

            if (state is ExerciseRandomNounRetrievedState) {
              word = state.word;
            }
            if (state is ExerciseExerciseGradedState) {
              word = state.answer.word;
            }
            if (word != null) {
              return GenderExerciseWidget(
                word: word,
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
