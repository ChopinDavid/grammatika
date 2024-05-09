import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/widgets/exercise_footer.dart';
import 'package:uchu/widgets/gender_exercise_widget.dart';
import 'package:uchu/widgets/sentence_exercise_widget.dart';

import '../models/sentence.dart';

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
              print(state.errorString);
            }
          },
          builder: (context, state) {
            if (state is ExerciseRetrievingExerciseState) {
              return const CircularProgressIndicator();
            }
            Exercise? exercise;

            if (state is ExerciseQuestionRetrievedState) {
              exercise = state.exercise;
            }

            if (state is ExerciseAnswerSelectedState) {
              exercise = state.exercise;
            }

            List<Widget> stackChildren = [];

            if (exercise is Exercise<Gender, Noun>) {
              stackChildren.add(
                GenderExerciseWidget(
                  answer: exercise,
                ),
              );
            }

            if (exercise is Exercise<WordForm, Sentence>) {
              stackChildren.add(
                SentenceExerciseWidget(
                  answer: exercise,
                ),
              );
            }

            if (state is ExerciseAnswerSelectedState) {
              stackChildren.add(ExerciseFooter(
                explanation: state.exercise.question.explanation,
              ));
            }

            if (stackChildren.isNotEmpty) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: stackChildren,
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
