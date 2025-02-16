import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/extensions/gender_extension.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/utilities/url_helper.dart';
import 'package:uchu/widgets/answer_card.dart';
import 'package:uchu/widgets/translation_button.dart';

class GenderExerciseWidget extends StatelessWidget {
  const GenderExerciseWidget({
    super.key,
    required this.exercise,
    required this.isAnswered,
  });

  final Exercise<Gender, Noun> exercise;
  final bool isAnswered;

  @override
  Widget build(BuildContext context) {
    final answers = exercise.answers;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('What is the gender of the word...'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${exercise.question.word.bare}?',
              key: const Key('bare-key'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            isAnswered
                ? TranslationButton(
                    onPressed: () {
                      GetIt.instance
                          .get<UrlHelper>()
                          .launchWiktionaryPageFor(exercise.question.word.bare);
                    },
                  )
                : const SizedBox.square(
                    dimension: 24.0,
                  ),
          ],
        ),
        const SizedBox(height: UchuSpacing.L),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Gender.m, Gender.f, Gender.n]
              .map(
                (gender) => Expanded(
                  child: AnswerCard<Gender>(
                    answers: [gender],
                    displayString: gender.displayString,
                    isCorrect: answers == null || answers.isEmpty
                        ? null
                        : exercise.question.correctAnswer == gender
                            ? true
                            : answers.contains(gender)
                                ? false
                                : null,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
