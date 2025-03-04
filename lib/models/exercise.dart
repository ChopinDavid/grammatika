import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:grammatika/models/answer.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/question.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';

import 'json_serializable_mixin.dart';

class Exercise<A extends Answer, Q extends Question<A>> extends Equatable
    implements JsonSerializable {
  const Exercise({
    required this.question,
    required this.answers,
  });
  final Q question;
  final List<A>? answers;

  ExerciseType get type {
    if (A == Gender && Q == Noun) {
      return ExerciseType.determineNounGender;
    }

    if (A == WordForm && Q == Sentence) {
      return ExerciseType.determineWordForm;
    }

    /*LCOV_EXCL_LINE*/ throw UnsupportedError(
      'ExerciseType not yet defined for Answer type: $A and Question type: $Q',
    );
  }

  Exercise<A, Q> withAnswers(List<A> answers) {
    return Exercise<A, Q>(question: question, answers: answers);
  }

  @visibleForTesting
  factory Exercise.testValue({
    required Q question,
    required List<A> answers,
  }) =>
      Exercise<A, Q>(
        question: question,
        answers: answers,
      );

  @visibleForTesting
  factory Exercise.testValueSimple({required Q question, List<A>? answers}) =>
      Exercise<A, Q>(question: question, answers: answers);

  @override
  List<Object?> get props => [
        question,
        answers,
      ];

  static Exercise fromJson<A extends Answer, Q extends Question<A>>(
      Map<String, dynamic> json) {
    if (Q == Noun) {
      return Exercise<Gender, Noun>(
        question: Noun.fromJson(json['question']),
        answers: null,
      );
    } else if (Q == Sentence) {
      return Exercise<WordForm, Sentence>(
        question: Sentence.fromJson(json['question']),
        answers: null,
      );
    } else {
      throw Exception();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'question': question.toJson(),
      'answers': answers?.map((e) => e.toJson()).toList(),
    };
  }
}

enum ExerciseType {
  determineNounGender,
  determineWordForm,
}
