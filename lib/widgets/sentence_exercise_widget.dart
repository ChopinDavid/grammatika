import 'package:flutter/material.dart';
import 'package:uchu/consts.dart';
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
    final givenAnswers = exercise.answers;

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
                style: translatableTextStyle,
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
          key: const Key('sentence-rich-text'),
          text: TextSpan(
            children: [
              const TextSpan(
                text: '«',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              ...exerciseHelper.getTextSpansFromSentence(
                sentenceExercise: exercise,
                defaultTextStyle: DefaultTextStyle.of(context).style,
              ),
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
