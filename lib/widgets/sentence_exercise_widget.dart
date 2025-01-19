import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/blocs/translation/translation_bloc.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/utilities/exercise_helper.dart';
import 'package:uchu/utilities/url_helper.dart';
import 'package:uchu/widgets/translation_widget.dart';

import 'answer_card.dart';

class SentenceExerciseWidget extends StatelessWidget {
  const SentenceExerciseWidget({
    super.key,
    required this.exercise,
    this.exerciseHelper = const ExerciseHelper(),
  });

  final Exercise<WordForm, Sentence> exercise;
  final ExerciseHelper exerciseHelper;

  @override
  Widget build(BuildContext context) {
    final givenAnswers = exercise.answers;

    var nonTranslatableTextStyle = TextStyle(
      color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'What is the correct form of the word ',
                  style: nonTranslatableTextStyle,
                ),
                WidgetSpan(
                  child: InkWell(
                    child: Text(
                      exercise.question.word.bare,
                      style: translatableTextStyle,
                    ),
                    onTap: () async {
                      await GetIt.instance
                          .get<UrlHelper>()
                          .launchWiktionaryPageFor(exercise.question.word.bare);
                    },
                  ),
                ),
                TextSpan(
                  text: ' in the sentence:',
                  style: nonTranslatableTextStyle,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: UchuSpacing.M),
        //  TODO(DC): Write test around scenarios when the base word is the first word in the sentence and is capitalized.

        Center(
          child: RichText(
            key: const Key('sentence-rich-text'),
            text: TextSpan(
              children: [
                TextSpan(
                  text: '«',
                  style: nonTranslatableTextStyle,
                ),
                ...exerciseHelper.getSpansFromSentence(
                  sentenceExercise: exercise,
                  defaultTextStyle: DefaultTextStyle.of(context).style,
                ),
                TextSpan(
                  text: '»',
                  style: nonTranslatableTextStyle,
                ),
                WidgetSpan(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: IconButton(
                      padding: const EdgeInsets.all(4),
                      onPressed: () {
                        final tatoebaKey = exercise.question.tatoebaKey;
                        if (tatoebaKey == null) {
                          // TODO(DC): Handle this scenario
                          return;
                        }

                        showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: BlocProvider<TranslationBloc>(
                              create: (context) {
                                return TranslationBloc()
                                  ..add(TranslationFetchTranslationEvent(
                                      tatoebaKey: tatoebaKey));
                              },
                              child: const TranslationWidget(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.translate,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: UchuSpacing.L),

        Wrap(
          children: exerciseHelper
              .getAnswerGroupsForSentenceExercise(sentenceExercise: exercise)
              .map<String, Widget>((key, listOfAnswers) {
                final answerIsCorrect = exerciseHelper.getAnswerIsCorrect(
                    sentenceExercise: exercise,
                    givenAnswers: givenAnswers,
                    listOfAnswers: listOfAnswers);

                return MapEntry(
                  key,
                  AnswerCard<WordForm>(
                    answers: listOfAnswers,
                    displayString: key,
                    isCorrect: answerIsCorrect,
                  ),
                );
              })
              .values
              .toList(),
        ),
      ],
    );
  }
}
