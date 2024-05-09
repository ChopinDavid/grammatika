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
    required this.answer,
  });

  final Exercise<Gender, Noun> answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('What is the gender of the word...'),
        Text(
          '${answer.question.word.bare}?',
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
                    question: answer.question,
                  )
                ],
                displayString: Gender.m.displayString,
                isCorrect: answer.answer == null
                    ? null
                    : answer.answer == Gender.m
                        ? answer.question.correctAnswer == Gender.m
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
                    question: answer.question,
                  )
                ],
                displayString: Gender.f.displayString,
                isCorrect: answer.answer == null
                    ? null
                    : answer.answer == Gender.f
                        ? answer.question.correctAnswer == Gender.f
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
                    question: answer.question,
                  )
                ],
                displayString: Gender.n.displayString,
                isCorrect: answer.answer == null
                    ? null
                    : answer.answer == Gender.n
                        ? answer.question.correctAnswer == Gender.n
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
