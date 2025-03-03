import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/utilities/exercise_helper.dart';
import 'package:grammatika/utilities/url_helper.dart';
import 'package:grammatika/widgets/dashed_border_painter.dart';
import 'package:grammatika/widgets/translatable_word.dart';
import 'package:mocktail/mocktail.dart';

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
                MockBuildContext(),
                sentenceExercise: Exercise<WordForm, Sentence>(
                  question: Sentence.testValue(ru: sentence),
                  answers: const [],
                ),
                defaultTextStyle: MockTextStyle(),
                tatoebaKey: 1,
                answerGiven: false,
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
          MockBuildContext(),
          sentenceExercise: Exercise<WordForm, Sentence>(
            question: Sentence.testValue(ru: sentence),
            answers: const [],
          ),
          defaultTextStyle: MockTextStyle(),
          tatoebaKey: 1,
          answerGiven: false,
        );
        for (int i = 0; i < spans.length; i++) {
          final isEven = i % 2 == 0;
          if (isEven) {
            final children = (((spans[i] as WidgetSpan).child as Row)).children;
            expect(
              ((i == 0 ? children.last : children.first) as TranslatableWord)
                  .word,
              sentence.split(' ')[i ~/ 2].replaceAll(RegExp(r'[ ,.?]'), ''),
            );
          } else {
            expect((spans[i] as TextSpan).text, '  ');
          }
        }
      });

      test(
        'even indexed text spans have subject text wrapped in custom painter with blue dashed line if they are not placeholder text, while odd indexed text spans are not wrapped in a custom painter',
        () {
          final mockBuildContext = MockBuildContext();
          const sentence = "Всему' своё вре'мя.";
          final expectedDefaultTextStyle = MockTextStyle();
          final spans = testObject.getSpansFromSentence(
            mockBuildContext,
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
              answers: const [],
            ),
            defaultTextStyle: expectedDefaultTextStyle,
            tatoebaKey: 1,
            answerGiven: false,
          );
          for (int i = 0; i < spans.length; i++) {
            final span = spans[i];
            if (span is WidgetSpan) {
              final children =
                  (((spans[i] as WidgetSpan).child as Row)).children;
              final widgetWithText = i == 0 ? children.last : children.first;
              if (widgetWithText is CustomPaint) {
                expect(
                  widgetWithText.painter,
                  DashedBorderPainter(
                    color: Theme.of(mockBuildContext)
                            .textTheme
                            .bodyMedium
                            ?.color ??
                        (MediaQuery.of(mockBuildContext).platformBrightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white),
                    dashSpace: 1,
                  ),
                );
              } else {
                expect(
                  widgetWithText,
                  isA<TranslatableWord>(),
                );
              }
            } else if (span is TextSpan) {
              expect(
                span.style,
                isNull,
              );
            } else {
              fail('all spans should either be WidgetSpans or TextSpans');
            }
          }
        },
      );

      test(
        'placeholder text is transparent when answerGiven is false',
        () {
          final mockBuildContext = MockBuildContext();
          const sentence = "Всему' своё вре'мя.";
          final spans = testObject.getSpansFromSentence(
            mockBuildContext,
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
              answers: const [],
            ),
            defaultTextStyle: const TextStyle(),
            tatoebaKey: 1,
            answerGiven: false,
          );
          final span = spans[4] as WidgetSpan;
          final widgetWithText =
              (span.child as Row).children.first as CustomPaint;
          expect(
            widgetWithText.painter,
            DashedBorderPainter(
              color: Theme.of(mockBuildContext).textTheme.bodyMedium?.color ??
                  (MediaQuery.of(mockBuildContext).platformBrightness ==
                          Brightness.light
                      ? Colors.black
                      : Colors.white),
              dashSpace: 1,
            ),
          );
          expect(
              (widgetWithText.child as Text).data, sentenceWordPlaceholderText);
          expect(
              (widgetWithText.child as Text).style?.color, Colors.transparent);
        },
      );

      test(
        'placeholder text is correct answer text and not transparent when answerGiven is true',
        () {
          final mockBuildContext = MockBuildContext();
          const sentence = "Всему' своё вре'мя.";
          const expectedWord = 'время';
          final spans = testObject.getSpansFromSentence(
            mockBuildContext,
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(
                ru: sentence,
                possibleAnswers: [
                  WordForm.testValue(
                    bare: expectedWord,
                    type: WordFormType.ruNounSgNom,
                  ),
                ],
                formType: WordFormType.ruNounSgNom,
              ),
              answers: const [],
            ),
            defaultTextStyle: const TextStyle(),
            tatoebaKey: 1,
            answerGiven: true,
          );
          final span = spans[4] as WidgetSpan;
          final widgetWithText =
              (span.child as Row).children.first as CustomPaint;
          expect(
            widgetWithText.painter,
            DashedBorderPainter(
              color: Theme.of(mockBuildContext).textTheme.bodyMedium?.color ??
                  (MediaQuery.of(mockBuildContext).platformBrightness ==
                          Brightness.light
                      ? Colors.black
                      : Colors.white),
              dashSpace: 1,
            ),
          );
          expect((widgetWithText.child as Text).data, expectedWord);
          expect((widgetWithText.child as Text).style?.color, null);
        },
      );

      test(
        'even indexed text spans are TranslatableWords',
        () {
          const sentence = "Всему' своё вре'мя.";
          final expectedDefaultTextStyle = MockTextStyle();
          final spans = testObject.getSpansFromSentence(
            MockBuildContext(),
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
              answers: const [],
            ),
            defaultTextStyle: expectedDefaultTextStyle,
            tatoebaKey: 1,
            answerGiven: false,
          );
          for (int i = 0; i < spans.length; i++) {
            final span = spans[i];
            if (span is WidgetSpan) {
              final children =
                  (((spans[i] as WidgetSpan).child as Row)).children;

              final widgetWithText = i == 0 ? children.last : children.first;
              if (widgetWithText is CustomPaint) {
                return;
              } else {
                expect(widgetWithText, isA<TranslatableWord>());
              }
            }
          }
        },
      );

      test(
        'apostrophes are omitted from text spans',
        () {
          const sentence = "Всему' своё вре'мя.";
          final spans = testObject.getSpansFromSentence(
            MockBuildContext(),
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(ru: sentence),
              answers: const [],
            ),
            defaultTextStyle: MockTextStyle(),
            tatoebaKey: 1,
            answerGiven: false,
          );
          for (int i = 0; i < spans.length; i++) {
            final span = spans[i];
            if (span is WidgetSpan) {
              final children =
                  (((spans[i] as WidgetSpan).child as Row)).children;
              expect(
                ((i == 0 ? children.last : children.first) as TranslatableWord)
                    .word
                    .contains("'"),
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

      test(
        '"words" that are just hyphens get their own Text widget without custom paint',
        () {
          const sentence = "Всему' своё - вре'мя.";
          final spans = testObject.getSpansFromSentence(
            MockBuildContext(),
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(ru: sentence),
              answers: const [],
            ),
            defaultTextStyle: MockTextStyle(),
            tatoebaKey: 1,
            answerGiven: false,
          );
          final thirdWordWidgetSpan = spans[4] as WidgetSpan;
          final secondWordFirstWidget =
              (thirdWordWidgetSpan.child as Row).children.first as Text;
          expect(secondWordFirstWidget.data, '-');
        },
      );

      test(
        'commas at the end of words get their own Text widget without custom paint',
        () {
          const sentence = "Всему' своё, вре'мя.";
          final spans = testObject.getSpansFromSentence(
            MockBuildContext(),
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(ru: sentence),
              answers: const [],
            ),
            defaultTextStyle: MockTextStyle(),
            tatoebaKey: 1,
            answerGiven: false,
          );
          final secondWordWidgetSpan = spans[2] as WidgetSpan;
          final secondWordFirstWidget = (secondWordWidgetSpan.child as Row)
              .children
              .first as TranslatableWord;
          final secondWordSecondWidget =
              (secondWordWidgetSpan.child as Row).children.last as Text;
          expect(secondWordFirstWidget.word, 'своё');
          expect(secondWordSecondWidget.data, ',');
        },
      );

      test(
        'periods at the end of words get their own Text widget without custom paint',
        () {
          const sentence = "Всему' своё. вре'мя.";
          final spans = testObject.getSpansFromSentence(
            MockBuildContext(),
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(ru: sentence),
              answers: const [],
            ),
            defaultTextStyle: MockTextStyle(),
            tatoebaKey: 1,
            answerGiven: false,
          );
          final secondWordWidgetSpan = spans[2] as WidgetSpan;
          final secondWordFirstWidget = (secondWordWidgetSpan.child as Row)
              .children
              .first as TranslatableWord;
          final secondWordSecondWidget =
              (secondWordWidgetSpan.child as Row).children.last as Text;
          expect(secondWordFirstWidget.word, 'своё');
          expect(secondWordSecondWidget.data, '.');
        },
      );

      test(
        'question marks at the end of words get their own Text widget without custom paint',
        () {
          const sentence = "Всему' своё? вре'мя.";
          final spans = testObject.getSpansFromSentence(
            MockBuildContext(),
            sentenceExercise: Exercise<WordForm, Sentence>(
              question: Sentence.testValue(ru: sentence),
              answers: const [],
            ),
            defaultTextStyle: MockTextStyle(),
            tatoebaKey: 1,
            answerGiven: false,
          );
          final secondWordWidgetSpan = spans[2] as WidgetSpan;
          final secondWordFirstWidget = (secondWordWidgetSpan.child as Row)
              .children
              .first as TranslatableWord;
          final secondWordSecondWidget =
              (secondWordWidgetSpan.child as Row).children.last as Text;
          expect(secondWordFirstWidget.word, 'своё');
          expect(secondWordSecondWidget.data, '?');
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
                answers: const [],
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
                answers: const [],
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
                answers: const [],
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
                answers: const [],
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
                answers: const [],
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
                answers: const [],
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
