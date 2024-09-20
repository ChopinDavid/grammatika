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
}
