import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/extensions/gender_extension.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';

class GenderCard extends StatelessWidget {
  GenderCard({
    super.key,
    required this.gender,
    required this.onTap,
  }) {
    genderDisplayString = gender.displayString ?? '';
    assert((genderDisplayString).isNotEmpty,
        'Gender other than masculine, feminine, or neuter passed to GenderCard');
  }

  final Gender gender;
  final VoidCallback onTap;
  late final String genderDisplayString;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        Answer<Gender>? correctAnswer;
        if (state is ExerciseExerciseGradedState) {
          final answer = state.answer;
          if (answer is Answer<Gender>) {
            correctAnswer = answer;
          }
        }

        final isCorrectAnswer = gender == correctAnswer?.correctAnswer;
        final isIncorrectAnswer = gender != correctAnswer?.correctAnswer &&
            gender == correctAnswer?.answer;

        return SizedBox(
          height: 50,
          child: Card(
            color: isIncorrectAnswer
                ? Colors.red
                : isCorrectAnswer
                    ? Colors.green
                    : null,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: Text(
                  genderDisplayString,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
