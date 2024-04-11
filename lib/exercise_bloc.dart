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
import 'package:uchu/models/word.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc(
      {@visibleForTesting AnswerHelper answerHelper = const AnswerHelper()})
      : super(ExerciseInitial()) {
    on<ExerciseEvent>((event, emit) async {
      if (event is ExerciseRetrieveExerciseEvent) {
        final random = Random();
        final exerciseType =
            Exercise.values[random.nextInt(Exercise.values.length)];
        if (exerciseType == Exercise.determineNounGender) {
          add(ExerciseRetrieveRandomNounEvent());
        }
      }

      if (event is ExerciseRetrieveRandomNounEvent) {
        emit(ExerciseRetrievingRandomNounState());

        try {
          final db = await GetIt.instance.get<DbHelper>().getDatabase();

          final noun = Noun.fromJson(
            ((await db.rawQuery(
                        "SELECT * FROM nouns WHERE gender IS NOT NULL ORDER BY RANDOM() LIMIT 1;"))
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

      if (event is ExerciseSubmitAnswerEvent) {
        final gradedAnswer = await answerHelper.processAnswer(
          answer: event.answer,
        );

        emit(ExerciseExerciseGradedState(answer: gradedAnswer));
      }
    });
  }
}
