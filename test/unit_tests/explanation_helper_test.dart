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
          const bare = 'авторизоваться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbGerundPast,
            position: 1,
            form: "авторизовавшись",
            bare: 'авторизовавшись',
          );
          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a perfective gerund, also known as a perfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is perfective, meaning that the gerund denotes a result or completed action, having taken place before the main verb. Since the verb in this sentence is reflexive, you replace the "-ться" suffix with a "-вшись" suffix.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
      });

      group('and word is not reflexive', () {
        group('and position is 1', () {
          test(
              'and bare ends in "ть" and correctAnswer.bare ends in "в", returns correct explanation',
              () {
            const bare = 'авторизовать';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbGerundPast,
              position: 1,
              form: "авторизова'в",
              bare: 'авторизовав',
            );
            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              'This word is a perfective gerund, also known as a perfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is perfective, meaning that the gerund denotes a result or completed action, having taken place before the main verb. Since the verb in this sentence is not reflexive, you replace the "-ть" suffix with a "-в" suffix. Alternatively, you could replace the "-ть" suffix with a "-вши" suffix, though this is marked (colloquial, dated, or humorous).\n\n$bare -> ${correctAnswer.bare}',
            );
          });

          test(
              'and bare does not end in "ть" or correctAnswer.bare does not end in "в", returns correct explanation',
              () {
            const bare = 'агитировать';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbGerundPast,
              position: 1,
              form: "агитировавши",
              bare: 'агитировавши',
            );
            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              'This word is a perfective gerund, also known as a perfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is perfective, meaning that the gerund denotes a result or completed action, having taken place before the main verb.\n\n$bare -> ${correctAnswer.bare}',
            );
          });
        });

        group('and position is 2', () {
          test(
              'and bare ends in "ть" and correctAnswer.bare ends in "вши", returns correct explanation',
              () {
            const bare = 'абонировать';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbGerundPast,
              position: 2,
              form: "абонировавши",
              bare: 'абонировавши',
            );
            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              'This word is a perfective gerund, also known as a perfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is perfective, meaning that the gerund denotes a result or completed action, having taken place before the main verb. Since the verb in this sentence is not reflexive, you replace the "-ть" suffix with a "-вши" suffix. Alternatively, you could replace the "-ть" suffix with a "-в" suffix.\n\n$bare -> ${correctAnswer.bare}',
            );
          });

          test(
              'and bare does not end in "ть" or correctAnswer.bare does not end in "вши", returns correct explanation',
              () {
            const bare = 'броситься';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbGerundPast,
              position: 2,
              form: "бро'сясь",
              bare: 'бросясь',
            );
            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              'This word is a perfective gerund, also known as a perfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is perfective, meaning that the gerund denotes a result or completed action, having taken place before the main verb.\n\n$bare -> ${correctAnswer.bare}',
            );
          });
        });
      });
    });

    group('when correctAnswer.type is ruVerbGerundPresent', () {
      group('and word is reflexive', () {
        test(
            'returns correct explanation when not using "a" follows "ж", "ш", "ч", "щ" spelling rule',
            () {
          const bare = 'адресоваться';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'адресуются'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbGerundPresent,
            position: 1,
            form: "адресу'ясь",
            bare: 'адресуясь',
          );
          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperfective gerund, also known as an imperfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is imperfective, meaning that the gerund denotes a process or incomplete action, taking place simultaneously with the main verb. Since the verb in this sentence is reflexive, you take the third person plural form of the verb and replace its suffix with either a "-ась" or "-ясь" suffix. Since "a" always follows "ж", "ш", "ч", or "щ", we will use "-ясь" in this case.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });

        test(
            'returns correct explanation when using "a" follows "ж", "ш", "ч", "щ" spelling rule',
            () {
          const bare = 'учиться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbGerundPresent,
            position: 1,
            form: "уча'сь",
            bare: 'учась',
          );
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'учатся'
          };

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperfective gerund, also known as an imperfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is imperfective, meaning that the gerund denotes a process or incomplete action, taking place simultaneously with the main verb. Since the verb in this sentence is reflexive, you take the third person plural form of the verb and replace its suffix with either a "-ась" or "-ясь" suffix. Since "a" always follows "ж", "ш", "ч", or "щ", we will use "-ась" in this case.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
      });

      group('and word is not reflexive', () {
        group('and position is 1', () {
          test(
              'returns correct explanation when not using "a" follows "ж", "ш", "ч", "щ" spelling rule',
              () {
            const bare = 'алеть';
            final wordFormTypesToBareMap = {
              WordFormType.ruVerbPresfutPl3: 'алеют'
            };
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbGerundPresent,
              position: 1,
              form: "але'я",
              bare: 'алея',
            );
            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: wordFormTypesToBareMap,
              ),
              'This word is an imperfective gerund, also known as an imperfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is imperfective, meaning that the gerund denotes a process or incomplete action, taking place simultaneously with the main verb. Since the verb in this sentence is not reflexive, you take the third person plural form of the verb and replace its suffix with either a "-а" or "-я" suffix. Since "a" always follows "ж", "ш", "ч", or "щ", we will use "-я" in this case.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
            );
          });

          test(
              'returns correct explanation when using "a" follows "ж", "ш", "ч", "щ" spelling rule',
              () {
            const bare = 'брезжить';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbGerundPresent,
              position: 1,
              form: "бре'зжа'",
              bare: 'брезжа',
            );
            final wordFormTypesToBareMap = {
              WordFormType.ruVerbPresfutPl3: 'брезжат'
            };

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: wordFormTypesToBareMap,
              ),
              'This word is an imperfective gerund, also known as an imperfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is imperfective, meaning that the gerund denotes a process or incomplete action, taking place simultaneously with the main verb. Since the verb in this sentence is not reflexive, you take the third person plural form of the verb and replace its suffix with either a "-а" or "-я" suffix. Since "a" always follows "ж", "ш", "ч", or "щ", we will use "-а" in this case.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
            );
          });
        });

        group('and position is 2', () {
          // TODO(DC): explore whether imperfective gerunds with position 2 need any special handling
        });
      });
    });

    group('when correctAnswer.type is ruAdjMNom', () {
      test('returns correct explanation when word ends in "-ый"', () {
        const bare = 'алый';
        final correctAnswer = WordForm.testValue(
          type: WordFormType.ruAdjMNom,
          position: 1,
          form: "а'лый",
          bare: 'алый',
        );

        expect(
          testObject.sentenceExplanation(
            bare: bare,
            correctAnswer: correctAnswer,
            wordFormTypesToBareMap: {},
          ),
          'This word is a masculine adjective in the nominative case. This means that it is a word that modifies a masculine noun that is the subject of a verb. The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, nominative adjective with a hard-consonant stem, we add the "-ый" suffix after the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
        );
      });

      test('returns correct explanation when word ends in "-ий"', () {
        const bare = 'синий';
        final correctAnswer = WordForm.testValue(
          type: WordFormType.ruAdjMNom,
          position: 1,
          form: "си'ний",
          bare: 'синий',
        );

        expect(
          testObject.sentenceExplanation(
            bare: bare,
            correctAnswer: correctAnswer,
            wordFormTypesToBareMap: {},
          ),
          'This word is a masculine adjective in the nominative case. This means that it is a word that modifies a masculine noun that is the subject of a verb. Masculine, nominative adjectives with stems ending in a soft "-н" get a "-ий" suffix after their stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
        );
      });

      test('returns correct explanation when word ends in "-ий"', () {
        const bare = 'ангельский';
        final correctAnswer = WordForm.testValue(
          type: WordFormType.ruAdjMNom,
          position: 1,
          form: "а'нгельский",
          bare: 'ангельский',
        );

        expect(
          testObject.sentenceExplanation(
            bare: bare,
            correctAnswer: correctAnswer,
            wordFormTypesToBareMap: {},
          ),
          'This word is a masculine adjective in the nominative case. This means that it is a word that modifies a masculine noun that is the subject of a verb. Masculine, nominative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", or "-щ" get a "-ий" suffix after their stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
        );
      });

      test('returns correct explanation when word ends in "-ой"', () {
        const bare = 'другой';
        final correctAnswer = WordForm.testValue(
          type: WordFormType.ruAdjMNom,
          position: 1,
          form: "а'друго'й",
          bare: 'другой',
        );

        expect(
          testObject.sentenceExplanation(
            bare: bare,
            correctAnswer: correctAnswer,
            wordFormTypesToBareMap: {},
          ),
          'This word is a masculine adjective in the nominative case. This means that it is a word that modifies a masculine noun that is the subject of a verb. There is a small group of masculine, nominative adjectives that end in "-ой" instead of "-ый" or "-ий". This is one such adjective. These adjectives ending in "-ой" are always stressed on the "о" in their suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
        );
      });
    });

    group('when correctAnswer.type is ruAdjMGen', () {
      test('returns correct explanation when word ends in "-ого"', () {
        const bare = 'августовский';
        final correctAnswer = WordForm.testValue(
          type: WordFormType.ruAdjMGen,
          position: 1,
          form: "а'вгустовского",
          bare: 'августовского',
        );

        expect(
          testObject.sentenceExplanation(
            bare: bare,
            correctAnswer: correctAnswer,
            wordFormTypesToBareMap: {},
          ),
          'This word is a masculine adjective in the genitive case. This means that it is a word that modifies a masculine noun that indicates possession, origin, or close association of or to another noun. The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, genitive adjective with a hard-consonant stem, we add the "-ого" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
        );
      });

      test('returns correct explanation when word ends in "-его"', () {
        const bare = 'акавший';
        final correctAnswer = WordForm.testValue(
          type: WordFormType.ruAdjMGen,
          position: 1,
          form: "а'кавшего",
          bare: 'акавшего',
        );

        expect(
          testObject.sentenceExplanation(
            bare: bare,
            correctAnswer: correctAnswer,
            wordFormTypesToBareMap: {},
          ),
          'This word is a masculine adjective in the genitive case. This means that it is a word that modifies a masculine noun that indicates possession, origin, or close association of or to another noun. Masculine, genitive adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
        );
      });

      group('when correctAnswer.type is ruAdjMDat', () {
        test('returns correct explanation when word ends in "-ому"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMDat,
            position: 1,
            form: "а'вгустовскому",
            bare: 'августовскому',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the dative case. This means that it is a word that modifies a masculine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, dative adjective with a hard-consonant stem, we add the "-ому" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });

        test('returns correct explanation when word ends in "-ему"', () {
          const bare = 'акавший';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMDat,
            position: 1,
            form: "а'кавшему",
            bare: 'акавшему',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the dative case. This means that it is a word that modifies a masculine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. Masculine, dative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ему" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });

      group('when correctAnswer.type is ruAdjMAcc', () {
        test(
            'returns correct explanation when ends in "-ый" and bare and correctAnswer.bare are identical, i.e. the noun being described is inanimate',
            () {
          const bare = 'адовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMAcc,
            position: 1,
            form: "а'довый",
            bare: 'адовый',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the accusative case. This means that it is a word that modifies a masculine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, accusative adjective with a hard-consonant stem, we add the "-ый" suffix after the stem. This form is identical to the nominative form since the noun being described is inanimate, i.e. not a person or animal.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ний" and bare and correctAnswer.bare are identical, i.e. the noun being described is inanimate',
            () {
          const bare = 'бараний';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMAcc,
            position: 1,
            form: "бара'ний",
            bare: 'бараний',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the accusative case. This means that it is a word that modifies a masculine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Masculine, accusative adjectives with stems ending in a soft "-н" get a "-ий" suffix after their stem. This form is identical to the nominative form since the noun being described is inanimate, i.e. not a person or animal.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ий" and bare and correctAnswer.bare are identical, i.e. the noun being described is inanimate',
            () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMAcc,
            position: 1,
            form: "а'вгустовский",
            bare: 'августовский',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the accusative case. This means that it is a word that modifies a masculine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Masculine, accusative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", or "-щ" get a "-ий" suffix after their stem. This form is identical to the nominative form since the noun being described is inanimate, i.e. not a person or animal.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });

        test(
            'returns correct explanation when ends in "-ой" and bare and correctAnswer.bare are identical, i.e. the noun being described is inanimate',
            () {
          const bare = 'затяжной';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMAcc,
            position: 1,
            form: "затяжной",
            bare: 'затяжной',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the accusative case. This means that it is a word that modifies a masculine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. There is a small group of masculine, accusative adjectives that end in "-ой" instead of "-ый" or "-ий". This is one such adjective. These adjectives ending in "-ой" are always stressed on the "о" in their suffix. This form is identical to the nominative form since the noun being described is inanimate, i.e. not a person or animal.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when word ends in "-ого"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMAcc,
            position: 1,
            form: "а'вгустовского",
            bare: 'августовского',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the accusative case. This means that it is a word that modifies a masculine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, accusative adjective with a hard-consonant stem, we add the "-ого" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });

        test('returns correct explanation when word ends in "-его"', () {
          const bare = 'акавший';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMAcc,
            position: 1,
            form: "а'кавшего",
            bare: 'акавшего',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the accusative case. This means that it is a word that modifies a masculine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Masculine, accusative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });

      group('when correctAnswer.type is ruAdjMInst', () {
        test(
            'returns correct explanation when ends in "-ым" and bare ends in "-ой"',
            () {
          const bare = 'берестяной';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMInst,
            position: 1,
            form: "берестяны'м",
            bare: 'берестяным',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the instrumental case. This means that it is a word that modifies a masculine noun that is the means by or with which the subject accomplishes an action. The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, instrumental adjective with a hard-consonant stem, we add the "-ым" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ым" and bare does not end in "-ой"',
            () {
          const bare = 'адовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMInst,
            position: 1,
            form: "а'довым",
            bare: 'адовым',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the instrumental case. This means that it is a word that modifies a masculine noun that is the means by or with which the subject accomplishes an action. The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, instrumental adjective with a hard-consonant stem, we add the "-ым" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when word ends in "-им" and bare ends in "-ой"',
            () {
          const bare = 'небольшой';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMInst,
            position: 1,
            form: "небольши'м",
            bare: 'небольшим',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the instrumental case. This means that it is a word that modifies a masculine noun that is the means by or with which the subject accomplishes an action. The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Most masculine, instrumental adjectives with a hard-consonant stem would receive a "-ым" suffix after the stem, but some instrumental adjectives that have nominative forms ending in "-ой" receive a "-им" suffix in the instrumental case instead.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });

        test(
            'returns correct explanation when word ends in "-им" and bare does not end in "-ой"',
            () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMInst,
            position: 1,
            form: "а'вгустовским",
            bare: 'августовским',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the instrumental case. This means that it is a word that modifies a masculine noun that is the means by or with which the subject accomplishes an action. Masculine, instrumental adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-им" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });

      group('when correctAnswer.type is ruAdjMPrep', () {
        test(
            'returns correct explanation when ends in "-ом" and bare ends in "-ой"',
            () {
          const bare = 'навесной';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMPrep,
            position: 1,
            form: "аве'сном",
            bare: 'авесном',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the prepositional case. This means that it is a word that modifies a masculine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, prepositional adjective with a hard-consonant stem, we add the "-ом" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ом" and bare does not end in "-ой"',
            () {
          const bare = 'актовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMPrep,
            position: 1,
            form: "а'ктовом",
            bare: 'актовом',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the prepositional case. This means that it is a word that modifies a masculine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, prepositional adjective with a hard-consonant stem, we add the "-ом" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ем"', () {
          const bare = 'акавший';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjMPrep,
            position: 1,
            form: "а'кавшем",
            bare: 'акавшем',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a masculine adjective in the prepositional case. This means that it is a word that modifies a masculine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". Masculine, prepositional adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ем" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjFNom', () {
        test('returns correct explanation when ends in "-ая"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFNom,
            position: 1,
            form: "а'вгустовская",
            bare: 'августовская',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a feminine adjective in the nominative case. This means that it is a word that modifies a feminine noun that is the subject of a verb. Feminine, nominative adjectives with stems that do not end in a soft "-н" get a "-ая" suffix after the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-яя"', () {
          const bare = 'бескрайний';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFNom,
            position: 1,
            form: "бескра'йняя",
            bare: 'бескрайняя',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a feminine adjective in the nominative case. This means that it is a word that modifies a feminine noun that is the subject of a verb. Feminine, nominative adjectives with stems ending in a soft "-н" get a "-яя" suffix after their stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjFGen', () {
        test(
            'returns correct explanation when ends in "-ей" and nominative form ends in "-ая"',
            () {
          const bare = 'общий';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFGen,
            position: 1,
            form: "о'бщей",
            bare: 'общей',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjFNom: 'общая'},
            ),
            'This word is a feminine adjective in the genitive case. This means that it is a word that modifies a feminine noun that indicates possession, origin, or close association of or to another noun. Feminine, genitive adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ей" and nominative form ends in "-яя"',
            () {
          const bare = 'последний';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFGen,
            position: 1,
            form: "после'дней",
            bare: 'последней',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjFNom: 'последняя'},
            ),
            'This word is a feminine adjective in the genitive case. This means that it is a word that modifies a feminine noun that indicates possession, origin, or close association of or to another noun. Feminine, genitive adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ой"', () {
          const bare = 'некоторый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFGen,
            position: 1,
            form: "не'которой",
            bare: 'некоторой',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a feminine adjective in the genitive case. This means that it is a word that modifies a feminine noun that indicates possession, origin, or close association of or to another noun. Feminine, genitive adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjFDat', () {
        test(
            'returns correct explanation when ends in "-ей" and nominative form ends in "-ая"',
            () {
          const bare = 'общий';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFDat,
            position: 1,
            form: "о'бщей",
            bare: 'общей',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjFNom: 'общая'},
            ),
            'This word is a feminine adjective in the dative case. This means that it is a word that modifies a feminine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. Feminine, dative adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ей" and nominative form ends in "-яя"',
            () {
          const bare = 'последний';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFDat,
            position: 1,
            form: "после'дней",
            bare: 'последней',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjFNom: 'последняя'},
            ),
            'This word is a feminine adjective in the dative case. This means that it is a word that modifies a feminine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. Feminine, dative adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ой"', () {
          const bare = 'некоторый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFDat,
            position: 1,
            form: "не'которой",
            bare: 'некоторой',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a feminine adjective in the dative case. This means that it is a word that modifies a feminine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. Feminine, dative adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjFAcc', () {
        test('returns correct explanation when ends in "-ую"', () {
          const bare = 'который';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFAcc,
            position: 1,
            form: "кото'рую",
            bare: 'которую',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a feminine adjective in the accusative case. This means that it is a word that modifies a feminine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Feminine, accusative adjectives with stems that do not end in a soft "-н" get a "-ую" suffix after the stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-юю"', () {
          const bare = 'последний';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFAcc,
            position: 1,
            form: "после'днюю",
            bare: 'последнюю',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a feminine adjective in the accusative case. This means that it is a word that modifies a feminine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Feminine, accusative adjectives with stems ending in a soft "-н" get a "-юю" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjFInst', () {
        test(
            'returns correct explanation when ends in "-ей" and nominative form ends in "-ая"',
            () {
          const bare = 'общий';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFInst,
            position: 1,
            form: "о'бщей",
            bare: 'общей',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjFNom: 'общая'},
            ),
            'This word is a feminine adjective in the instrumental case. This means that it is a word that modifies a feminine noun that is the means by or with which the subject accomplishes an action. Feminine, instrumental adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ей" and nominative form ends in "-яя"',
            () {
          const bare = 'последний';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFInst,
            position: 1,
            form: "после'дней",
            bare: 'последней',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjFNom: 'последняя'},
            ),
            'This word is a feminine adjective in the instrumental case. This means that it is a word that modifies a feminine noun that is the means by or with which the subject accomplishes an action. Feminine, instrumental adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ой"', () {
          const bare = 'некоторый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFInst,
            position: 1,
            form: "не'которой",
            bare: 'некоторой',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a feminine adjective in the instrumental case. This means that it is a word that modifies a feminine noun that is the means by or with which the subject accomplishes an action. Feminine, instrumental adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjFPrep', () {
        test(
            'returns correct explanation when ends in "-ей" and nominative form ends in "-ая"',
            () {
          const bare = 'общий';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFPrep,
            position: 1,
            form: "о'бщей",
            bare: 'общей',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjFNom: 'общая'},
            ),
            'This word is a feminine adjective in the prepositional case. This means that it is a word that modifies a feminine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". Feminine, prepositional adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ей" and nominative form ends in "-яя"',
            () {
          const bare = 'последний';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFPrep,
            position: 1,
            form: "после'дней",
            bare: 'последней',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjFNom: 'последняя'},
            ),
            'This word is a feminine adjective in the prepositional case. This means that it is a word that modifies a feminine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". Feminine, prepositional adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ой"', () {
          const bare = 'некоторый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjFPrep,
            position: 1,
            form: "не'которой",
            bare: 'некоторой',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a feminine adjective in the prepositional case. This means that it is a word that modifies a feminine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". Feminine, prepositional adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjNNom', () {
        test('returns correct explanation when ends in "-ое"', () {
          const bare = 'который';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNNom,
            position: 1,
            form: "кото'рое",
            bare: 'которое',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the nominative case. This means that it is a word that modifies a neuter noun that is the subject of a verb. Neuter, nominative adjectives with stems that do not end in "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ое" suffix after the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ее"', () {
          const bare = 'последний';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNNom,
            position: 1,
            form: "после'днее",
            bare: 'последнее',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the nominative case. This means that it is a word that modifies a neuter noun that is the subject of a verb. Neuter, nominative adjectives with stems ending in "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ее" suffix after the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjNGen', () {
        test('returns correct explanation when ends in "-ого"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNGen,
            position: 1,
            form: "а'вгустовского",
            bare: 'августовского',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the genitive case. This means that it is a word that modifies a neuter noun that indicates possession, origin, or close association of or to another noun. Neuter, genitive adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ого" suffix after the stem. Their nominative forms would normally have the "-ое" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-его"', () {
          const bare = 'акавший';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNGen,
            position: 1,
            form: "а'кавшего",
            bare: 'акавшего',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the genitive case. This means that it is a word that modifies a neuter noun that indicates possession, origin, or close association of or to another noun. Neuter, genitive adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ее" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjNDat', () {
        test('returns correct explanation when ends in "-ому"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNDat,
            position: 1,
            form: "а'вгустовскому",
            bare: 'августовскому',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the dative case. This means that it is a word that modifies a neuter noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. Neuter, dative adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ому" suffix after the stem. Their nominative forms would normally have the "-ое" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ему"', () {
          const bare = 'акавший';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNDat,
            position: 1,
            form: "а'кавшему",
            bare: 'акавшему',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the dative case. This means that it is a word that modifies a neuter noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. Neuter, dative adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ее" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjNAcc', () {
        test('returns correct explanation when ends in "-ое"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNAcc,
            position: 1,
            form: "а'вгустовское",
            bare: 'августовское',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the accusative case. This means that it is a word that modifies a neuter noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Neuter, accusative adjectives with stems that do not end in "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ое" suffix after the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ее"', () {
          const bare = 'акавший';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNAcc,
            position: 1,
            form: "а'кавшее",
            bare: 'акавшее',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the accusative case. This means that it is a word that modifies a neuter noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Neuter, accusative adjectives with stems ending in "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ее" suffix after the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });

      group('when correctAnswer.type is ruAdjNInst', () {
        group('when correct answer ends in "-им"', () {
          test('returns correct explanation when ends in "-ое"', () {
            const bare = 'такое';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruAdjNInst,
              position: 1,
              form: "таки'м",
              bare: 'таким',
            );

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              'This word is a neuter adjective in the instrumental case. This means that it is a word that modifies a neuter noun that is the means by or with which the subject accomplishes an action. Neuter, instrumental adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", or a soft "-н" get a "-им" suffix after their stem. Those ending in "-к", "-г", or "-х" have nominative forms that would normally have the "-ое" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
            );
          });
          test('returns correct explanation when ends in "-ее"', () {
            const bare = 'общее';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruAdjNInst,
              position: 1,
              form: "о'бщим",
              bare: 'общим',
            );

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              'This word is a neuter adjective in the instrumental case. This means that it is a word that modifies a neuter noun that is the means by or with which the subject accomplishes an action. Neuter, instrumental adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", or a soft "-н" get a "-им" suffix after their stem. Those not ending in "-к", "-г", or "-х" have nominative forms that would normally have the "-ее" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
            );
          });
        });

        test('returns correct explanation when ends in "-ым"', () {
          const bare = 'первое';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNInst,
            position: 1,
            form: "пе'рвым",
            bare: 'первым',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the instrumental case. This means that it is a word that modifies a neuter noun that is the means by or with which the subject accomplishes an action. Neuter, instrumental adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", or a soft "-н" get a "-ым" suffix after their stem. Their nominative forms would normally have the "-oе" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjNPrep', () {
        test('returns correct explanation when ends in "-ом"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNPrep,
            position: 1,
            form: "а'вгустовском",
            bare: 'августовском',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the prepositional case. This means that it is a word that modifies a neuter noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". Neuter, prepositional adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ом" suffix after the stem. Their nominative forms would normally have the "-ое" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ем"', () {
          const bare = 'акавший';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjNPrep,
            position: 1,
            form: "а'кавшем",
            bare: 'акавшем',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a neuter adjective in the prepositional case. This means that it is a word that modifies a neuter noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". Neuter, prepositional adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ем" suffix after their stem. Their nominative forms would normally have the "-ее" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjPlNom', () {
        test('returns correct explanation when ends in "-ие"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlNom,
            position: 1,
            form: "а'вгустовские",
            bare: 'августовские',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the nominative case. This means that it is a word that modifies a plural noun that is the subject of a verb. Plural, nominative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ие" suffix after the stem, no matter the gender.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ые"', () {
          const bare = 'адовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlNom,
            position: 1,
            form: "а'довые",
            bare: 'адовые',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the nominative case. This means that it is a word that modifies a plural noun that is the subject of a verb. Plural, nominative adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ые" suffix after the stem, no matter the gender.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjPlGen', () {
        test('returns correct explanation when ends in "-их"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlGen,
            position: 1,
            form: "а'вгустовских",
            bare: 'августовских',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the genitive case. This means that it is a word that modifies a plural noun that indicates possession, origin, or close association of or to another noun. Plural, genitive adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-их" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ых"', () {
          const bare = 'адовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlGen,
            position: 1,
            form: "а'довых",
            bare: 'адовых',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the genitive case. This means that it is a word that modifies a plural noun that indicates possession, origin, or close association of or to another noun. Plural, genitive adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ых" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjPlDat', () {
        test('returns correct explanation when ends in "-им"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlDat,
            position: 1,
            form: "а'вгустовским",
            bare: 'августовским',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the dative case. This means that it is a word that modifies a plural noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. Plural, dative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-им" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ым"', () {
          const bare = 'адовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlDat,
            position: 1,
            form: "а'довым",
            bare: 'адовым',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the dative case. This means that it is a word that modifies a plural noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb. Plural, dative adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ым" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjPlAcc', () {
        test(
            'returns correct explanation when ends in "-ие" and ruAdjPlNom form and correctAnswer.bare are identical, i.e. the noun being described is inanimate',
            () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlAcc,
            position: 1,
            form: "а'вгустовские",
            bare: 'августовские',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjPlNom: 'августовские'},
            ),
            'This word is a plural adjective in the accusative case. This means that it is a word that modifies a plural noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Plural, accusative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ие" suffix after the stem, no matter the gender. This form is identical to the nominative form since the noun being described is inanimate, i.e. not a person or animal.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when ends in "-ые" and ruAdjPlNom form and correctAnswer.bare are identical, i.e. the noun being described is inanimate',
            () {
          const bare = 'адовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlAcc,
            position: 1,
            form: "а'довые",
            bare: 'адовые',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {WordFormType.ruAdjPlNom: 'адовые'},
            ),
            'This word is a plural adjective in the accusative case. This means that it is a word that modifies a plural noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Plural, accusative adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ые" suffix after the stem, no matter the gender. This form is identical to the nominative form since the noun being described is inanimate, i.e. not a person or animal.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-их"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlAcc,
            position: 1,
            form: "а'вгустовских",
            bare: 'августовских',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the accusative case. This means that it is a word that modifies a plural noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Plural, accusative, animate adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-их" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ых"', () {
          const bare = 'адовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlAcc,
            position: 1,
            form: "а'довых",
            bare: 'адовых',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the accusative case. This means that it is a word that modifies a plural noun that is the direct object of a sentence, i.e. the noun which the verb is acting on. Plural, accusative, animate adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ых" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjPlInst', () {
        test('returns correct explanation when ends in "-ими"', () {
          const bare = 'общий';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlInst,
            position: 1,
            form: "о'бщими",
            bare: 'общими',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the instrumental case. This means that it is a word that modifies a plural noun that is the means by or with which the subject accomplishes an action. Plural, instrumental adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ими" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ыми"', () {
          const bare = 'который';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlInst,
            position: 1,
            form: "кото'рыми",
            bare: 'которыми',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the instrumental case. This means that it is a word that modifies a plural noun that is the means by or with which the subject accomplishes an action. Plural, instrumental adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ыми" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruAdjPlPrep', () {
        test('returns correct explanation when ends in "-их"', () {
          const bare = 'августовский';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlPrep,
            position: 1,
            form: "а'вгустовских",
            bare: 'августовских',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the prepositional case. This means that it is a word that modifies a plural noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". Plural, prepositional adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-их" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ых"', () {
          const bare = 'адовый';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruAdjPlPrep,
            position: 1,
            form: "а'довых",
            bare: 'адовых',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a plural adjective in the prepositional case. This means that it is a word that modifies a plural noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?". Plural, prepositional adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ых" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruVerbImperativeSg', () {
        test('returns correct explanation when ends in "-й"', () {
          const bare = 'знать';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutSg1: 'знают'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativeSg,
            position: 1,
            form: "зна'й",
            bare: 'знай',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem ends in a vowel and the subject is informal, we add the "-й" suffix to the stem to get the imperative form.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-и"', () {
          const bare = 'сказать';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'скажут'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativeSg,
            position: 1,
            form: "скажи'",
            bare: 'скажи',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem does not end in a vowel, the stress falls on the last syllable in the first-person singular form, and the subject is informal, we add the "-и" suffix to the stem to get the imperative form. Were the stress not to fall on the last syllable in the first-person singular form, we would add a "-ь" suffix to the stem.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ись"', () {
          const bare = 'казаться';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'кажутся'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativeSg,
            position: 1,
            form: "кажи'сь",
            bare: 'кажись',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form for reflexive verbs with an informal subject, we take the stem from the third-person plural form and add the "-ись" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ь"', () {
          const bare = 'слышать';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'слышат'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativeSg,
            position: 1,
            form: "слы'шь",
            bare: 'слышь',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem does not end in a vowel, the stress does not fall on the last syllable in the first-person singular form, and the subject is informal, we add the "-ь" suffix to the stem to get the imperative form. Were the stress to fall on the last syllable in the first-person singular form, we would add a "-и" suffix to the stem.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruVerbImperativePl', () {
        test('returns correct explanation when ends in "-йте"', () {
          const bare = 'знать';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'знают'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativePl,
            position: 1,
            form: "зна'йте",
            bare: 'знайте',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem ends in a vowel and the subject is formal or plural, we add the "-йте" suffix to the stem to get the imperative form.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ите"', () {
          const bare = 'сказать';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'скажут'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativePl,
            position: 1,
            form: "скажи'те",
            bare: 'скажите',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem does not end in a vowel, the stress falls on the last syllable in the first-person singular form, and the subject is formal or plural, we add the "-ите" suffix to the stem to get the imperative form. Were the stress not to fall on the last syllable in the first-person singular form, we would add a "-ьте" suffix to the stem.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-йтесь"', () {
          const bare = 'бояться';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'боятся'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativePl,
            position: 1,
            form: "бо'йтесь",
            bare: 'бойтесь',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form for reflexive verbs with a formal or plural subject, we first take the stem from the third-person plural form. Since this stem ends in a vowel, we add the "-йтесь" suffix to the stem to get the imperative form.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-итесь"', () {
          const bare = 'казаться';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'кажутся'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativePl,
            position: 1,
            form: "кажи'тесь",
            bare: 'кажитесь',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form for reflexive verbs with a formal or plural subject, we first take the stem from the third-person plural form. Since this stem does not end in a vowel, we add the "-итесь" suffix to the stem to get the imperative form.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ьте"', () {
          const bare = 'слышать';
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'слышат'
          };
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbImperativePl,
            position: 1,
            form: "слы'шьте",
            bare: 'слышьте',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice. To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem does not end in a vowel, the stress does not fall on the last syllable in the first-person singular form, and the subject is formal or plural, we add the "-ьте" suffix to the stem to get the imperative form. Were the stress to fall on the last syllable in the first-person singular form, we would add a "-ите" suffix to the stem.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
      });

      group(
        'when correctAnswer.type is ruVerbPastM',
        () {
          test(
            'returns correct explanation when ends in "-л"',
            () {
              const bare = 'бежать';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastM,
                position: 1,
                form: "бежа'л",
                bare: 'бежал',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a masculine verb in the past tense. This means it describes an action taken by a masculine subject at any point in the past. To form the past tense of a masculine verb, we take the infinitive form of the verb and add the "-л" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when ends in "-лся"',
            () {
              const bare = 'бояться';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastM,
                position: 1,
                form: "боя'лся",
                bare: 'боялся',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a masculine verb in the past tense. This means it describes an action taken by a masculine subject at any point in the past. To form the past tense of a masculine, reflexive verb, we take the infinitive form of the verb and add the "-лся" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when does not end in "-л" or "-лся"',
            () {
              const bare = 'возникнуть';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastM,
                position: 1,
                form: "возни'к",
                bare: 'возник',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a masculine verb in the past tense. This means it describes an action taken by a masculine subject at any point in the past.',
              );
            },
          );
        },
      );

      group(
        'when correctAnswer.type is ruVerbPastF',
        () {
          test(
            'returns correct explanation when ends in "-ла"',
            () {
              const bare = 'акать';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastF,
                position: 1,
                form: "а'кала",
                bare: 'акала',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a feminine verb in the past tense. This means it describes an action taken by a feminine subject at any point in the past. To form the past tense of a feminine verb, we take the infinitive form of the verb and add the "-ла" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when ends in "-лась"',
            () {
              const bare = 'абсолютизироваться';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastF,
                position: 1,
                form: "абсолютизи'ровалась",
                bare: 'абсолютизировалась',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a feminine verb in the past tense. This means it describes an action taken by a feminine subject at any point in the past. To form the past tense of a feminine, reflexive verb, we take the infinitive form of the verb and add the "-лась" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when does not end in "-ла" or "-лась"',
            () {
              const bare = 'олицетворить';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastF,
                position: 1,
                form: "олицетвори'л",
                bare: 'олицетворил',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a feminine verb in the past tense. This means it describes an action taken by a feminine subject at any point in the past.',
              );
            },
          );
        },
      );

      group(
        'when correctAnswer.type is ruVerbPastN',
        () {
          test(
            'returns correct explanation when ends in "-ло"',
            () {
              const bare = 'акать';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastN,
                position: 1,
                form: "а'кало",
                bare: 'акало',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a neuter verb in the past tense. This means it describes an action taken by a neuter subject at any point in the past. To form the past tense of a neuter verb, we take the infinitive form of the verb and add the "-ло" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when ends in "-лось"',
            () {
              const bare = 'абсолютизироваться';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastN,
                position: 1,
                form: "абсолютизи'ровалось",
                bare: 'абсолютизировалось',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a neuter verb in the past tense. This means it describes an action taken by a neuter subject at any point in the past. To form the past tense of a neuter, reflexive verb, we take the infinitive form of the verb and add the "-лось" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when does not end in "-ла" or "-лась"',
            () {
              const bare = 'олицетворить';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastF,
                position: 1,
                form: "олицетвори'л",
                bare: 'олицетворил',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a feminine verb in the past tense. This means it describes an action taken by a feminine subject at any point in the past.',
              );
            },
          );
        },
      );

      group(
        'when correctAnswer.type is ruVerbPastPl',
        () {
          test(
            'returns correct explanation when ends in "-ли"',
            () {
              const bare = 'акать';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastPl,
                position: 1,
                form: "а'кали",
                bare: 'акали',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a plural verb in the past tense. This means it describes an action taken by a plural subject at any point in the past. To form the past tense of a plural verb, we take the infinitive form of the verb and add the "-ли" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when ends in "-лись"',
            () {
              const bare = 'абсолютизироваться';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastPl,
                position: 1,
                form: "абсолютизи'ровались",
                bare: 'абсолютизировались',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a plural verb in the past tense. This means it describes an action taken by a plural subject at any point in the past. To form the past tense of a plural, reflexive verb, we take the infinitive form of the verb and add the "-лись" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when does not end in "-ли" or "-лись"',
            () {
              const bare = 'накалять';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPastPl,
                position: 1,
                form: "накаля'й",
                bare: 'накаляй',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a plural verb in the past tense. This means it describes an action taken by a plural subject at any point in the past.',
              );
            },
          );
        },
      );

      group('when correctAnswer.type is ruVerbPresfutSg1', () {
        test(
          'returns correct explanation when ends in "-у"',
          () {
            const bare = 'идти';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbPresfutSg1,
              position: 1,
              form: "иду'",
              bare: 'иду',
            );

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              'This word is a 1st-person verb in the present or future tense. This means it describes an action that has not already been taken by the speaker. To form the present or future tense of a 1st-person verb, we generally take the infinitive form of the verb and add a "-у" or "-ю" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
            );
          },
        );
        test(
          'returns correct explanation when ends in "-ю"',
          () {
            const bare = 'думать';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbPresfutSg1,
              position: 1,
              form: "ду'маю",
              bare: 'думаю',
            );

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              'This word is a 1st-person verb in the present or future tense. This means it describes an action that has not already been taken by the speaker. To form the present or future tense of a 1st-person verb, we generally take the infinitive form of the verb and add a "-у" or "-ю" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
            );
          },
        );
        test(
          'returns correct explanation when ends in "-усь"',
          () {
            const bare = 'казаться';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbPresfutSg1,
              position: 1,
              form: "кажу'сь",
              bare: 'кажусь',
            );

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              "This word is a 1st-person, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by the speaker and whose object is either the same as the subject or doesn't exist. To form the present or future tense of a 1st-person, reflexive verb, we generally take the infinitive form of the verb and add a \"-усь\" or \"-юсь\" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}",
            );
          },
        );
        test(
          'returns correct explanation when ends in "-юсь"',
          () {
            const bare = 'казаться';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbPresfutSg1,
              position: 1,
              form: "остаю'сь",
              bare: 'остаюсь',
            );

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              "This word is a 1st-person, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by the speaker and whose object is either the same as the subject or doesn't exist. To form the present or future tense of a 1st-person, reflexive verb, we generally take the infinitive form of the verb and add a \"-усь\" or \"-юсь\" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}",
            );
          },
        );
        test(
          'returns correct explanation when does not end in "-у", "-ю", "-усь", or "-юсь"',
          () {
            const bare = 'быть';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbPresfutSg1,
              position: 1,
              form: "есть",
              bare: 'есть',
            );

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: {},
              ),
              "This word is a 1st-person verb in the present or future tense. This means it describes an action that has not already been taken by the speaker.",
            );
          },
        );
      });

      group(
        'when correctAnswer.type is ruVerbPresfutSg2',
        () {
          test(
            'returns correct explanation when ends in "-шь"',
            () {
              const bare = 'акать';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPresfutSg2,
                position: 1,
                form: "а'каешь",
                bare: 'акаешь',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a 2nd-person verb in the present or future tense. This means it describes an action that has not already been taken by the person being informally addressed. To form the present or future tense of a 2nd-person verb, we take the infinitive form of the verb and add the "-шь" suffix to the stem.\n\n$bare -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when ends in "-шься"',
            () {
              const bare = 'абстрагироваться';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPresfutSg2,
                position: 1,
                form: "абстраги'руешься",
                bare: 'абстрагируешься',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a 2nd-person, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by the person being informally addressed and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 2nd-person, reflexive verb, we take the infinitive form of the verb and add the "-шься" suffix to the stem.\n\n$bare -> ${correctAnswer.bare}',
              );
            },
          );

          test(
            'returns correct explanation when does not end in "-шь" or "-шься"',
            () {
              const bare = 'быть';
              final correctAnswer = WordForm.testValue(
                type: WordFormType.ruVerbPresfutSg2,
                position: 1,
                form: "есть",
                bare: 'есть',
              );

              expect(
                testObject.sentenceExplanation(
                  bare: bare,
                  correctAnswer: correctAnswer,
                  wordFormTypesToBareMap: {},
                ),
                'This word is a 2nd-person verb in the present or future tense. This means it describes an action that has not already been taken by the person being informally addressed.',
              );
            },
          );
        },
      );

      group('when correctAnswer.type is ruVerbPresfutSg3', () {
        test('returns correct explanation when ends in "-ет"', () {
          const bare = 'думать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutSg3,
            position: 1,
            form: "ду'мает",
            bare: 'думает',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person verb in the present or future tense. This means it describes an action that has not already been taken by somebody or something other than the speaker or person being addressed. To form the present or future tense of a 3rd-person verb, we generally take the infinitive form of the verb and add a "-ет", "-ёт" or "-ит" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ёт"', () {
          const bare = 'войти';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutSg3,
            position: 1,
            form: "войдёт",
            bare: 'войдёт',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person verb in the present or future tense. This means it describes an action that has not already been taken by somebody or something other than the speaker or person being addressed. To form the present or future tense of a 3rd-person verb, we generally take the infinitive form of the verb and add a "-ет", "-ёт" or "-ит" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ит"', () {
          const bare = 'выходить';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutSg3,
            position: 1,
            form: "выхо'дит",
            bare: 'выходит',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person verb in the present or future tense. This means it describes an action that has not already been taken by somebody or something other than the speaker or person being addressed. To form the present or future tense of a 3rd-person verb, we generally take the infinitive form of the verb and add a "-ет", "-ёт" or "-ит" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ется"', () {
          const bare = 'казаться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutSg3,
            position: 1,
            form: "ка'жется",
            bare: 'кажется',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by somebody or something other than the speaker or person being addressed, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 3rd-person, reflexive verb, we generally take the infinitive form of the verb and add a "-ется", "-ётся" or "-ится" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ётся"', () {
          const bare = 'вернуться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutSg3,
            position: 1,
            form: "вернётся",
            bare: 'вернётся',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by somebody or something other than the speaker or person being addressed, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 3rd-person, reflexive verb, we generally take the infinitive form of the verb and add a "-ется", "-ётся" or "-ится" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ится"', () {
          const bare = 'появиться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutSg3,
            position: 1,
            form: "поя'вится",
            bare: 'появится',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by somebody or something other than the speaker or person being addressed, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 3rd-person, reflexive verb, we generally take the infinitive form of the verb and add a "-ется", "-ётся" or "-ится" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruVerbPresfutPl1', () {
        test('returns correct explanation when ends in "-ем"', () {
          const bare = 'думать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl1,
            position: 1,
            form: "ду'маем",
            bare: 'думаем',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 1st-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the speaker. To form the present or future tense of a 1st-person, plural verb, we generally take the infinitive form of the verb and add a "-ем", "-ём" or "-им" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ём"', () {
          const bare = 'давать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl1,
            position: 1,
            form: "даём",
            bare: 'даём',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 1st-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the speaker. To form the present or future tense of a 1st-person, plural verb, we generally take the infinitive form of the verb and add a "-ем", "-ём" or "-им" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-им"', () {
          const bare = 'лежать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl1,
            position: 1,
            form: "лежи'м",
            bare: 'лежим',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 1st-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the speaker. To form the present or future tense of a 1st-person, plural verb, we generally take the infinitive form of the verb and add a "-ем", "-ём" or "-им" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-емся"', () {
          const bare = 'казаться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl1,
            position: 1,
            form: "ка'жемся",
            bare: 'кажемся',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 1st-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the speaker, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 1st-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-емся", "-ёмся" or "-имся" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ёмся"', () {
          const bare = 'вернуться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl1,
            position: 1,
            form: "вернёмся",
            bare: 'вернёмся',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 1st-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the speaker, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 1st-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-емся", "-ёмся" or "-имся" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-имся"', () {
          const bare = 'появиться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl1,
            position: 1,
            form: "поя'вимся",
            bare: 'появимся',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 1st-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the speaker, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 1st-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-емся", "-ёмся" or "-имся" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruVerbPresfutPl2', () {
        test('returns correct explanation when ends in "-ете"', () {
          const bare = 'думать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl2,
            position: 1,
            form: "ду'маете",
            bare: 'думаете',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 2nd-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the person being addressed, or by an individual being formally addressed. To form the present or future tense of a 2nd-person, plural verb, we generally take the infinitive form of the verb and add a "-ете", "-ёте" or "-ите" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ёте"', () {
          const bare = 'давать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl2,
            position: 1,
            form: "даёте",
            bare: 'даёте',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 2nd-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the person being addressed, or by an individual being formally addressed. To form the present or future tense of a 2nd-person, plural verb, we generally take the infinitive form of the verb and add a "-ете", "-ёте" or "-ите" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ите"', () {
          const bare = 'смотреть';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl2,
            position: 1,
            form: "смо'трите",
            bare: 'смотрите',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 2nd-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the person being addressed, or by an individual being formally addressed. To form the present or future tense of a 2nd-person, plural verb, we generally take the infinitive form of the verb and add a "-ете", "-ёте" or "-ите" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-етесь"', () {
          const bare = 'казаться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl2,
            position: 1,
            form: "ка'жетесь",
            bare: 'кажетесь',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 2nd-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the person being addressed, or by an individual being formally addressed. This form is also reflexive, meaning the verb\'s object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 2nd-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-етесь", "-ётесь" or "-итесь" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ётесь"', () {
          const bare = 'вернуться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl2,
            position: 1,
            form: "вернётесь",
            bare: 'вернётесь',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 2nd-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the person being addressed, or by an individual being formally addressed. This form is also reflexive, meaning the verb\'s object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 2nd-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-етесь", "-ётесь" or "-итесь" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-итесь"', () {
          const bare = 'появиться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl2,
            position: 1,
            form: "поя'витесь",
            bare: 'появитесь',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 2nd-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the person being addressed, or by an individual being formally addressed. This form is also reflexive, meaning the verb\'s object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 2nd-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-етесь", "-ётесь" or "-итесь" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruVerbPresfutPl3', () {
        test('returns correct explanation when ends in "-ют"', () {
          const bare = 'думать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl3,
            position: 1,
            form: "ду'мают",
            bare: 'думают',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed. To form the present or future tense of a 3rd-person, plural verb, we generally take the infinitive form of the verb and add a "-ют", "-ут", "-ат", or "-ят" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ут"', () {
          const bare = 'показать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl3,
            position: 1,
            form: "пока'жут",
            bare: 'покажут',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed. To form the present or future tense of a 3rd-person, plural verb, we generally take the infinitive form of the verb and add a "-ют", "-ут", "-ат", or "-ят" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ат"', () {
          const bare = 'лежать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl3,
            position: 1,
            form: "лежа'т",
            bare: 'лежат',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed. To form the present or future tense of a 3rd-person, plural verb, we generally take the infinitive form of the verb and add a "-ют", "-ут", "-ат", or "-ят" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ят"', () {
          const bare = 'любить';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl3,
            position: 1,
            form: "лю'бят",
            bare: 'любят',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, plural verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed. To form the present or future tense of a 3rd-person, plural verb, we generally take the infinitive form of the verb and add a "-ют", "-ут", "-ат", or "-ят" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ются"', () {
          const bare = 'оставаться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl3,
            position: 1,
            form: "остаю'тся",
            bare: 'остаются',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 3rd-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-ются", "-утся", "-атся", or "-ятся" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-утся"', () {
          const bare = 'казаться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl3,
            position: 1,
            form: "ка'жутся",
            bare: 'кажутся',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 3rd-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-ются", "-утся", "-атся", or "-ятся" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-атся"', () {
          const bare = 'случиться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl3,
            position: 1,
            form: "случа'тся",
            bare: 'случатся',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 3rd-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-ются", "-утся", "-атся", or "-ятся" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-ятся"', () {
          const bare = 'бояться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbPresfutPl3,
            position: 1,
            form: "боя'тся",
            bare: 'боятся',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a 3rd-person, plural, reflexive verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed, and whose object is either the same as the subject or doesn\'t exist. To form the present or future tense of a 3rd-person, plural, reflexive verb, we generally take the infinitive form of the verb and add a "-ются", "-утся", "-атся", or "-ятся" suffix depending on the ending of the stem.\n\n$bare -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is fuVerbParticipleActivePast', () {
        test('returns correct explanation when does not end in -ся', () {
          const bare = 'думать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticipleActivePast,
            form: "ду'мавший",
            bare: 'думавший',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is an active past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that performed said action. Active past participles are generally formed by taking the infinitive form of the verb and adding the "-вший" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in -ся', () {
          const bare = 'казаться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticipleActivePast,
            form: "каза'вшийся",
            bare: 'казавшийся',
          );

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: {},
            ),
            'This word is a reflexive active past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that performed said action. This form is also reflexive, meaning the completed verb\'s object is either the same as the subject or doesn\'t exist. Reflexive active past participles are generally formed by taking the infinitive form of the verb and adding the "-вшийся" suffix to the stem.\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}',
          );
        });
      });

      group('when correctAnswer.type is ruVerbParticiplePassivePast', () {
        test(
            'returns correct explanation when correct answer ends in "-ённый" and past tense ends with "-л"',
            () {
          const bare = 'говорить';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticiplePassivePast,
            form: "говорённый",
            bare: 'говорённый',
          );
          final wordFormTypesToBareMap = {WordFormType.ruVerbPastM: 'говорил'};

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is a passive past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive past participle whose past tense form does not end in "-л", we generally take the past tense form and add a "-ённый" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPastM]} -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when correct answer ends in "-тый" and nominative form ends with "-уть"',
            () {
          const bare = 'протянуть';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticiplePassivePast,
            form: "протя'нутый",
            bare: 'протянутый',
          );
          final wordFormTypesToBareMap = {WordFormType.ruVerbPastM: 'протянул'};

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is a passive past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive past participle whose infinitive form ends in "-уть", "-оть", or "-ыть", we generally take the past tense form and replace the "-л" suffix with a "-тый" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPastM]} -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when correct answer ends in "-тый" and nominative form ends with "-оть"',
            () {
          const bare = 'колоть';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticiplePassivePast,
            form: "ко'лотый",
            bare: 'колотый',
          );
          final wordFormTypesToBareMap = {WordFormType.ruVerbPastM: 'колол'};

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is a passive past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive past participle whose infinitive form ends in "-уть", "-оть", or "-ыть", we generally take the past tense form and replace the "-л" suffix with a "-тый" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPastM]} -> ${correctAnswer.bare}',
          );
        });

        test(
            'returns correct explanation when correct answer ends in "-тый" and nominative form ends with "-ыть"',
            () {
          const bare = 'открыть';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticiplePassivePast,
            form: "откры'тый",
            bare: 'открытый',
          );
          final wordFormTypesToBareMap = {WordFormType.ruVerbPastM: 'открыл'};

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is a passive past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive past participle whose infinitive form ends in "-уть", "-оть", or "-ыть", we generally take the past tense form and replace the "-л" suffix with a "-тый" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPastM]} -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when correct answer ends in "-тый" and nominative form ends with "-ереть"',
            () {
          const bare = 'вытереть';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticiplePassivePast,
            form: "вы'тертый",
            bare: 'вытертый',
          );
          final wordFormTypesToBareMap = {WordFormType.ruVerbPastM: 'вытер'};

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is a passive past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive past participle whose infinitive form ends in "-ереть", we generally take the past tense form and replace the "-р" suffix with a "-тый" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPastM]} -> ${correctAnswer.bare}',
          );
        });
        test(
            'returns correct explanation when correct answer ends in "-енный" and nominative form ends with "-ить"',
            () {
          const bare = 'служить';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticiplePassivePast,
            form: "слу'женный",
            bare: 'служенный',
          );
          final wordFormTypesToBareMap = {WordFormType.ruVerbPastM: 'служил'};

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is a passive past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive past participle whose infinitive form ends in "ить", we generally take the past tense form and replace the "-ил" suffix with an "-енный" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPastM]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation for typical passive past participle',
            () {
          const bare = 'читать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticiplePassivePast,
            form: "счи'танный",
            bare: 'читанный',
          );
          final wordFormTypesToBareMap = {WordFormType.ruVerbPastM: 'читал'};

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is a passive past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive past participle, we generally take the past tense form and replace the "-л" suffix with a "-нный" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPastM]} -> ${correctAnswer.bare}',
          );
        });
      });
      group('when correctAnswer.type is ruVerbParticipleActivePresent', () {
        test('returns correct explanation when does not end in "-ся"', () {
          const bare = 'знать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticipleActivePresent,
            form: "зна'ющий",
            bare: 'знающий',
          );
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'знают'
          };

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an active present participle. This means it is a verb form of a uncompleted action that can be used as an adjective to describe the subject of a sentence that is or will be performing said action. Active present participles are generally formed by taking the third-person plural form of the verb and replacing the "-т" suffix with a "-щий" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when does not end in "-ся"', () {
          const bare = 'знать';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticipleActivePresent,
            form: "зна'ющий",
            bare: 'знающий',
          );
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'знают'
          };

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is an active present participle. This means it is a verb form of a uncompleted action that can be used as an adjective to describe the subject of a sentence that is or will be performing said action. Active present participles are generally formed by taking the third-person plural form of the verb and replacing the "-т" suffix with a "-щий" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        test('returns correct explanation when ends in "-тся"', () {
          const bare = 'оставаться';
          final correctAnswer = WordForm.testValue(
            type: WordFormType.ruVerbParticipleActivePresent,
            form: "остаю'щийся",
            bare: 'остающийся',
          );
          final wordFormTypesToBareMap = {
            WordFormType.ruVerbPresfutPl3: 'остаются'
          };

          expect(
            testObject.sentenceExplanation(
              bare: bare,
              correctAnswer: correctAnswer,
              wordFormTypesToBareMap: wordFormTypesToBareMap,
            ),
            'This word is a reflexive active present participle. This means it is a verb form of a uncompleted action that can be used as an adjective to describe the subject of a sentence that is or will be performing said action. This form is also reflexive, meaning the uncompleted verb\'s object is either the same as the subject or doesn\'t exist. Reflexive active present participles are generally formed by taking the third-person plural form of the verb and replacing the "-тся" suffix with a "-щийся" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}',
          );
        });
        group('when correctAnswer.type is ruVerbParticiplePassivePresent', () {
          test('returns correct explanation', () {
            const bare = 'знать';
            final correctAnswer = WordForm.testValue(
              type: WordFormType.ruVerbParticiplePassivePresent,
              form: "зна'емый",
              bare: 'знаемый',
            );
            final wordFormTypesToBareMap = {
              WordFormType.ruVerbPresfutPl1: 'знаем'
            };

            expect(
              testObject.sentenceExplanation(
                bare: bare,
                correctAnswer: correctAnswer,
                wordFormTypesToBareMap: wordFormTypesToBareMap,
              ),
              'This word is a passive present participle. This means it is a verb form of an uncompleted action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive present participle, we generally take the 1st-person plural form of the verb and replace the "-м" suffix with a "-мый" suffix.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl1]} -> ${correctAnswer.bare}',
            );
          });
        });
      });
    });
  });
}
