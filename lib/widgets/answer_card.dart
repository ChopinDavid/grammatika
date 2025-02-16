import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grammatika/blocs/exercise/exercise_bloc.dart';
import 'package:grammatika/models/answer.dart';

class AnswerCard<T extends Answer> extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.answers,
    required this.displayString,
    required this.isCorrect,
  });

  final List<T> answers;
  final String displayString;
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
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
              onTap: state is ExerciseAnswerSelectedState
                  ? null
                  : () {
                      BlocProvider.of<ExerciseBloc>(context).add(
                        ExerciseSubmitAnswerEvent<T>(
                          answers: answers,
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  displayString,
                  textAlign: TextAlign.center,
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontSize: 18.0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
