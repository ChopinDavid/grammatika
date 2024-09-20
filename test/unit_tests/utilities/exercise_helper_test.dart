import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/utilities/exercise_helper.dart';

import '../mocks.dart';

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

  group(
    'getTextSpansFromSentence',
    () {
      test('number of spans returned is correct', () {
        const sentence = "Всему' своё вре'мя.";
        expect(
          testObject
              .getTextSpansFromSentence(
                sentenceExercise: Exercise<WordForm, Sentence>(
                  question: Sentence.testValue(ru: sentence),
                  answers: [],
                ),
                defaultTextStyle: MockTextStyle(),
              )
              .length,
          sentence.split(' ').length * 2 - 1,
        );
      });

      test(
          'even indexed text spans correspond to their respective words, while odd indexed text spans are just whitespace',
          () {
        const sentence = "Всему своё время.";
        final textSpans = testObject.getTextSpansFromSentence(
          sentenceExercise: Exercise<WordForm, Sentence>(
            question: Sentence.testValue(ru: sentence),
            answers: [],
          ),
          defaultTextStyle: MockTextStyle(),
        );
        for (int i = 0; i < textSpans.length; i++) {
          final isEven = i % 2 == 0;
          expect(
            textSpans[i].text,
            isEven ? sentence.split(' ')[i ~/ 2] : '  ',
          );
        }
      });

      test(
        'even indexed text spans have translatable text styles if they are not placeholder text, while odd indexed text spans do not get a specific text style',
        () {
          const sentence = "Всему' своё вре'мя.";
          final expectedDefaultTextStyle = MockTextStyle();
          final textSpans = testObject.getTextSpansFromSentence(
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(
                ru: sentence,
                possibleAnswers: [
                  WordForm.testValue(
                    bare: 'время',
                    type: WordFormType.ruNounSgNom,
                  ),
                ],
                formType: WordFormType.ruNounSgNom,
              ),
              answers: [],
            ),
            defaultTextStyle: expectedDefaultTextStyle,
          );
          for (int i = 0; i < textSpans.length; i++) {
            final textSpan = textSpans[i];
            if (textSpan.text?.contains(sentenceWordPlaceholderText) == true) {
              expect(
                textSpan.style,
                expectedDefaultTextStyle,
              );
            } else if (textSpan.text == '  ') {
              expect(
                textSpan.style,
                isNull,
              );
            } else {
              expect(
                textSpan.style,
                translatableTextStyle,
              );
            }
          }
        },
      );

      test(
        'apostrophes are omitted from text spans',
        () {
          const sentence = "Всему' своё вре'мя.";
          final textSpans = testObject.getTextSpansFromSentence(
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(ru: sentence),
              answers: [],
            ),
            defaultTextStyle: MockTextStyle(),
          );
          for (int i = 0; i < textSpans.length; i++) {
            expect(
              textSpans[i].text?.contains("'"),
              isFalse,
            );
          }
        },
      );
    },
  );

  group(
    'getAnswerIsCorrect',
    () {
      test(
        'returns null when givenAnswers is null',
        () {
          expect(
            testObject.getAnswerIsCorrect(
              sentenceExercise: Exercise<WordForm, Sentence>(
                question: Sentence.testValue(),
                answers: [],
              ),
              givenAnswers: null,
              listOfAnswers: [],
            ),
            isNull,
          );
        },
      );

      test(
        'returns null when givenAnswers is an empty list',
        () {
          expect(
            testObject.getAnswerIsCorrect(
              sentenceExercise: Exercise<WordForm, Sentence>(
                question: Sentence.testValue(),
                answers: [],
              ),
              givenAnswers: [],
              listOfAnswers: [],
            ),
            isNull,
          );
        },
      );

      test(
        "returns null when listOfAnswers and givenAnswers have no matches, listOfAnswers doesn't contain the correctAnswer, and listOfAnswers and answerSynonyms have no matches",
        () {
          expect(
            testObject.getAnswerIsCorrect(
              sentenceExercise: Exercise<WordForm, Sentence>(
                question: Sentence.testValue(answerSynonyms: [
                  WordForm.testValue(type: WordFormType.ruAdjFDat)
                ]),
                answers: [],
              ),
              givenAnswers: [],
              listOfAnswers: [
                WordForm.testValue(type: WordFormType.ruVerbGerundPast)
              ],
            ),
            isNull,
          );
        },
      );

      test(
        "returns true when listOfAnswers and givenAnswers have a match",
        () {
          final correctAnswer =
              WordForm.testValue(type: WordFormType.ruVerbGerundPast);
          expect(
            testObject.getAnswerIsCorrect(
              sentenceExercise: Exercise<WordForm, Sentence>(
                question: Sentence.testValue(
                    formType: correctAnswer.type,
                    wordFormPosition: correctAnswer.position,
                    form: correctAnswer.form,
                    formBare: correctAnswer.bare),
                answers: [],
              ),
              givenAnswers: [correctAnswer],
              listOfAnswers: [correctAnswer],
            ),
            isTrue,
          );
        },
      );

      test(
        "returns false when listOfAnswers and givenAnswers don't have a match and listOfAnswers and answerSynonyms have no match",
        () {
          final correctAnswer =
              WordForm.testValue(type: WordFormType.ruVerbGerundPast);
          expect(
            testObject.getAnswerIsCorrect(
              sentenceExercise: Exercise<WordForm, Sentence>(
                question: Sentence.testValue(
                    formType: WordFormType.ruNounPlNom,
                    wordFormPosition: correctAnswer.position,
                    form: correctAnswer.form,
                    formBare: correctAnswer.bare),
                answers: [],
              ),
              givenAnswers: [correctAnswer],
              listOfAnswers: [correctAnswer],
            ),
            isFalse,
          );
        },
      );

      test(
        "returns true when listOfAnswers and givenAnswers don't have a match but listOfAnswers and answerSynonyms do have a match",
        () {
          final correctAnswer =
              WordForm.testValue(type: WordFormType.ruVerbGerundPast);
          expect(
            testObject.getAnswerIsCorrect(
              sentenceExercise: Exercise<WordForm, Sentence>(
                question: Sentence.testValue(
                  formType: WordFormType.ruNounPlNom,
                  wordFormPosition: correctAnswer.position,
                  form: correctAnswer.form,
                  formBare: correctAnswer.bare,
                  answerSynonyms: [correctAnswer],
                ),
                answers: [],
              ),
              givenAnswers: [correctAnswer],
              listOfAnswers: [correctAnswer],
            ),
            isTrue,
          );
        },
      );
    },
  );
}
