import 'package:equatable/equatable.dart';
import 'package:grammatika/models/answer.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/noun.dart';
import 'package:grammatika/models/sentence.dart';
import 'package:grammatika/models/word_form.dart';

import 'json_serializable_mixin.dart';

abstract class Question<T extends Answer> extends Equatable
    implements JsonSerializable {
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

  static Question fromJson<T extends Answer>(Map<String, dynamic> json) {
    if (T is Gender) {
      return Noun.fromJson(json);
    } else if (T is WordForm) {
      return Sentence.fromJson(json);
    } else {
      throw Exception();
    }
  }
}
