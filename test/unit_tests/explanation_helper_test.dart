import 'package:flutter_test/flutter_test.dart';
import 'package:uchu/explanation_helper.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';

main() {
  late ExplanationHelper testObject;

  setUp(() {
    testObject = ExplanationHelper();
  });

  group('genderExplanation', () {
    test('when last character in word is "ь"', () {
      const expected =
          'Most nouns ending in -ь are feminine, but there are many masculine ones too, so you have to learn the gender of soft-sign nouns.';
      final actual =
          testObject.genderExplanation(bare: 'стать', correctAnswer: Gender.f);
      expect(actual, expected);
    });

    group('when gender is male', () {
      test('when masculine noun endings list contains last character', () {
        const expected = 'Masculine nouns normally end with a consonant or -й.';
        final actual = testObject.genderExplanation(
            bare: 'человек', correctAnswer: Gender.m);
        expect(actual, expected);
      });

      test('when feminine noun endings list contains the last character', () {
        const expected =
            'Nouns ending in -а or -я which denote males are masculine. This may be the case here.';
        final actual = testObject.genderExplanation(
            bare: 'мужчина', correctAnswer: Gender.m);
        expect(actual, expected);
      });
    });

    group('when gender is female', () {
      test('when feminine noun endings list contains the last character', () {
        const expected = 'Feminine nouns normally end with -а or -я.';
        final actual =
            testObject.genderExplanation(bare: 'рука', correctAnswer: Gender.f);
        expect(actual, expected);
      });

      test(
          'when feminine noun endings list does not contain the last character, and the last character is not "ь"',
          () {
        const expected =
            'Foreign words denoting females are feminine, whatever their endings. This may be the case here.';
        final actual =
            testObject.genderExplanation(bare: 'леди', correctAnswer: Gender.f);
        expect(actual, expected);
      });
    });

    group('when gender is neuter', () {
      test('when neuter noun endings list contains the last character', () {
        const expected = 'Neuter nouns generally end in -о or -е.';
        final actual =
            testObject.genderExplanation(bare: 'дело', correctAnswer: Gender.n);
        expect(actual, expected);
      });

      test('when foreign neuter noun endings list contains the last character',
          () {
        const expected =
            'If a noun ends in -и or -у or -ю, it is likely to be a foreign borrowing and to be neuter.';
        final actual = testObject.genderExplanation(
            bare: 'такси', correctAnswer: Gender.n);
        expect(actual, expected);
      });
    });
  });

  group('sentenceExplanation', () {
    // TODO(DC): write sentenceExplanation tests
    group('when correctAnswer.type is ruVerbGerundPast', () {
      group('and word is reflexive', () {
        test('returns correct explanation', () {
          expect(
            testObject.sentenceExplanation(
              bare: 'авторизоваться',
              correctAnswer: WordForm.testValue(
                type: WordFormType.ruVerbGerundPast,
                position: 1,
                form: "авторизовавшись",
                formBare: 'авторизовавшись',
              ),
            ),
            'This word is a perfective gerund, also known as a perfective adverbial participle. Perfective gerunds are used to describe an action, preceding the action expressed by the main verb. Since the verb in this sentence is reflexive, you replace the "-ться" suffix with a "-вшись" suffix.',
          );
        });
      });

      group('and word is not reflexive', () {
        group('and position is 1', () {
          test(
              'and bare ends in "ть" and correctAnswer.bare ends in "в", returns correct explanation',
              () {
            expect(
              testObject.sentenceExplanation(
                bare: 'авторизовать',
                correctAnswer: WordForm.testValue(
                  type: WordFormType.ruVerbGerundPast,
                  position: 1,
                  form: "авторизова'в",
                  formBare: 'авторизовав',
                ),
              ),
              'This word is a perfective gerund, also known as a perfective adverbial participle. Perfective gerunds are used to describe an action, preceding the action expressed by the main verb. Since the verb in this sentence is not reflexive, you replace the "-ть" suffix with a "-в" suffix. Alternatively, you could replace the "-ть" suffix with a "-вши" suffix, though this is marked (colloquial, dated, or humorous).',
            );
          });

          test(
              'and bare does not end in "ть" or correctAnswer.bare does not end in "в", returns correct explanation',
              () {
            expect(
              testObject.sentenceExplanation(
                bare: 'агитировать',
                correctAnswer: WordForm.testValue(
                  type: WordFormType.ruVerbGerundPast,
                  position: 1,
                  form: "агитировавши",
                  formBare: 'агитировавши',
                ),
              ),
              'This word is a perfective gerund, also known as a perfective adverbial participle. Perfective gerunds are used to describe an action, preceding the action expressed by the main verb.',
            );
          });
        });

        group('and position is 2', () {
          test(
              'and bare ends in "ть" and correctAnswer.bare ends in "вши", returns correct explanation',
              () {
            expect(
              testObject.sentenceExplanation(
                bare: 'абонировать',
                correctAnswer: WordForm.testValue(
                  type: WordFormType.ruVerbGerundPast,
                  position: 2,
                  form: "абонировавши",
                  formBare: 'абонировавши',
                ),
              ),
              'This word is a perfective gerund, also known as a perfective adverbial participle. Perfective gerunds are used to describe an action, preceding the action expressed by the main verb. Since the verb in this sentence is not reflexive, you replace the "-ть" suffix with a "-вши" suffix. Alternatively, you could replace the "-ть" suffix with a "-в" suffix.',
            );
          });

          test(
              'and bare does not end in "ть" or correctAnswer.bare does not end in "вши", returns correct explanation',
              () {
            expect(
              testObject.sentenceExplanation(
                bare: 'броситься',
                correctAnswer: WordForm.testValue(
                  type: WordFormType.ruVerbGerundPast,
                  position: 2,
                  form: "бро'сясь",
                  formBare: 'бросясь',
                ),
              ),
              'This word is a perfective gerund, also known as a perfective adverbial participle. Perfective gerunds are used to describe an action, preceding the action expressed by the main verb.',
            );
          });
        });
      });
    });
  });
}
