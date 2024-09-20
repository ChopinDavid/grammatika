import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/utilities/exercise_helper.dart';

main() {
  late ExerciseHelper testObject;

  setUp(
    () {
      testObject = const ExerciseHelper();
    },
  );

  group(
    'getAnswerGroupsForSentence',
    () {
      test(
        'creates new list when bare is not yet registered in answerGroups',
        () {
          const bare = 'той';
          final expectedAnswerList = [
            WordForm.testValue(
              bare: bare,
              form: "то'й",
              position: 1,
              type: WordFormType.ruAdjFDat,
            )
          ];
          final answerGroups = testObject.getAnswerGroupsForSentenceExercise(
            sentenceExercise: Exercise<WordForm, Sentence>(
              answers: expectedAnswerList,
              question: Sentence.testValue(
                possibleAnswers: expectedAnswerList,
              ),
            ),
          );
          expect(answerGroups[bare], expectedAnswerList);
        },
      );

      test(
        'adds answer to existing list when bare is already yet registered in answerGroups',
        () {
          const bare = 'той';
          final existingAnswer = WordForm.testValue(
            bare: bare,
            form: "то'й",
            position: 1,
            type: WordFormType.ruAdjFDat,
          );
          final newAnswer = WordForm.testValue(
            bare: bare,
            form: "то'й",
            position: 1,
            type: WordFormType.ruAdjFInst,
          );
          final expectedAnswerList = [existingAnswer, newAnswer];
          final answerGroups = testObject.getAnswerGroupsForSentenceExercise(
            sentenceExercise: Exercise<WordForm, Sentence>(
              answers: expectedAnswerList,
              question: Sentence.testValue(
                possibleAnswers: expectedAnswerList,
              ),
            ),
          );
          expect(answerGroups[bare], expectedAnswerList);
        },
      );
    },
  );
}
