import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grammatika/blocs/exercise/exercise_bloc.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/widgets/explanations_widget.dart';
import 'package:grammatika/widgets/gender_exercise_widget.dart';
import 'package:grammatika/widgets/grammatika_drawer.dart';
import 'package:grammatika/widgets/sentence_exercise_widget.dart';

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
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          bottom: 24.0,
        ),
        child: Center(
          child: BlocConsumer<ExerciseBloc, ExerciseState>(
            listener: (context, state) {
              if (state is ExerciseErrorState) {
                // TODO(DC): Maybe fetch a new exercise here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'There was an error fetching exercise: ${state.errorString}',
                    ),
                  ),
                );
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
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: state.viewingExplanation
                        ? ExplanationsWidget(
                            explanation: question?.explanation,
                            visualExplanation: question?.visualExplanation,
                          )
                        : TextButton(
                            onPressed: () {
                              BlocProvider.of<ExerciseBloc>(context).add(
                                ExerciseViewExplanationEvent(),
                              );
                            },
                            child: const Text('Show Explanation'),
                          ),
                  ),
                );
              }

              if (children.isNotEmpty) {
                final gradientColor = Theme.of(context).scaffoldBackgroundColor;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            padding:
                                const EdgeInsets.only(top: 24.0, bottom: 16.0),
                            child: Column(
                              children: children,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 24.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      gradientColor.withValues(alpha: 0.9),
                                      gradientColor.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 16.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      gradientColor.withValues(alpha: 0.0),
                                      gradientColor.withValues(alpha: 0.9),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (state is ExerciseAnswerSelectedState)
                      Material(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.hardEdge,
                        elevation: Theme.of(context).cardTheme.elevation ?? 2.0,
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
                      )
                  ],
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
