import 'package:flutter/material.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/extensions/list_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';

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
    final givenAnswers = exercise.answers;
    Map<String, List<WordForm>> answerGroups = {};
    for (var element in possibleAnswers) {
      final listOfAnswers = answerGroups[element.bare];
      final answerToAdd = element;
      if (listOfAnswers != null) {
        listOfAnswers.add(answerToAdd);
        answerGroups[element.bare] = listOfAnswers;
      } else {
        answerGroups[element.bare] = [answerToAdd];
      }
    }
    final baseWord = exercise.question.possibleAnswers
        .firstWhere(
            (element) => element.type == exercise.question.correctAnswer.type)
        .bare;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            'What is the correct form of the word ${exercise.question.word.bare} in the sentence:'),
        const SizedBox(height: UchuSpacing.M),
        //  TODO(DC): Write test around scenarios when the base word is the first word in the sentence and is capitalized.
        Text(
          '«${exercise.question.ru.replaceAll('\'', '').replaceFirst(baseWord, '______').replaceFirst(baseWord.capitalized(), '______')}»',
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
