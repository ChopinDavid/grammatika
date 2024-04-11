import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uchu/models/word.dart';

class Answer<T> extends Equatable {
  const Answer._({
    required this.answer,
    required this.correctAnswer,
    required this.word,
  });
  final T answer;
  final T? correctAnswer;
  final Word word;

  factory Answer.initial({
    required T answer,
    required Word word,
  }) =>
      Answer<T>._(answer: answer, correctAnswer: null, word: word);

  Answer<T> gradeAnswer({required T correctAnswer}) {
    return Answer<T>._(
        answer: answer, correctAnswer: correctAnswer, word: word);
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
  }) {
    word ??= Word.testValue();
    return Answer._(
      answer: answer,
      correctAnswer: correctAnswer,
      word: word,
    );
  }

  @override
  List<Object?> get props => [
        answer,
        correctAnswer,
        word,
      ];
}
