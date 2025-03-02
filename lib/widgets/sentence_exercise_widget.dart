import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/utilities/exercise_helper.dart';
import 'package:grammatika/utilities/url_helper.dart';

import 'answer_card.dart';

class SentenceExerciseWidget extends StatelessWidget {
  const SentenceExerciseWidget({
    super.key,
    required this.exercise,
    this.exerciseHelper = const ExerciseHelper(),
  });

  final Exercise<WordForm, Sentence> exercise;
  final ExerciseHelper exerciseHelper;

  @override
  Widget build(BuildContext context) {
    final givenAnswers = exercise.answers;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'What is the correct form of the word ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: InkWell(
                    child: Text(
                      exercise.question.word.bare,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () async {
                      await GetIt.instance
                          .get<UrlHelper>()
                          .launchWiktionaryPageFor(exercise.question.word.bare);
                    },
                  ),
                ),
                TextSpan(
                  text: ' in the sentence:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: GrammatikaSpacing.M),
        //  TODO(DC): Write test around scenarios when the base word is the first word in the sentence and is capitalized.

        Center(
          child: RichText(
            key: const Key('sentence-rich-text'),
            text: TextSpan(
              children: exerciseHelper.getSpansFromSentence(
                context,
                sentenceExercise: exercise,
                defaultTextStyle:
                    DefaultTextStyle.of(context).style.copyWith(fontSize: 24.0),
                tatoebaKey: exercise.question.tatoebaKey,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: GrammatikaSpacing.L),

        Wrap(
          children: exerciseHelper
              .getAnswerGroupsForSentenceExercise(sentenceExercise: exercise)
              .map<String, Widget>((key, listOfAnswers) {
                final answerIsCorrect = exerciseHelper.getAnswerIsCorrect(
                    sentenceExercise: exercise,
                    givenAnswers: givenAnswers,
                    listOfAnswers: listOfAnswers);

                return MapEntry(
                  key,
                  AnswerCard<WordForm>(
                    answers: listOfAnswers,
                    displayString: key,
                    isCorrect: answerIsCorrect,
                  ),
                );
              })
              .values
              .toList(),
        ),
      ],
    );
  }
}
