import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/exercise_bloc.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/widgets/gender_card.dart';

class GenderExerciseWidget extends StatelessWidget {
  const GenderExerciseWidget({
    super.key,
    required this.word,
  });

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('What is the gender of the word...'),
        Text(
          '${word.bare}?',
          key: const Key('bare-key'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: UchuSpacing.L),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GenderCard(
                gender: Gender.m,
                onTap: () => BlocProvider.of<ExerciseBloc>(context).add(
                  ExerciseSubmitAnswerEvent(
                    answer: Answer<Gender>.initial(
                      answer: Gender.m,
                      word: word,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GenderCard(
                gender: Gender.f,
                onTap: () => BlocProvider.of<ExerciseBloc>(context).add(
                  ExerciseSubmitAnswerEvent(
                    answer: Answer<Gender>.initial(
                      answer: Gender.f,
                      word: word,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GenderCard(
                gender: Gender.n,
                onTap: () => BlocProvider.of<ExerciseBloc>(context).add(
                  ExerciseSubmitAnswerEvent(
                    answer: Answer<Gender>.initial(
                      answer: Gender.n,
                      word: word,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
