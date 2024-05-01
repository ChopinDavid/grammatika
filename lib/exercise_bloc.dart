import "dart:math";

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/answer_helper.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/models/word_form.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc(
      {@visibleForTesting AnswerHelper answerHelper = const AnswerHelper()})
      : super(ExerciseInitial()) {
    on<ExerciseEvent>((event, emit) async {
      if (event is ExerciseRetrieveExerciseEvent) {
        final random = Random();
        final exerciseType = Exercise.values[1];
        switch (exerciseType) {
          case Exercise.determineNounGender:
            add(ExerciseRetrieveRandomNounEvent());
          case Exercise.determineWordForm:
            add(ExerciseRetrieveRandomSentenceEvent());
        }
      }

      if (event is ExerciseRetrieveRandomNounEvent) {
        emit(ExerciseRetrievingRandomNounState());

        try {
          final db = await GetIt.instance.get<DbHelper>().getDatabase();

          final noun = Noun.fromJson(
            ((await db.rawQuery(
                        'SELECT * FROM nouns WHERE gender IS NOT NULL AND gender IS NOT "" AND gender IS NOT "both" AND gender IS NOT "pl" ORDER BY RANDOM() LIMIT 1;'))
                    as List<Map<String, dynamic>>)
                .single,
          );

          final word = await noun.word;

          emit(
            ExerciseRandomNounRetrievedState(
              noun: noun,
              word: word,
            ),
          );
        } catch (e) {
          emit(
            ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
          );
        }
      }

      if (event is ExerciseRetrieveRandomSentenceEvent) {
        final db = await GetIt.instance.get<DbHelper>().getDatabase();
        final sentence = Sentence.fromJson((await db.rawQuery(
          '''SELECT sentences_words.word_id,
       sentences.id,
       sentences.ru,
       sentences.tatoeba_key,
       sentences.disabled,
       sentences.level,
       words_forms.form_type
FROM sentences_words
INNER JOIN sentences ON sentences.id = sentences_words.sentence_id
INNER JOIN words_forms ON words_forms.word_id = sentences_words.word_id
INNER JOIN words ON words.id = sentences_words.word_id
WHERE sentences_words.form_type IS NOT NULL
  AND sentences_words.form_type IS NOT "ru_base"
  AND words_forms.form_type = sentences_words.form_type
ORDER BY RANDOM()
LIMIT 1;''',
        ))
            .single);

        final answers = (await db.rawQuery(
                'SELECT form_type, form, _form_bare FROM words_forms WHERE word_id = ${sentence.wordId};'))
            .map((wordFormMap) => WordForm.fromJson(wordFormMap))
            .toList();

        final state = ExerciseRandomSentenceRetrievedState(
          sentence: sentence.withPossibleAnswers(
            answers,
          ),
        );
        emit(state);
      }

      if (event is ExerciseSubmitAnswerEvent) {
        final gradedAnswer = await answerHelper.processAnswer(
          answer: event.answer,
        );

        emit(ExerciseExerciseGradedState(answer: gradedAnswer));
      }
    });
  }
}
