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
    required this.exercise,
  });

  final Exercise<WordForm, Sentence> exercise;

  @override
  Widget build(BuildContext context) {
    final possibleAnswers = exercise.question.possibleAnswers;
    Map<String, List<Exercise<WordForm, Sentence>>> answerGroups = {};
    for (var element in possibleAnswers) {
      final listOfAnswers = answerGroups[element.bare];
      final answerToAdd = Exercise<WordForm, Sentence>(
        answer: element,
        question: exercise.question,
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
            'What is the correct form of the word ${exercise.question.word.bare} in the sentence:'),
        const SizedBox(height: UchuSpacing.M),
        Text(
          '«${exercise.question.ru.replaceFirst(exercise.question.possibleAnswers.firstWhere((element) => element.type == exercise.question.correctAnswer.type).form ?? '', '______')}»',
        ),
        const SizedBox(height: UchuSpacing.L),
        Wrap(
            children: answerGroups
                .map<String, Widget>((key, value) {
                  final answerIsCorrect = exercise.answer == null
                      ? null
                      // TODO(DC): remove bangs
                      : value
                              .where((element) =>
                                  element.answer?.type ==
                                  exercise.question.correctAnswer.type)
                              .isNotEmpty
                          ? true
                          : exercise.answer == value.first.answer
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
