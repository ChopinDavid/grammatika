import 'package:flutter/material.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/extensions/list_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/utilities/exercise_helper.dart';

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
    final answerGroups = exerciseHelper.getAnswerGroupsForSentenceExercise(
        sentenceExercise: exercise);
    final givenAnswers = exercise.answers;
    final baseWord = exercise.question.possibleAnswers
        .firstWhere(
            (element) => element.type == exercise.question.correctAnswer.type)
        .bare;
    List<TextSpan> sentenceTextSpans = [];
    final sentenceWords = exercise.question.ru
        .replaceAll('\'', '')
        .replaceFirst(baseWord, '______')
        .replaceFirst(baseWord.capitalized(), '______')
        .split(' ');
    final sentenceSegmentsCount = sentenceWords.length * 2 - 1;
    for (int i = 0; i < sentenceSegmentsCount; i++) {
      if (i % 2 == 0) {
        sentenceTextSpans.add(
          TextSpan(
            text: i == 0 || i == sentenceSegmentsCount - 1 ? '' : ' ',
          ),
        );
      } else {
        sentenceTextSpans.add(
          TextSpan(
              text: sentenceWords[i ~/ 2],
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dashed,
                color: Colors.black,
              )),
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'What is the correct form of the word ',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: exercise.question.word.bare,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dashed,
                  color: Colors.black,
                ),
              ),
              const TextSpan(
                text: ' in the sentence:',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: UchuSpacing.M),
        //  TODO(DC): Write test around scenarios when the base word is the first word in the sentence and is capitalized.

        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: '«',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              ...sentenceTextSpans,
              const TextSpan(
                text: '»',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: UchuSpacing.L),
        Wrap(
            children: answerGroups
                .map<String, Widget>((key, listOfAnswers) {
                  final answerIsCorrect = givenAnswers == null ||
                          (listOfAnswers.duplicates(givenAnswers).isEmpty &&
                              !listOfAnswers
                                  .contains(exercise.question.correctAnswer) &&
                              listOfAnswers
                                  .duplicates(exercise.question.answerSynonyms)
                                  .isEmpty)
                      ? null
                      : listOfAnswers
                              .contains(exercise.question.correctAnswer) ||
                          exercise.question.answerSynonyms
                              .duplicates(listOfAnswers)
                              .isNotEmpty;

                  return MapEntry(
                      key,
                      AnswerCard<WordForm>(
                        answers: listOfAnswers,
                        displayString: key,
                        isCorrect: answerIsCorrect,
                      ));
                })
                .values
                .toList()),
      ],
    );
  }
}
