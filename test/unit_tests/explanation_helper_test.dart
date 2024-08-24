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
    });
  });
}
