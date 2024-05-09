import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/models/exercise.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word.dart';

main() {
  group('gradeAnswer', () {
    test('adds a correctAnswer', () {
      final word = Word.testValue();
      const explanation = 'some explanation';
      final expected = Exercise<Gender>.testValue(
          answer: Gender.m,
          correctAnswer: Gender.f,
          word: word,
          explanation: explanation);
      final actual = Exercise<Gender>.initial(answer: Gender.m, word: word)
          .addExplanation(correctAnswer: Gender.f, explanation: explanation);
      expect(actual, expected);
    });
  });

  group('isCorrectAnswer', () {
    test('returns null if correctAnswer is null', () {
      expect(
          Exercise<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .isCorrectAnswer,
          isNull);
    });

    test('is true when answer equals correctAnswer', () {
      expect(
          Exercise<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .addExplanation(correctAnswer: Gender.m, explanation: null)
              .isCorrectAnswer,
          isTrue);
    });

    test('is false when answer does not equal correctAnswer', () {
      expect(
          Exercise<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .addExplanation(correctAnswer: Gender.f, explanation: null)
              .isCorrectAnswer,
          isFalse);
    });
  });

  group('isIncorrectAnswer', () {
    test('throws if correctAnswer is null', () {
      expect(
          Exercise<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .isIncorrectAnswer,
          isNull);
    });

    test('is true when answer does not equal correctAnswer', () {
      expect(
          Exercise<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .addExplanation(correctAnswer: Gender.f, explanation: null)
              .isIncorrectAnswer,
          isTrue);
    });

    test('is false when answer equals correctAnswer', () {
      expect(
          Exercise<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .addExplanation(correctAnswer: Gender.m, explanation: null)
              .isIncorrectAnswer,
          isFalse);
    });
  });
}
