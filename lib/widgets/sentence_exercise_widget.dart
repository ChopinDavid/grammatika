import 'package:flutter/material.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';

import 'answer_card.dart';

class SentenceExerciseWidget extends StatelessWidget {
  const SentenceExerciseWidget({
    super.key,
    required this.answer,
  });

  final Exercise<WordForm, Sentence> answer;

  @override
  Widget build(BuildContext context) {
    final possibleAnswers = answer.question.possibleAnswers;
    Map<String, List<Exercise<WordForm, Sentence>>> answerGroups = {};
    for (var element in possibleAnswers) {
      final listOfAnswers = answerGroups[element.bare];
      final answerToAdd = Exercise<WordForm, Sentence>(
        answer: element,
        question: answer.question,
      );
      if (listOfAnswers != null) {
        listOfAnswers.add(answerToAdd);
        answerGroups[element.bare] = listOfAnswers;
      } else {
        answerGroups[element.bare] = [answerToAdd];
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            'What is the correct form of the word ${answer.question.word.bare} in the sentence:'),
        const SizedBox(height: UchuSpacing.M),
        Text(
          '«${answer.question.ru.replaceFirst(answer.question.possibleAnswers.firstWhere((element) => element.type == answer.question.correctAnswer.type).form ?? '', '______')}»',
        ),
        const SizedBox(height: UchuSpacing.L),
        Wrap(
            children: answerGroups
                .map<String, Widget>((key, value) {
                  final answerIsCorrect = answer.answer == null
                      ? null
                      // TODO(DC): remove bangs
                      : value
                              .where((element) =>
                                  element.answer?.type ==
                                  answer.question.correctAnswer.type)
                              .isNotEmpty
                          ? true
                          : answer.answer == value.first.answer
                              ? false
                              : null;

                  return MapEntry(
                      key,
                      AnswerCard<WordFormType>(
                        answers: value,
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
