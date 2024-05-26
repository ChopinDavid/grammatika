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
              // TODO(DC): Write tests around this snack bar when implemented
              print(state.errorString);
            }
          },
          builder: (context, state) {
            if (state is ExerciseRetrievingExerciseState) {
              return const CircularProgressIndicator();
            }
            Exercise? exercise;

            if (state is ExerciseExerciseRetrievedState) {
              exercise = context.read<ExerciseBloc>().exercise;
            }

            if (state is ExerciseAnswerSelectedState) {
              exercise = context.read<ExerciseBloc>().exercise;
            }

            List<Widget> stackChildren = [];

            if (exercise?.type == ExerciseType.determineNounGender) {
              stackChildren.add(
                GenderExerciseWidget(
                  exercise: exercise as Exercise<Gender, Noun>,
                ),
              );
            }

            if (exercise?.type == ExerciseType.determineWordForm) {
              stackChildren.add(
                SentenceExerciseWidget(
                  exercise: exercise as Exercise<WordForm, Sentence>,
                ),
              );
            }

            if (state is ExerciseAnswerSelectedState) {
              stackChildren.add(ExerciseFooter(
                explanation:
                    context.read<ExerciseBloc>().exercise?.question.explanation,
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
