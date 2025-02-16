import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grammatika/blocs/exercise/exercise_bloc.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/widgets/explanations_widget.dart';
import 'package:grammatika/widgets/gender_exercise_widget.dart';
import 'package:grammatika/widgets/grammatika_drawer.dart';
import 'package:grammatika/widgets/sentence_exercise_widget.dart';

import '../models/sentence.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const GrammatikaDrawer(),
      appBar: AppBar(
        title: const Text('Grammatika'),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
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

              List<Widget> children = [];

              if (exercise?.type == ExerciseType.determineNounGender) {
                children.add(
                  GenderExerciseWidget(
                    exercise: exercise as Exercise<Gender, Noun>,
                    isAnswered: state is ExerciseAnswerSelectedState,
                  ),
                );
              }

              if (exercise?.type == ExerciseType.determineWordForm) {
                children.add(
                  SentenceExerciseWidget(
                    exercise: exercise as Exercise<WordForm, Sentence>,
                  ),
                );
              }

              if (state is ExerciseAnswerSelectedState) {
                final question =
                    context.read<ExerciseBloc>().exercise?.question;
                children.add(
                  Flexible(
                    child: ExplanationsWidget(
                      explanation: question?.explanation,
                      visualExplanation: question?.visualExplanation,
                    ),
                  ),
                );
                children.add(
                  Material(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: InkWell(
                      child: const SizedBox(
                        height: 48.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        BlocProvider.of<ExerciseBloc>(context).add(
                          ExerciseRetrieveExerciseEvent(),
                        );
                      },
                    ),
                  ),
                );
              } else {
                children.add(const Spacer());
              }

              if (children.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
