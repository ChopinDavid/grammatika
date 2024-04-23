import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/widgets/exercise_footer.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<ExerciseBloc, ExerciseState>(
          listener: (context, state) {
            if (state is ExerciseErrorState) {
              // TODO(DC): Make it so that we show an error snack bar and show previous answer/exercise
            }
          },
          builder: (context, state) {
            Word? word;
            Answer? answer;

            if (state is ExerciseRandomNounRetrievedState) {
              word = state.word;
            }
            if (state is ExerciseExerciseGradedState) {
              word = state.answer.word;
              answer = state.answer;
            }
            if (word != null) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (state is ExerciseRandomNounRetrievedState ||
                      answer is Answer<Gender>)
                    GenderExerciseWidget(
                      word: word,
                    ),
                  if (state is ExerciseExerciseGradedState)
                    ExerciseFooter(
                      explanation: state.answer.explanation,
                    ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
