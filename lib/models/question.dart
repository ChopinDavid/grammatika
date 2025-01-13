import 'package:equatable/equatable.dart';
import 'package:uchu/models/answer.dart';

class Question<T extends Answer> extends Equatable {
  const Question({
    required this.correctAnswer,
    required this.answerSynonyms,
    required this.possibleAnswers,
    required this.explanation,
    required this.visualExplanation,
  });
  final T correctAnswer;
  final List<T> answerSynonyms;
  final List<T> possibleAnswers;
  final String explanation;
  final String? visualExplanation;

  @override
  List<Object?> get props => [
        correctAnswer,
        answerSynonyms,
        possibleAnswers,
        explanation,
        visualExplanation,
      ];
}
