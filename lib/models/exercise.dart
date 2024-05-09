import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/question.dart';
import 'package:uchu/models/word.dart';

class Exercise<A extends Answer, Q extends Question<A>> extends Equatable {
  const Exercise({
    required this.question,
    required this.answer,
  });
  final Q question;
  final A? answer;

  bool get isCorrectAnswer {
    return answer == question.correctAnswer;
  }

  bool get isIncorrectAnswer {
    return answer != question.correctAnswer && answer == answer;
  }

  @visibleForTesting
  factory Exercise.testValue({
    required Q question,
    required A answer,
    Word? word,
    required String explanation,
  }) {
    word ??= Word.testValue();
    return Exercise(
      question: question,
      answer: answer,
    );
  }

  @override
  List<Object?> get props => [
        question,
        answer,
      ];
}

enum ExerciseType {
  determineNounGender,
  determineWordForm,
}
