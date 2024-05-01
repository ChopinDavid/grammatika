import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/models/word_form_type.dart';
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
            Word? word;
            Sentence? sentence;
            Answer? answer;

            if (state is ExerciseRandomNounRetrievedState) {
              word = state.word;
            }

            if (state is ExerciseRandomSentenceRetrievedState) {
              sentence = state.sentence;
            }

            if (state is ExerciseExerciseGradedState) {
              word = state.answer.word;
              answer = state.answer;
            }

            List<Widget> stackChildren = [];

            if ((state is ExerciseRandomNounRetrievedState ||
                    answer is Answer<Gender>) &&
                word != null) {
              stackChildren.add(
                GenderExerciseWidget(
                  word: word,
                ),
              );
            }

            if ((state is ExerciseRandomSentenceRetrievedState ||
                    answer is Answer<WordFormType>) &&
                sentence != null) {
              stackChildren.add(
                SentenceExerciseWidget(
                  sentence: sentence,
                ),
              );
            }

            if (state is ExerciseExerciseGradedState) {
              stackChildren.add(ExerciseFooter(
                explanation: state.answer.explanation,
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
