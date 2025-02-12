import "dart:math";

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/extensions/gender_extension.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/services/enabled_exercises_service.dart';
import 'package:uchu/services/statistics_service.dart';
import 'package:uchu/utilities/db_helper.dart';
import 'package:uchu/utilities/explanation_helper.dart';

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

        try {
          final dbHelper = GetIt.instance.get<DbHelper>();
          final db = await dbHelper.getDatabase();

          final Map<String, dynamic> nounQuery = (await db.rawQuery(
            dbHelper.randomNounQueryString(),
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
          exercise = Exercise<Gender, Noun>(
            question: Noun.fromJson(json),
            answers: null,
          );
          emit(
            ExerciseExerciseRetrievedState(),
          );
        } catch (e) {
          emit(
            ExerciseErrorState(errorString: 'Unable to parse noun from JSON'),
          );
        }
      }

      if (event is ExerciseRetrieveRandomSentenceEvent) {
        emit(ExerciseRetrievingExerciseState());
        try {
          final dbHelper = GetIt.instance.get<DbHelper>();
          final db = await dbHelper.getDatabase();

          final Map<String, dynamic> sentenceQuery = (await db.rawQuery(
            dbHelper.randomSentenceQueryString(),
          ))
              .single;

          final List<Map<String, dynamic>> answers = (await db.rawQuery(
              'SELECT form_type, position AS word_form_position, form, _form_bare FROM words_forms WHERE word_id = ${sentenceQuery['word_id']};'));
          final correctAnswer = WordForm.fromJson(sentenceQuery);
          final (explanation, visualExplanation) =
              GetIt.instance.get<ExplanationHelper>().sentenceExplanation(
                    correctAnswer: correctAnswer,
                    bare: sentenceQuery['bare'],
                    wordFormTypesToBareMap: <WordFormType, String>{
                      for (var answer in answers)
                        WordFormTypeExt.fromString(answer['form_type']):
                            answer['_form_bare'],
                    },
                    gender: GenderExtension.fromString(sentenceQuery['gender']),
                  );
          final json = {
            ...sentenceQuery,
            'answer_synonyms': answers.where((element) {
              return element['_form_bare'] == sentenceQuery['_form_bare'] &&
                  element['form_type'] != sentenceQuery['form_type'];
            }),
            'possible_answers': answers,
            'explanation': explanation,
            'visual_explanation': visualExplanation,
          };
          final sentence = Sentence.fromJson(json);

          exercise = Exercise<WordForm, Sentence>(
            question: sentence,
            answers: null,
          );

          emit(
            ExerciseExerciseRetrievedState(),
          );
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
          GetIt.instance.get<StatisticsService>().addExercisePassed(exerciseId);
        } else {
          GetIt.instance.get<StatisticsService>().addExerciseFailed(exerciseId);
        }
        exercise = exercise?.withAnswers(answers);
        emit(
          ExerciseAnswerSelectedState(),
        );
      }
    });
  }
}
