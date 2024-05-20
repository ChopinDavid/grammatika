import 'package:flutter/material.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/extensions/gender_extension.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/widgets/answer_card.dart';

class GenderExerciseWidget extends StatelessWidget {
  const GenderExerciseWidget({
    super.key,
    required this.exercise,
  });

  final Exercise<Gender, Noun> exercise;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('What is the gender of the word...'),
        Text(
          '${exercise.question.word.bare}?',
          key: const Key('bare-key'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: UchuSpacing.L),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: AnswerCard(
                answers: [
                  Exercise<Gender, Noun>(
                    answer: Gender.m,
                    question: exercise.question,
                  )
                ],
                displayString: Gender.m.displayString,
                isCorrect: exercise.answer == null
                    ? null
                    : exercise.answer == Gender.m
                        ? exercise.question.correctAnswer == Gender.m
                            ? true
                            : false
                        : null,
              ),
            ),
            Expanded(
              child: AnswerCard(
                answers: [
                  Exercise<Gender, Noun>(
                    answer: Gender.f,
                    question: exercise.question,
                  )
                ],
                displayString: Gender.f.displayString,
                isCorrect: exercise.answer == null
                    ? null
                    : exercise.answer == Gender.f
                        ? exercise.question.correctAnswer == Gender.f
                            ? true
                            : false
                        : null,
              ),
            ),
            Expanded(
              child: AnswerCard(
                answers: [
                  Exercise<Gender, Noun>(
                    answer: Gender.n,
                    question: exercise.question,
                  )
                ],
                displayString: Gender.n.displayString,
                isCorrect: exercise.answer == null
                    ? null
                    : exercise.answer == Gender.n
                        ? exercise.question.correctAnswer == Gender.n
                            ? true
                            : false
                        : null,
              ),
            ),
          ],
        )
      ],
    );
  }
}
