import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/utilities/exercise_helper.dart';
import 'package:uchu/utilities/url_helper.dart';

import '../mocks.dart';

main() {
  late ExerciseHelper testObject;
  late UrlHelper mockUrlHelper;

  setUp(
    () async {
      await GetIt.instance.reset();
      testObject = const ExerciseHelper();

      mockUrlHelper = MockUrlHelper();
      GetIt.instance.registerSingleton<UrlHelper>(mockUrlHelper);
      when(() => mockUrlHelper.launchWiktionaryPageFor(any())).thenAnswer(
        (invocation) async => true,
      );
    },
  );

  group(
    'getAnswerGroupsForSentenceExercise',
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
    'getSpansFromSentence',
    () {
      test('number of spans returned is correct', () {
        const sentence = "Всему' своё вре'мя.";
        expect(
          testObject
              .getSpansFromSentence(
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
        final spans = testObject.getSpansFromSentence(
          sentenceExercise: Exercise<WordForm, Sentence>(
            question: Sentence.testValue(ru: sentence),
            answers: [],
          ),
          defaultTextStyle: MockTextStyle(),
        );
        for (int i = 0; i < spans.length; i++) {
          final isEven = i % 2 == 0;
          if (isEven) {
            expect(
              (((spans[i] as WidgetSpan).child as InkWell).child as Text).data,
              sentence.split(' ')[i ~/ 2],
            );
          } else {
            expect((spans[i] as TextSpan).text, '  ');
          }
        }
      });

      test(
        'even indexed text spans have translatable text styles if they are not placeholder text, while odd indexed text spans do not get a specific text style',
        () {
          const sentence = "Всему' своё вре'мя.";
          final expectedDefaultTextStyle = MockTextStyle();
          final spans = testObject.getSpansFromSentence(
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
          for (int i = 0; i < spans.length; i++) {
            final span = spans[i];
            if (span is WidgetSpan) {
              expect(
                ((span.child as InkWell).child as Text).style,
                translatableTextStyle,
              );
            } else if (span is TextSpan) {
              if (span.text?.contains(sentenceWordPlaceholderText) == true) {
                expect(
                  span.style,
                  expectedDefaultTextStyle,
                );
              } else if (span.text == '  ') {
                expect(
                  span.style,
                  isNull,
                );
              }
            } else {
              fail('all spans should either be WidgetSpans or TextSpans');
            }
          }
        },
      );

      test(
        'even indexed text spans launch wiktionary for respective word when tapped',
        () {
          const sentence = "Всему' своё вре'мя.";
          final expectedDefaultTextStyle = MockTextStyle();
          final spans = testObject.getSpansFromSentence(
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
          for (int i = 0; i < spans.length; i++) {
            final span = spans[i];
            if (span is WidgetSpan) {
              (span.child as InkWell).onTap?.call();
              verify(() => mockUrlHelper.launchWiktionaryPageFor(
                  sentence.split(' ')[i ~/ 2].replaceAll('\'', '')));
            }
          }
        },
      );

      test(
        'apostrophes are omitted from text spans',
        () {
          const sentence = "Всему' своё вре'мя.";
          final spans = testObject.getSpansFromSentence(
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(ru: sentence),
              answers: [],
            ),
            defaultTextStyle: MockTextStyle(),
          );
          for (int i = 0; i < spans.length; i++) {
            final span = spans[i];
            if (span is WidgetSpan) {
              expect(
                ((span.child as InkWell).child as Text).data?.contains("'"),
                isFalse,
              );
            } else if (span is TextSpan) {
              expect(
                span.text?.contains("'"),
                isFalse,
              );
            } else {
              fail('all spans should either be WidgetSpans or TextSpans');
            }
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
