import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/blocs/exercise/exercise_bloc.dart';

class ExerciseFooter extends StatelessWidget {
  const ExerciseFooter({
    super.key,
    required this.explanation,
    required this.visualExplanation,
  });
  final String? explanation;
  final String? visualExplanation;

  @override
  Widget build(BuildContext context) {
    final explanation = this.explanation;
    final visualExplanation = this.visualExplanation;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (explanation != null)
          Text(
            explanation,
            key: const Key('explanation-text'),
          ),
        if (visualExplanation != null)
          Center(
            child: Text(
              visualExplanation,
              key: const Key('visual-explanation-text'),
            ),
          ),
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
      ],
    );
  }
}
