import "dart:math";

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:grammatika/services/exercise_cache_service.dart';
import 'package:grammatika/services/statistics_service.dart';

import '../../models/answer.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  Exercise? exercise;

  ExerciseBloc({@visibleForTesting Random? mockRandom})
      : super(ExerciseInitial()) {
    on<ExerciseEvent>((event, emit) async {
      if (event is ExerciseRetrieveExerciseEvent) {
        final random = mockRandom ?? Random();
        var exerciseTypes = List.from(ExerciseType.values);
        final disabledExercises = GetIt.instance
            .get<EnabledExercisesService>()
            .getDisabledExercises();
        final enabledGenderExercises = Gender.values.where((element) =>
            !disabledExercises.contains(element.name) &&
            element != Gender.both &&
            element != Gender.pl);
        final enabledWordFormExercises = WordFormType.values.where(
          (element) {
            return !disabledExercises.contains(element.name) &&
                element != WordFormType.ruBase &&
                element != WordFormType.ruAdjComparative &&
                element != WordFormType.ruAdjSuperlative &&
                element != WordFormType.ruAdjShortM &&
                element != WordFormType.ruAdjShortF &&
                element != WordFormType.ruAdjShortN &&
                element != WordFormType.ruAdjShortPl;
          },
        );
        if (enabledGenderExercises.isEmpty) {
          exerciseTypes.removeWhere(
            (element) => element == ExerciseType.determineNounGender,
          );
        }
        if (enabledWordFormExercises.isEmpty) {
          exerciseTypes.removeWhere(
            (element) => element == ExerciseType.determineWordForm,
          );
        }
        final exerciseType =
            exerciseTypes[random.nextInt(exerciseTypes.length)];
        switch (exerciseType) {
          case ExerciseType.determineNounGender:
            add(ExerciseRetrieveRandomNounEvent());
          case ExerciseType.determineWordForm:
            add(ExerciseRetrieveRandomSentenceEvent());
        }
      }

      if (event is ExerciseRetrieveRandomNounEvent) {
        emit(ExerciseRetrievingExerciseState());

        final exerciseCacheService = GetIt.instance.get<ExerciseCacheService>();

        try {
          exercise = await exerciseCacheService.getCachedGenderExercise();

          emit(
            ExerciseExerciseRetrievedState(),
          );
        } catch (e) {
          emit(
            ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
          );
        }

        try {
          exerciseCacheService.reCacheGenderExercisesIfNeeded();
        } catch (e) {
          emit(ExerciseErrorState(
              errorString: 'Unable to re-cache gender exercises'));
        }
      }

      if (event is ExerciseRetrieveRandomSentenceEvent) {
        emit(ExerciseRetrievingExerciseState());

        final exerciseCacheService = GetIt.instance.get<ExerciseCacheService>();

        try {
          exercise = await exerciseCacheService.getCachedSentenceExercise();

          emit(
            ExerciseExerciseRetrievedState(),
          );
        } catch (e) {
          emit(
            ExerciseErrorState(
                errorString: 'Unable to parse sentence from JSON'),
          );
        }

        try {
          exerciseCacheService.reCacheSentenceExercisesIfNeeded();
        } catch (e) {
          emit(ExerciseErrorState(
              errorString: 'Unable to re-cache sentence exercises'));
        }
      }

      if (event is ExerciseSubmitAnswerEvent) {
        final answers = event.answers;
        final correctAnswer = exercise?.question.correctAnswer;
        final exerciseId = correctAnswer is WordForm
            ? correctAnswer.type.name
            : correctAnswer is Gender
                ? correctAnswer.name
                : null;

        if (exerciseId == null) {
          emit(ExerciseErrorState(
              errorString: 'Unable to determine exercise answer ID.'));
          return;
        }

        if (event.answers.contains(exercise?.question.correctAnswer) == true) {
          GetIt.instance
              .get<StatisticsService>()
              .addExercisePassed(exerciseId, DateTime.now());
        } else {
          GetIt.instance
              .get<StatisticsService>()
              .addExerciseFailed(exerciseId, DateTime.now());
        }
        exercise = exercise?.withAnswers(answers);
        emit(
          ExerciseAnswerSelectedState(),
        );
      }
    });
  }
}
