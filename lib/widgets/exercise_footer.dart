import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/blocs/exercise/exercise_bloc.dart';

class ExerciseFooter extends StatelessWidget {
  const ExerciseFooter({
    super.key,
    required this.explanation,
  });
  final String? explanation;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (explanation != null)
          Text(
            explanation!,
            key: const Key('explanation-text'),
          ),
        Container(
          color: Colors.grey,
          width: double.maxFinite,
          // TODO(DC): Can we use a SafeArea widget instead?
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: TextButton(
              child: const Text('Next'),
              onPressed: () {
                BlocProvider.of<ExerciseBloc>(context).add(
                  ExerciseRetrieveExerciseEvent(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
