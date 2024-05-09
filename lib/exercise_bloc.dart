import "dart:math";

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/explanation_helper.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc() : super(ExerciseInitial()) {
    on<ExerciseEvent>((event, emit) async {
      if (event is ExerciseRetrieveExerciseEvent) {
        final random = Random();
        final exerciseType =
            ExerciseType.values[random.nextInt(ExerciseType.values.length)];
        switch (exerciseType) {
          case ExerciseType.determineNounGender:
            add(ExerciseRetrieveRandomNounEvent());
          case ExerciseType.determineWordForm:
            add(ExerciseRetrieveRandomSentenceEvent());
        }
      }

      if (event is ExerciseRetrieveRandomNounEvent) {
        emit(ExerciseRetrievingExerciseState());

        try {
          final db = await GetIt.instance.get<DbHelper>().getDatabase();

          final Map<String, dynamic> nounQuery = (await db.rawQuery(
            '''SELECT *
FROM nouns
  INNER JOIN words ON words.id = nouns.word_id
WHERE gender IS NOT NULL
  AND gender IS NOT ''
  AND gender IS NOT 'both'
  AND gender IS NOT 'pl'
ORDER BY RANDOM()
LIMIT 1;
''',
          ))
              .single;
          final answers = Gender.values.map((gender) => gender.name);
          final explanation = GetIt.instance
              .get<ExplanationHelper>()
              .genderExplanation(
                  bare: nounQuery['bare'],
                  correctAnswer: Gender.values.byName(nounQuery['gender']));

          final json = {
            ...nounQuery,
            'possible_answers': answers,
            'explanation': explanation,
          };
          emit(
            ExerciseQuestionRetrievedState(
              exercise: Exercise<Gender, Noun>(
                question: Noun.fromJson(json),
                answer: null,
              ),
            ),
          );
        } catch (e) {
          emit(
            ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
          );
        }
      }

      if (event is ExerciseRetrieveRandomSentenceEvent) {
        emit(ExerciseRetrievingExerciseState());
        final db = await GetIt.instance.get<DbHelper>().getDatabase();

        final Map<String, dynamic> sentenceQuery = (await db.rawQuery(
          '''SELECT words.*,
       words.id AS word_id,
       words.disabled AS word_disabled,
       words.level AS word_level,
       sentences.id,
       sentences.ru,
       sentences.tatoeba_key,
       sentences.disabled,
       sentences.level,
       words_forms.*
FROM sentences_words
INNER JOIN sentences ON sentences.id = sentences_words.sentence_id
INNER JOIN words_forms ON words_forms.word_id = sentences_words.word_id
INNER JOIN words ON words.id = sentences_words.word_id
WHERE sentences_words.form_type IS NOT NULL
  AND sentences_words.form_type IS NOT 'ru_base'
  AND words_forms.form_type = sentences_words.form_type
ORDER BY RANDOM()
LIMIT 1;''',
        ))
            .single;

        final List<Map<String, dynamic>> answers = (await db.rawQuery(
            'SELECT form_type, form, _form_bare FROM words_forms WHERE word_id = ${sentenceQuery['word_id']};'));
        final explanation =
            GetIt.instance.get<ExplanationHelper>().sentenceExplanation();
        final json = {
          ...sentenceQuery,
          'possible_answers': answers,
          'explanation': explanation,
        };
        final sentence = Sentence.fromJson(json);

        emit(
          ExerciseQuestionRetrievedState(
            exercise: Exercise<WordForm, Sentence>(
              question: sentence,
              answer: null,
            ),
          ),
        );
      }

      if (event is ExerciseSubmitAnswerEvent) {
        emit(
          ExerciseAnswerSelectedState(
            exercise: event.exercise,
          ),
        );
      }
    });
  }
}
