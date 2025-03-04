import 'dart:async';
import "dart:math";

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/extensions/gender_extension.dart';
import 'package:grammatika/models/exercise.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:grammatika/services/exercise_cache_service.dart';
import 'package:grammatika/services/statistics_service.dart';
import 'package:grammatika/utilities/db_helper.dart';
import 'package:grammatika/utilities/explanation_helper.dart';

import '../../models/answer.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  Exercise? exercise;
  bool updatingSentenceExercises = false;
  bool updatingGenderExercises = false;
  List<Exercise<WordForm, Sentence>>? cachedSentenceExercises;
  List<Exercise<Gender, Noun>>? cachedGenderExercises;

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

        try {
          final exerciseCacheService =
              GetIt.instance.get<ExerciseCacheService>();

          Future<void> fetchExercises() async {
            updatingGenderExercises = true;
            final dbHelper = GetIt.instance.get<DbHelper>();
            final db = await dbHelper.getDatabase();

            final List<Map<String, dynamic>> nounQueryRows = (await db.rawQuery(
              dbHelper.randomNounQueryString(),
            ));

            for (var nounQueryRow in nounQueryRows) {
              try {
                final answers = Gender.values.map((gender) => gender.name);
                final explanation = GetIt.instance
                    .get<ExplanationHelper>()
                    .genderExplanation(
                        bare: nounQueryRow['bare'],
                        correctAnswer:
                            Gender.values.byName(nounQueryRow['gender']));
                final json = {
                  ...nounQueryRow,
                  'possible_answers': answers,
                  'explanation': explanation,
                };
                final noun = Noun.fromJson(json);
                final exercise = Exercise<Gender, Noun>(
                  question: noun,
                  answers: null,
                );
                cachedGenderExercises?.add(exercise);
              } catch (e) {
                print('Error: $e');
                continue;
              }
            }
          }

          print('asdf: ${cachedGenderExercises?.length}');

          cachedGenderExercises ??=
              await exerciseCacheService.cachedGenderExercises();

          if (cachedGenderExercises?.isNotEmpty == false) {
            await fetchExercises();
            updatingGenderExercises = false;
          }

          exercise = cachedGenderExercises?.removeAt(0);
          emit(
            ExerciseExerciseRetrievedState(),
          );

          if ((cachedGenderExercises?.length ?? 0) < 10 &&
              !updatingGenderExercises) {
            fetchExercises().then(
              (value) {
                exerciseCacheService
                    .updateExercises(cachedGenderExercises ?? []);
                updatingGenderExercises = false;
              },
            );
          } else if (!updatingGenderExercises) {
            exerciseCacheService.updateExercises(cachedGenderExercises ?? []);
          }
        } catch (e) {
          emit(
            ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
          );
        }
      }

      if (event is ExerciseRetrieveRandomSentenceEvent) {
        emit(ExerciseRetrievingExerciseState());
        try {
          final exerciseCacheService =
              GetIt.instance.get<ExerciseCacheService>();

          Future<void> fetchExercises() async {
            updatingSentenceExercises = true;
            final dbHelper = GetIt.instance.get<DbHelper>();
            final db = await dbHelper.getDatabase();

            final List<Map<String, dynamic>> sentenceQueryRows =
                (await db.rawQuery(
              dbHelper.randomSentenceQueryString(),
            ));

            for (var sentenceQueryRow in sentenceQueryRows) {
              try {
                final List<Map<String, dynamic>> answers = (await db.rawQuery(
                    'SELECT form_type, position AS word_form_position, form, _form_bare FROM words_forms WHERE word_id = ${sentenceQueryRow['word_id']} AND _form_bare IS NOT NULL;'));
                final correctAnswer = WordForm.fromJson(sentenceQueryRow);
                final (explanation, visualExplanation) =
                    GetIt.instance.get<ExplanationHelper>().sentenceExplanation(
                          correctAnswer: correctAnswer,
                          bare: sentenceQueryRow['bare'],
                          wordFormTypesToBareMap: <WordFormType, String>{
                            for (var answer in answers)
                              WordFormTypeExt.fromString(answer['form_type']):
                                  answer['_form_bare'],
                          },
                          gender: GenderExtension.fromString(
                              sentenceQueryRow['gender']),
                        );
                final json = {
                  ...sentenceQueryRow,
                  'answer_synonyms': answers.where((element) {
                    return element['_form_bare'] ==
                            sentenceQueryRow['_form_bare'] &&
                        element['form_type'] != sentenceQueryRow['form_type'];
                  }),
                  'possible_answers': answers,
                  'explanation': explanation,
                  'visual_explanation': visualExplanation,
                  ...correctAnswer.toJson(),
                };
                final sentence = Sentence.fromJson(json);
                final exercise = Exercise<WordForm, Sentence>(
                  question: sentence,
                  answers: null,
                );
                cachedSentenceExercises?.add(exercise);
              } catch (e) {
                print('Error: $e');
                continue;
              }
            }
          }

          cachedSentenceExercises ??=
              await exerciseCacheService.cachedSentenceExercises();

          if (cachedSentenceExercises?.isNotEmpty == false) {
            await fetchExercises();
            updatingSentenceExercises = false;
          }

          exercise = cachedSentenceExercises?.removeAt(0);
          emit(
            ExerciseExerciseRetrievedState(),
          );

          if ((cachedSentenceExercises?.length ?? 0) < 10 &&
              !updatingSentenceExercises) {
            fetchExercises().then(
              (value) {
                exerciseCacheService
                    .updateExercises(cachedSentenceExercises ?? []);
                updatingSentenceExercises = false;
              },
            );
          } else if (!updatingSentenceExercises) {
            exerciseCacheService.updateExercises(cachedSentenceExercises ?? []);
          }
        } catch (e) {
          emit(
            ExerciseErrorState(
                errorString: 'Unable to parse sentence from JSON'),
          );
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
