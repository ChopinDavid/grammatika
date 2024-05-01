import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/extensions/gender_extension.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';

class AnswerCard extends StatelessWidget {
  AnswerCard({
    super.key,
    required this.answer,
  }) {
    displayString = (answer is Answer<Gender>
            ? (answer.answer as Gender).displayString
            : answer.word.bare) ??
        '';
    assert((displayString).isNotEmpty,
        'Gender other than masculine, feminine, or neuter passed to GenderCard');
  }

  final Answer answer;
  late final String displayString;

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

        final isCorrectAnswer = answer.answer == correctAnswer?.correctAnswer;
        final isIncorrectAnswer =
            answer.answer != correctAnswer?.correctAnswer &&
                answer.answer == correctAnswer?.answer;

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
              onTap: () {
                BlocProvider.of<ExerciseBloc>(context).add(
                  ExerciseSubmitAnswerEvent(
                    answer: answer,
                  ),
                );
              },
              child: Center(
                child: Text(
                  displayString,
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
