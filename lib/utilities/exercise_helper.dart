import 'package:flutter/material.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/extensions/list_extension.dart';
import 'package:grammatika/extensions/string_extension.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/widgets/dashed_border_painter.dart';
import 'package:grammatika/widgets/translatable_word.dart';
import 'package:grammatika/widgets/translation_button.dart';

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

  List<InlineSpan> getSpansFromSentence(
    BuildContext context, {
    required Exercise<WordForm, Sentence> sentenceExercise,
    required TextStyle defaultTextStyle,
    required int? tatoebaKey,
    required bool answerGiven,
  }) {
    final baseWord = sentenceExercise.question.possibleAnswers
        .firstWhere((element) =>
            element.type == sentenceExercise.question.correctAnswer.type)
        .bare;
    final sentenceWords =
        sentenceExercise.question.ru.replaceAll('\'', '').split(' ');

    List<InlineSpan> sentenceSpans = [];
    final sentenceSegmentsCount = sentenceWords.length * 2;
    for (int i = 0; i < sentenceSegmentsCount; i++) {
      if (i % 2 == 0) {
        sentenceSpans.add(
          const TextSpan(
            text: '  ',
          ),
        );
      } else {
        final sentenceWordIndex = i ~/ 2;
        var word = sentenceWords[sentenceWordIndex];
        final wordWithoutPunctuation = word.replaceAll(RegExp(r'[ ,.?!]'), '');
        List<Widget> widgetsToAdd = [];

        if (wordWithoutPunctuation == baseWord ||
            wordWithoutPunctuation == baseWord.capitalized()) {
          widgetsToAdd.add(
            CustomPaint(
              painter: DashedBorderPainter(
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    (MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.black
                        : Colors.white),
                dashSpace: 1,
              ),
              child: Text(
                answerGiven
                    ? wordWithoutPunctuation
                    : sentenceWordPlaceholderText,
                style: defaultTextStyle.copyWith(
                  fontSize: 24,
                  color: answerGiven ? null : Colors.transparent,
                ),
              ),
            ),
          );
        } else if (wordWithoutPunctuation != '-') {
          widgetsToAdd.add(
            TranslatableWord(
              wordWithoutPunctuation,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 24.0),
            ),
          );
        }

        if (word == '-' ||
            word.endsWith(',') ||
            word.endsWith('.') ||
            word.endsWith('?') ||
            word.endsWith('!')) {
          widgetsToAdd.add(
            Text(
              word.substring(word.length - 1),
              style: defaultTextStyle,
            ),
          );
        }

        final bool isFirstWord = sentenceWordIndex == 0;
        final bool isLastWord = sentenceWordIndex == sentenceWords.length - 1;

        sentenceSpans.add(
          WidgetSpan(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (isFirstWord)
                Text(
                  '«',
                  style: defaultTextStyle,
                ),
              ...widgetsToAdd,
              if (isLastWord) ...[
                Text(
                  '»',
                  style: defaultTextStyle,
                ),
                TranslationButton(tatoebaKey: tatoebaKey),
              ]
            ]),
          ),
        );
      }
    }

    return sentenceSpans..removeAt(0);
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
