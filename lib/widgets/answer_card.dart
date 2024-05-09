import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/exercise.dart';

// TODO(DC): rename file to answer_card.dart
class AnswerCard<T> extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.answers,
    required this.displayString,
    required this.isCorrect,
  });

  final List<Exercise> answers;
  final String displayString;
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    final exercise = answers
        .where((element) => element.answer == element.question.correctAnswer)
        .singleOrNull;
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        return SizedBox(
          child: Card(
            color: isCorrect != null
                // TODO(DC): try to remove bang (I guess?)
                ? isCorrect!
                    ? Colors.green
                    : Colors.red
                : null,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: BlocProvider.of<ExerciseBloc>(context).state
                      is ExerciseAnswerSelectedState
                  ? null
                  : () {
                      BlocProvider.of<ExerciseBloc>(context).add(
                        ExerciseSubmitAnswerEvent(
                          exercise: exercise ?? answers.first,
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
