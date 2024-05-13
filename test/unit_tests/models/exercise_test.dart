import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/noun.dart';
import 'package:uchu/models/sentence.dart';
import 'package:uchu/models/word_form.dart';

main() {
  group('type', () {
    test(
        'returns ExerciseType.determineNounGender when A is Gender and Q is Noun',
        () {
      expect(
        Exercise<Gender, Noun>(question: Noun.testValue(), answer: null).type,
        ExerciseType.determineNounGender,
      );
    });

    test(
        'returns ExerciseType.determineWordForm when A is WordForm and Q is Sentence',
        () {
      expect(
        Exercise<WordForm, Sentence>(
                question: Sentence.testValue(), answer: null)
            .type,
        ExerciseType.determineWordForm,
      );
    });
  });

  group('isCorrectAnswer', () {
    test('is true when answer equals correctAnswer', () {
      expect(
          Exercise<Gender, Noun>(
                  answer: Gender.m, question: Noun.testValue(gender: Gender.m))
              .isCorrectAnswer,
          isTrue);
    });

    test('is false when answer does not equal correctAnswer', () {
      expect(
          Exercise<Gender, Noun>(
                  answer: Gender.m, question: Noun.testValue(gender: Gender.f))
              .isCorrectAnswer,
          isFalse);
    });
  });

  group('isIncorrectAnswer', () {
    test('is true when answer does not equal correctAnswer', () {
      expect(
          Exercise<Gender, Noun>(
                  answer: Gender.m, question: Noun.testValue(gender: Gender.f))
              .isIncorrectAnswer,
          isTrue);
    });

    test('is false when answer equals correctAnswer', () {
      expect(
          Exercise<Gender, Noun>(
                  answer: Gender.m, question: Noun.testValue(gender: Gender.m))
              .isIncorrectAnswer,
          isFalse);
    });
  });
}
