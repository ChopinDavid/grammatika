import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word.dart';

main() {
  group('gradeAnswer', () {
    test('adds a correctAnswer', () {
      final word = Word.testValue();
      final expected = Answer<Gender>.testValue(
          answer: Gender.m, correctAnswer: Gender.f, word: word);
      final actual = Answer<Gender>.initial(answer: Gender.m, word: word)
          .gradeAnswer(correctAnswer: Gender.f);
      expect(actual, expected);
    });
  });

  group('isCorrectAnswer', () {
    test('returns null if correctAnswer is null', () {
      expect(
          Answer<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .isCorrectAnswer,
          isNull);
    });

    test('is true when answer equals correctAnswer', () {
      expect(
          Answer<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .gradeAnswer(correctAnswer: Gender.m)
              .isCorrectAnswer,
          isTrue);
    });

    test('is false when answer does not equal correctAnswer', () {
      expect(
          Answer<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .gradeAnswer(correctAnswer: Gender.f)
              .isCorrectAnswer,
          isFalse);
    });
  });

  group('isIncorrectAnswer', () {
    test('throws if correctAnswer is null', () {
      expect(
          Answer<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .isIncorrectAnswer,
          isNull);
    });

    test('is true when answer does not equal correctAnswer', () {
      expect(
          Answer<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .gradeAnswer(correctAnswer: Gender.f)
              .isIncorrectAnswer,
          isTrue);
    });

    test('is false when answer equals correctAnswer', () {
      expect(
          Answer<Gender>.initial(answer: Gender.m, word: Word.testValue())
              .gradeAnswer(correctAnswer: Gender.m)
              .isIncorrectAnswer,
          isFalse);
    });
  });
}
