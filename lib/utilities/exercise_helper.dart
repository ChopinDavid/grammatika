import 'package:flutter/material.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/extensions/list_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';

class ExerciseHelper {
  const ExerciseHelper();

  Map<String, List<WordForm>> getAnswerGroupsForSentenceExercise(
      {required Exercise<WordForm, Sentence> sentenceExercise}) {
    final possibleAnswers = sentenceExercise.question.possibleAnswers;
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
    return answerGroups;
  }

  List<TextSpan> getTextSpansFromSentence({
    required Exercise<WordForm, Sentence> sentenceExercise,
    required TextStyle defaultTextStyle,
  }) {
    final baseWord = sentenceExercise.question.possibleAnswers
        .firstWhere((element) =>
            element.type == sentenceExercise.question.correctAnswer.type)
        .bare;
    final sentenceWords = sentenceExercise.question.ru
        .replaceAll('\'', '')
        .replaceFirst(baseWord, sentenceWordPlaceholderText)
        .replaceFirst(baseWord.capitalized(), sentenceWordPlaceholderText)
        .split(' ');

    List<TextSpan> sentenceTextSpans = [];
    final sentenceSegmentsCount = sentenceWords.length * 2;
    for (int i = 0; i < sentenceSegmentsCount; i++) {
      if (i % 2 == 0) {
        sentenceTextSpans.add(
          const TextSpan(
            text: '  ',
          ),
        );
      } else {
        final sentenceWordIndex = i ~/ 2;
        sentenceTextSpans.add(
          TextSpan(
            text: sentenceWords[sentenceWordIndex],
            style: sentenceWords[sentenceWordIndex]
                    .contains(sentenceWordPlaceholderText)
                ? defaultTextStyle
                : translatableTextStyle,
          ),
        );
      }
    }

    return sentenceTextSpans..removeAt(0);
  }

  bool? getAnswerIsCorrect(
      {required Exercise<WordForm, Sentence> sentenceExercise,
      required List<WordForm>? givenAnswers,
      required List<WordForm> listOfAnswers}) {
    return givenAnswers == null ||
            (listOfAnswers.duplicates(givenAnswers).isEmpty &&
                !listOfAnswers
                    .contains(sentenceExercise.question.correctAnswer) &&
                listOfAnswers
                    .duplicates(sentenceExercise.question.answerSynonyms)
                    .isEmpty)
        ? null
        : listOfAnswers.contains(sentenceExercise.question.correctAnswer) ||
            sentenceExercise.question.answerSynonyms
                .duplicates(listOfAnswers)
                .isNotEmpty;
  }
}
