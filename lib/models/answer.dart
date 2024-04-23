import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uchu/models/word.dart';

class Answer<T> extends Equatable {
  const Answer._({
    required this.answer,
    required this.correctAnswer,
    required this.word,
    required this.explanation,
  });
  final T answer;
  final T? correctAnswer;
  final Word word;
  final String? explanation;

  factory Answer.initial({
    required T answer,
    required Word word,
  }) =>
      Answer<T>._(
          answer: answer, correctAnswer: null, word: word, explanation: null);

  Answer<T> gradeAnswer(
      {required T correctAnswer, required String? explanation}) {
    return Answer<T>._(
      answer: answer,
      correctAnswer: correctAnswer,
      word: word,
      explanation: explanation,
    );
  }

  bool? get isCorrectAnswer {
    if (correctAnswer == null) {
      return null;
    }
    return answer == correctAnswer;
  }

  bool? get isIncorrectAnswer {
    if (correctAnswer == null) {
      return null;
    }
    return answer != correctAnswer && answer == answer;
  }

  @visibleForTesting
  factory Answer.testValue({
    required T answer,
    T? correctAnswer,
    Word? word,
    String? explanation,
  }) {
    word ??= Word.testValue();
    return Answer._(
      answer: answer,
      correctAnswer: correctAnswer,
      word: word,
      explanation: explanation,
    );
  }

  @override
  List<Object?> get props => [
        answer,
        correctAnswer,
        word,
        explanation,
      ];
}
