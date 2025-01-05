import 'package:flutter/widgets.dart';
import 'package:uchu/consts.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';

class ExplanationHelper {
  String? genderExplanation({
    required String bare,
    required Gender correctAnswer,
  }) {
    final lastCharacter = bare.substring(bare.length - 1).toLowerCase();
    if (lastCharacter == 'ь') {
      return 'Most nouns ending in -ь are feminine, but there are many masculine ones too, so you have to learn the gender of soft-sign nouns.';
    }

    if (correctAnswer == Gender.m) {
      if (masculineNounEndings.contains(lastCharacter)) {
        return 'Masculine nouns normally end with a consonant or -й.';
      }

      if (feminineNounEndings.contains(lastCharacter)) {
        return 'Nouns ending in -а or -я which denote males are masculine. This may be the case here.';
      }
    }

    if (correctAnswer == Gender.f) {
      if (feminineNounEndings.contains(lastCharacter)) {
        return 'Feminine nouns normally end with -а or -я.';
      }

      return 'Foreign words denoting females are feminine, whatever their endings. This may be the case here.';
    }

    if (correctAnswer == Gender.n) {
      if (neuterNounEndings.contains(lastCharacter)) {
        return 'Neuter nouns generally end in -о or -е.';
      }

      if (foreignNeuterNounEndings.contains(lastCharacter)) {
        return 'If a noun ends in -и or -у or -ю, it is likely to be a foreign borrowing and to be neuter.';
      }
    }
  }

  String? getAdjNomExplanation(String bare, {required Gender gender}) {
    switch (gender) {
      case Gender.m:
        if (bare.endsWith('ый')) {
          return ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, nominative adjective with a hard-consonant stem, we add the "-ый" suffix after the stem.';
        } else if (bare.endsWith('ий')) {
          if (bare.endsWith('ний')) {
            return ' Masculine, nominative adjectives with stems ending in a soft "-н" get a "-ий" suffix after their stem.';
          } else {
            return ' Masculine, nominative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", or "-щ" get a "-ий" suffix after their stem.';
          }
        } else if (bare.endsWith('ой')) {
          return ' There is a small group of masculine, nominative adjectives that end in "-ой" instead of "-ый" or "-ий". This is one such adjective. These adjectives ending in "-ой" are always stressed on the "о" in their suffix.';
        }
      case Gender.f:
        if (bare.endsWith('ая')) {
          return ' Feminine, nominative adjectives with stems that do not end in a soft "-н" get a "-ая" suffix after the stem.';
        } else if (bare.endsWith('яя')) {
          return ' Feminine, nominative adjectives with stems ending in a soft "-н" get a "-яя" suffix after their stem.';
        }
      case Gender.n:
        if (bare.endsWith('ое')) {
          return ' Neuter, nominative adjectives with stems that do not end in "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ое" suffix after the stem.';
        } else if (bare.endsWith('ее')) {
          return ' Neuter, nominative adjectives with stems ending in "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ее" suffix after the stem.';
        }
      case Gender.pl:
        if (bare.endsWith('ые')) {
          return ' Plural, nominative adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ые" suffix after the stem, no matter the gender.';
        } else if (bare.endsWith('ие')) {
          return ' Plural, nominative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ие" suffix after the stem, no matter the gender.';
        }
      default:
        return '';
    }
  }

  String? sentenceExplanation({
    required String bare,
    required WordForm correctAnswer,
    required Map<WordFormType, String> wordFormTypesToBareMap,
    Gender? gender,
  }) {
    switch (correctAnswer.type) {
      case WordFormType.ruVerbGerundPast:
        String? formationExplanation;
        bool isReflexive =
            bare.endsWith('ться') && correctAnswer.bare.endsWith('вшись');
        if (isReflexive) {
          formationExplanation =
              ' Since the verb in this sentence is reflexive, you replace the "-ться" suffix with a "-вшись" suffix.';
        } else if (correctAnswer.position == 1 &&
            bare.endsWith('ть') &&
            correctAnswer.bare.endsWith('в')) {
          formationExplanation =
              ' Since the verb in this sentence is not reflexive, you replace the "-ть" suffix with a "-в" suffix. Alternatively, you could replace the "-ть" suffix with a "-вши" suffix, though this is marked (colloquial, dated, or humorous).';
        } else if (correctAnswer.position == 2 &&
            bare.endsWith('ть') &&
            correctAnswer.bare.endsWith('вши')) {
          formationExplanation =
              ' Since the verb in this sentence is not reflexive, you replace the "-ть" suffix with a "-вши" suffix. Alternatively, you could replace the "-ть" suffix with a "-в" suffix.';
        }
        return 'This word is a perfective gerund, also known as a perfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is perfective, meaning that the gerund denotes a result or completed action, having taken place before the main verb.${formationExplanation ?? ''}\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbGerundPresent:
        bool isReflexive =
            bare.endsWith('ться') && correctAnswer.bare.endsWith('сь');
        final usesSpellingRule = correctAnswer.bare.endsWith('ась') ||
            correctAnswer.bare.endsWith('а');
        return 'This word is an imperfective gerund, also known as an imperfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is imperfective, meaning that the gerund denotes a process or incomplete action, taking place simultaneously with the main verb. Since the verb in this sentence is ${isReflexive ? '' : 'not '}reflexive, you take the third person plural form of the verb and replace its suffix with either a ${isReflexive ? '"-ась" or "-ясь"' : '"-а" or "-я"'} suffix. Since "a" always follows "ж", "ш", "ч", or "щ", we will use ${usesSpellingRule ? isReflexive ? '"-ась"' : '"-а"' : isReflexive ? '"-ясь"' : '"-я"'} in this case.\n\n$bare ➡️ ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} ➡️ ${correctAnswer.bare}';
      case WordFormType.ruBase:
        return '';
      case WordFormType.ruAdjMNom:
        String? formationExplanation =
            getAdjNomExplanation(bare, gender: Gender.m);

        return 'This word is a masculine adjective in the nominative case. This means that it is a word that modifies a masculine noun that is the subject of a verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjMGen:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ого')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, genitive adjective with a hard-consonant stem, we add the "-ого" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('его')) {
          formationExplanation =
              ' Masculine, genitive adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
        }
        return 'This word is a masculine adjective in the genitive case. This means that it is a word that modifies a masculine noun that indicates possession, origin, or close association of or to another noun.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjMDat:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ому')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, dative adjective with a hard-consonant stem, we add the "-ому" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('ему')) {
          formationExplanation =
              ' Masculine, dative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ему" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
        }
        return 'This word is a masculine adjective in the dative case. This means that it is a word that modifies a masculine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjMAcc:
        String? formationExplanation;
        final bool isInanimate = bare == correctAnswer.bare;
        if (isInanimate) {
          final nominativeExplanation =
              getAdjNomExplanation(bare, gender: Gender.m)
                  ?.replaceAll('nominative', 'accusative');
          if (nominativeExplanation != null) {
            formationExplanation =
                '$nominativeExplanation This form is identical to the nominative form since the noun being described is inanimate, i.e. not a person or animal.';
          }
        } else if (correctAnswer.bare.endsWith('ого')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, accusative adjective with a hard-consonant stem, we add the "-ого" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('его')) {
          formationExplanation =
              ' Masculine, accusative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
        }
        return 'This word is a masculine adjective in the accusative case. This means that it is a word that modifies a masculine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjMInst:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ым')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, instrumental adjective with a hard-consonant stem, we add the "-ым" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('им')) {
          if (bare.endsWith('ой')) {
            formationExplanation =
                ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Most masculine, instrumental adjectives with a hard-consonant stem would receive a "-ым" suffix after the stem, but some instrumental adjectives that have nominative forms ending in "-ой" receive a "-им" suffix in the instrumental case instead.';
          } else {
            formationExplanation =
                ' Masculine, instrumental adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-им" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
          }
        }
        return 'This word is a masculine adjective in the instrumental case. This means that it is a word that modifies a masculine noun that is the means by or with which the subject accomplishes an action.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjMPrep:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ом')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, prepositional adjective with a hard-consonant stem, we add the "-ом" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('ем')) {
          formationExplanation =
              ' Masculine, prepositional adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ем" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
        }
        return 'This word is a masculine adjective in the prepositional case. This means that it is a word that modifies a masculine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?".${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjFNom:
        String? formationExplanation =
            getAdjNomExplanation(correctAnswer.bare, gender: Gender.f);

        return 'This word is a feminine adjective in the nominative case. This means that it is a word that modifies a feminine noun that is the subject of a verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjFGen:
        String? formationExplanation;
        final nominativeForm = wordFormTypesToBareMap[WordFormType.ruAdjFNom];
        if (correctAnswer.bare.endsWith('ей')) {
          if (nominativeForm?.endsWith('ая') == true) {
            formationExplanation =
                ' Feminine, genitive adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
          } else if (nominativeForm?.endsWith('яя') == true) {
            formationExplanation =
                ' Feminine, genitive adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ой')) {
          formationExplanation =
              ' Feminine, genitive adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
        }
        return 'This word is a feminine adjective in the genitive case. This means that it is a word that modifies a feminine noun that indicates possession, origin, or close association of or to another noun.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjFDat:
        String? formationExplanation;
        final nominativeForm = wordFormTypesToBareMap[WordFormType.ruAdjFNom];
        if (correctAnswer.bare.endsWith('ей')) {
          if (nominativeForm?.endsWith('ая') == true) {
            formationExplanation =
                ' Feminine, dative adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
          } else if (nominativeForm?.endsWith('яя') == true) {
            formationExplanation =
                ' Feminine, dative adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ой')) {
          formationExplanation =
              ' Feminine, dative adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
        }
        return 'This word is a feminine adjective in the dative case. This means that it is a word that modifies a feminine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjFAcc:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ую')) {
          formationExplanation =
              ' Feminine, accusative adjectives with stems that do not end in a soft "-н" get a "-ую" suffix after the stem. Their nominative forms would normally have the "-ая" suffix.';
        } else if (correctAnswer.bare.endsWith('юю')) {
          formationExplanation =
              ' Feminine, accusative adjectives with stems ending in a soft "-н" get a "-юю" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.';
        }
        return 'This word is a feminine adjective in the accusative case. This means that it is a word that modifies a feminine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjFInst:
        String? formationExplanation;
        final nominativeForm = wordFormTypesToBareMap[WordFormType.ruAdjFNom];
        if (correctAnswer.bare.endsWith('ей')) {
          if (nominativeForm?.endsWith('ая') == true) {
            formationExplanation =
                ' Feminine, instrumental adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
          } else if (nominativeForm?.endsWith('яя') == true) {
            formationExplanation =
                ' Feminine, instrumental adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ой')) {
          formationExplanation =
              ' Feminine, instrumental adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
        }
        return 'This word is a feminine adjective in the instrumental case. This means that it is a word that modifies a feminine noun that is the means by or with which the subject accomplishes an action.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjFPrep:
        String? formationExplanation;
        final nominativeForm = wordFormTypesToBareMap[WordFormType.ruAdjFNom];
        if (correctAnswer.bare.endsWith('ей')) {
          if (nominativeForm?.endsWith('ая') == true) {
            formationExplanation =
                ' Feminine, prepositional adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
          } else if (nominativeForm?.endsWith('яя') == true) {
            formationExplanation =
                ' Feminine, prepositional adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ой')) {
          formationExplanation =
              ' Feminine, prepositional adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
        }
        return 'This word is a feminine adjective in the prepositional case. This means that it is a word that modifies a feminine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?".${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjNNom:
        String? formationExplanation =
            getAdjNomExplanation(correctAnswer.bare, gender: Gender.n);

        return 'This word is a neuter adjective in the nominative case. This means that it is a word that modifies a neuter noun that is the subject of a verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjNGen:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ого')) {
          formationExplanation =
              ' Neuter, genitive adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ого" suffix after the stem. Their nominative forms would normally have the "-ое" suffix.';
        } else if (correctAnswer.bare.endsWith('его')) {
          formationExplanation =
              ' Neuter, genitive adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ее" suffix.';
        }
        return 'This word is a neuter adjective in the genitive case. This means that it is a word that modifies a neuter noun that indicates possession, origin, or close association of or to another noun.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjNDat:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ому')) {
          formationExplanation =
              ' Neuter, dative adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ому" suffix after the stem. Their nominative forms would normally have the "-ое" suffix.';
        } else if (correctAnswer.bare.endsWith('ему')) {
          formationExplanation =
              ' Neuter, dative adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ее" suffix.';
        }
        return 'This word is a neuter adjective in the dative case. This means that it is a word that modifies a neuter noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjNAcc:
        String? formationExplanation =
            getAdjNomExplanation(correctAnswer.bare, gender: Gender.n)
                ?.replaceAll('nominative', 'accusative');
        return 'This word is a neuter adjective in the accusative case. This means that it is a word that modifies a neuter noun that is the direct object of a sentence, i.e. the noun which the verb is acting on.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjNInst:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('им')) {
          formationExplanation =
              ' Neuter, instrumental adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", or a soft "-н" get a "-им" suffix after their stem.';
          if (bare.endsWith('ое')) {
            formationExplanation +=
                ' Those ending in "-к", "-г", or "-х" have nominative forms that would normally have the "-ое" suffix.';
          } else if (bare.endsWith('ее')) {
            formationExplanation +=
                ' Those not ending in "-к", "-г", or "-х" have nominative forms that would normally have the "-ее" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ым')) {
          formationExplanation =
              ' Neuter, instrumental adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", or a soft "-н" get a "-ым" suffix after their stem. Their nominative forms would normally have the "-oе" suffix.';
        }
        return 'This word is a neuter adjective in the instrumental case. This means that it is a word that modifies a neuter noun that is the means by or with which the subject accomplishes an action.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjNPrep:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ом')) {
          formationExplanation =
              ' Neuter, prepositional adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ом" suffix after the stem. Their nominative forms would normally have the "-ое" suffix.';
        } else if (correctAnswer.bare.endsWith('ем')) {
          formationExplanation =
              ' Neuter, prepositional adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ем" suffix after their stem. Their nominative forms would normally have the "-ее" suffix.';
        }
        return 'This word is a neuter adjective in the prepositional case. This means that it is a word that modifies a neuter noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?".${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjPlNom:
        String? formationExplanation =
            getAdjNomExplanation(correctAnswer.bare, gender: Gender.pl);

        return 'This word is a plural adjective in the nominative case. This means that it is a word that modifies a plural noun that is the subject of a verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjPlGen:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ых')) {
          formationExplanation =
              ' Plural, genitive adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ых" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.';
        } else if (correctAnswer.bare.endsWith('их')) {
          formationExplanation =
              ' Plural, genitive adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-их" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.';
        }
        return 'This word is a plural adjective in the genitive case. This means that it is a word that modifies a plural noun that indicates possession, origin, or close association of or to another noun.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjPlDat:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ым')) {
          formationExplanation =
              ' Plural, dative adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ым" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.';
        } else if (correctAnswer.bare.endsWith('им')) {
          formationExplanation =
              ' Plural, dative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-им" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.';
        }
        return 'This word is a plural adjective in the dative case. This means that it is a word that modifies a plural noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjPlAcc:
        String? formationExplanation;
        final bool isInanimate =
            wordFormTypesToBareMap[WordFormType.ruAdjPlNom] ==
                correctAnswer.bare;
        if (isInanimate) {
          final nominativeExplanation =
              getAdjNomExplanation(correctAnswer.bare, gender: Gender.pl)
                  ?.replaceAll('nominative', 'accusative');
          if (nominativeExplanation != null) {
            formationExplanation =
                '$nominativeExplanation This form is identical to the nominative form since the noun being described is inanimate, i.e. not a person or animal.';
          }
        } else if (correctAnswer.bare.endsWith('ых')) {
          formationExplanation =
              ' Plural, accusative, animate adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ых" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.';
        } else if (correctAnswer.bare.endsWith('их')) {
          formationExplanation =
              ' Plural, accusative, animate adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-их" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.';
        }
        return 'This word is a plural adjective in the accusative case. This means that it is a word that modifies a plural noun that is the direct object of a sentence, i.e. the noun which the verb is acting on.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjPlInst:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ыми')) {
          formationExplanation =
              ' Plural, instrumental adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ыми" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.';
        } else if (correctAnswer.bare.endsWith('ими')) {
          formationExplanation =
              ' Plural, instrumental adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ими" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.';
        }
        return 'This word is a plural adjective in the instrumental case. This means that it is a word that modifies a plural noun that is the means by or with which the subject accomplishes an action.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjPlPrep:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ых')) {
          formationExplanation =
              ' Plural, prepositional adjectives with stems that do not end in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ых" suffix after the stem. Their nominative forms would normally have the "-ые" suffix.';
        } else if (correctAnswer.bare.endsWith('их')) {
          formationExplanation =
              ' Plural, prepositional adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-их" suffix after their stem. Their nominative forms would normally have the "-ие" suffix.';
        }
        return 'This word is a plural adjective in the prepositional case. This means that it is a word that modifies a plural noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?".${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbImperativeSg:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('й')) {
          formationExplanation =
              ' To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem ends in a vowel and the subject is informal, we add the "-й" suffix to the stem to get the imperative form.';
        } else if (correctAnswer.bare.endsWith('и')) {
          formationExplanation =
              ' To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem does not end in a vowel, the stress falls on the last syllable in the first-person singular form, and the subject is informal, we add the "-и" suffix to the stem to get the imperative form. Were the stress not to fall on the last syllable in the first-person singular form, we would add a "-ь" suffix to the stem.';
        } else if (correctAnswer.bare.endsWith('ись')) {
          formationExplanation =
              ' To create the imperative form for reflexive verbs with an informal subject, we take the stem from the third-person plural form and add the "-ись" suffix.';
        } else if (correctAnswer.bare.endsWith('ь')) {
          formationExplanation =
              ' To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem does not end in a vowel, the stress does not fall on the last syllable in the first-person singular form, and the subject is informal, we add the "-ь" suffix to the stem to get the imperative form. Were the stress to fall on the last syllable in the first-person singular form, we would add a "-и" suffix to the stem.';
        }
        return 'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice.${formationExplanation ?? ''}\n\n$bare ➡️ ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbImperativePl:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('йте')) {
          formationExplanation =
              ' To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem ends in a vowel and the subject is formal or plural, we add the "-йте" suffix to the stem to get the imperative form.';
        } else if (correctAnswer.bare.endsWith('ите')) {
          formationExplanation =
              ' To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem does not end in a vowel, the stress falls on the last syllable in the first-person singular form, and the subject is formal or plural, we add the "-ите" suffix to the stem to get the imperative form. Were the stress not to fall on the last syllable in the first-person singular form, we would add a "-ьте" suffix to the stem.';
        } else if (correctAnswer.bare.endsWith('йтесь')) {
          formationExplanation =
              ' To create the imperative form for reflexive verbs with a formal or plural subject, we first take the stem from the third-person plural form. Since this stem ends in a vowel, we add the "-йтесь" suffix to the stem to get the imperative form.';
        } else if (correctAnswer.bare.endsWith('итесь')) {
          formationExplanation =
              ' To create the imperative form for reflexive verbs with a formal or plural subject, we first take the stem from the third-person plural form. Since this stem does not end in a vowel, we add the "-итесь" suffix to the stem to get the imperative form.';
        } else if (correctAnswer.bare.endsWith('ьте')) {
          formationExplanation =
              ' To create the imperative form, we first take the stem from the third-person plural form of the verb. Since this stem does not end in a vowel, the stress does not fall on the last syllable in the first-person singular form, and the subject is formal or plural, we add the "-ьте" suffix to the stem to get the imperative form. Were the stress to fall on the last syllable in the first-person singular form, we would add a "-ите" suffix to the stem.';
        }
        return 'This word is an imperative verb. This means it is a verb used to give commands, express requests, or provide advice.${formationExplanation ?? ''}\n\n$bare ➡️ ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbPastM:
        String? formationExplanation;
        bool isReflexive = correctAnswer.bare.endsWith('лся');
        if (isReflexive || correctAnswer.bare.endsWith('л')) {
          formationExplanation =
              ' To form the past tense of a masculine${isReflexive ? ', reflexive' : ''} verb, we take the infinitive form of the verb and add the "-${isReflexive ? 'лся' : 'л'}" suffix to the stem.';
        }
        return 'This word is a masculine verb in the past tense. This means it describes an action taken by a masculine subject at any point in the past.${formationExplanation != null ? '$formationExplanation\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}' : ''}';
      case WordFormType.ruVerbPastF:
        String? formationExplanation;
        bool isReflexive = correctAnswer.bare.endsWith('лась');
        if (isReflexive || correctAnswer.bare.endsWith('ла')) {
          formationExplanation =
              ' To form the past tense of a feminine${isReflexive ? ', reflexive' : ''} verb, we take the infinitive form of the verb and add the "-${isReflexive ? 'лась' : 'ла'}" suffix to the stem.';
        }
        return 'This word is a feminine verb in the past tense. This means it describes an action taken by a feminine subject at any point in the past.${formationExplanation != null ? '$formationExplanation\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}' : ''}';
      case WordFormType.ruVerbPastN:
        String? formationExplanation;
        bool isReflexive = correctAnswer.bare.endsWith('лось');
        if (isReflexive || correctAnswer.bare.endsWith('ло')) {
          formationExplanation =
              ' To form the past tense of a neuter${isReflexive ? ', reflexive' : ''} verb, we take the infinitive form of the verb and add the "-${isReflexive ? 'лось' : 'ло'}" suffix to the stem.';
        }
        return 'This word is a neuter verb in the past tense. This means it describes an action taken by a neuter subject at any point in the past.${formationExplanation != null ? '$formationExplanation\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}' : ''}';
      case WordFormType.ruVerbPastPl:
        String? formationExplanation;
        bool isReflexive = correctAnswer.bare.endsWith('лись');
        if (isReflexive || correctAnswer.bare.endsWith('ли')) {
          formationExplanation =
              ' To form the past tense of a plural${isReflexive ? ', reflexive' : ''} verb, we take the infinitive form of the verb and add the "-${isReflexive ? 'лись' : 'ли'}" suffix to the stem.';
        }
        return 'This word is a plural verb in the past tense. This means it describes an action taken by a plural subject at any point in the past.${formationExplanation != null ? '$formationExplanation\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}' : ''}';
      case WordFormType.ruVerbPresfutSg1:
        String? formationExplanation;
        final bool isReflexive = correctAnswer.bare.endsWith('сь');
        if (isReflexive ||
            correctAnswer.bare.endsWith('ю') ||
            correctAnswer.bare.endsWith('у')) {
          formationExplanation =
              ' To form the present or future tense of a 1st-person${isReflexive ? ', reflexive' : ''} verb, we generally take the infinitive form of the verb and add a "-у${isReflexive ? 'сь' : ''}" or "-ю${isReflexive ? 'сь' : ''}" suffix depending on the ending of the stem.';
        }
        return 'This word is a 1st-person${isReflexive ? ', reflexive' : ''} verb in the present or future tense. This means it describes an action that has not already been taken by the speaker${isReflexive ? " and whose object is either the same as the subject or doesn't exist" : ''}.${formationExplanation != null ? '$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}' : ''}';
      case WordFormType.ruVerbPresfutSg2:
        String? formationExplanation;
        bool isReflexive = correctAnswer.bare.endsWith('шься');
        if (isReflexive || correctAnswer.bare.endsWith('шь')) {
          formationExplanation =
              ' To form the present or future tense of a 2nd-person${isReflexive ? ', reflexive' : ''} verb, we take the infinitive form of the verb and add the "-${isReflexive ? 'шься' : 'шь'}" suffix to the stem.';
        }
        return 'This word is a 2nd-person${isReflexive ? ', reflexive' : ''} verb in the present or future tense. This means it describes an action that has not already been taken by the person being informally addressed${isReflexive ? " and whose object is either the same as the subject or doesn't exist" : ''}.${formationExplanation != null ? '$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}' : ''}';
      case WordFormType.ruVerbPresfutSg3:
        String? formationExplanation;
        final bool isReflexive = correctAnswer.bare.endsWith('ся');
        formationExplanation =
            ' To form the present or future tense of a 3rd-person${isReflexive ? ', reflexive' : ''} verb, we generally take the infinitive form of the verb and add a "-ет${isReflexive ? 'ся' : ''}", "-ёт${isReflexive ? 'ся' : ''}" or "-ит${isReflexive ? 'ся' : ''}" suffix depending on the ending of the stem.';
        return 'This word is a 3rd-person${isReflexive ? ', reflexive' : ''} verb in the present or future tense. This means it describes an action that has not already been taken by somebody or something other than the speaker or person being addressed${isReflexive ? ", and whose object is either the same as the subject or doesn't exist" : ''}.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbPresfutPl1:
        String? formationExplanation;
        final bool isReflexive = correctAnswer.bare.endsWith('ся');
        formationExplanation =
            ' To form the present or future tense of a 1st-person, plural${isReflexive ? ', reflexive' : ''} verb, we generally take the infinitive form of the verb and add a "-ем${isReflexive ? 'ся' : ''}", "-ём${isReflexive ? 'ся' : ''}" or "-им${isReflexive ? 'ся' : ''}" suffix depending on the ending of the stem.';
        return 'This word is a 1st-person, plural${isReflexive ? ', reflexive' : ''} verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the speaker${isReflexive ? ", and whose object is either the same as the subject or doesn't exist" : ''}.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbPresfutPl2:
        String? formationExplanation;
        final bool isReflexive = correctAnswer.bare.endsWith('сь');
        formationExplanation =
            ' To form the present or future tense of a 2nd-person, plural${isReflexive ? ', reflexive' : ''} verb, we generally take the infinitive form of the verb and add a "-ете${isReflexive ? 'сь' : ''}", "-ёте${isReflexive ? 'сь' : ''}" or "-ите${isReflexive ? 'сь' : ''}" suffix depending on the ending of the stem.';
        return 'This word is a 2nd-person, plural${isReflexive ? ', reflexive' : ''} verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that includes the person being addressed, or by an individual being formally addressed${isReflexive ? ". This form is also reflexive, meaning the verb's object is either the same as the subject or doesn't exist" : ''}.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbPresfutPl3:
        String? formationExplanation;
        final bool isReflexive = correctAnswer.bare.endsWith('ся');
        formationExplanation =
            ' To form the present or future tense of a 3rd-person, plural${isReflexive ? ', reflexive' : ''} verb, we generally take the infinitive form of the verb and add a "-ют${isReflexive ? 'ся' : ''}", "-ут${isReflexive ? 'ся' : ''}", "-ат${isReflexive ? 'ся' : ''}", or "-ят${isReflexive ? 'ся' : ''}" suffix depending on the ending of the stem.';
        return 'This word is a 3rd-person, plural${isReflexive ? ', reflexive' : ''} verb in the present or future tense. This means it describes an action that has not already been taken by a group of people that does not include the speaker or person being addressed${isReflexive ? ", and whose object is either the same as the subject or doesn't exist" : ''}.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbParticipleActivePast:
        final bool isReflexive = correctAnswer.bare.endsWith('ся');
        final String formationExplanation =
            ' ${isReflexive ? 'Reflexive a' : 'A'}ctive past participles are generally formed by taking the infinitive form of the verb and adding the "-вший${isReflexive ? 'ся' : ''}" suffix to the stem.';
        return 'This word is a${isReflexive ? ' reflexive' : 'n'} active past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that performed said action${isReflexive ? ". This form is also reflexive, meaning the completed verb's object is either the same as the subject or doesn't exist" : ''}.$formationExplanation\n\n${bare.substring(0, bare.length - 2)}- ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbParticiplePassivePast:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ённый') &&
            wordFormTypesToBareMap[WordFormType.ruVerbPastM]?.endsWith('л') ==
                true) {
          formationExplanation =
              ' To form a passive past participle whose past tense form does not end in "-л", we generally take the past tense form and add a "-ённый" suffix.';
        } else if (correctAnswer.bare.endsWith('тый') &&
            (bare.endsWith('уть') ||
                bare.endsWith('оть') ||
                bare.endsWith('ыть') ||
                bare.endsWith('ереть'))) {
          formationExplanation =
              ' To form a passive past participle whose infinitive form ends in ${bare.endsWith('ереть') ? '"-ереть"' : '"-уть", "-оть", or "-ыть"'}, we generally take the past tense form and replace the ${bare.endsWith('ереть') ? '"-р"' : '"-л"'} suffix with a "-тый" suffix.';
        } else if (correctAnswer.bare.endsWith('енный') &&
            bare.endsWith('ить')) {
          formationExplanation =
              ' To form a passive past participle whose infinitive form ends in "ить", we generally take the past tense form and replace the "-ил" suffix with an "-енный" suffix.';
        } else {
          formationExplanation =
              ' To form a passive past participle, we generally take the past tense form and replace the "-л" suffix with a "-нный" suffix.';
        }
        return 'This word is a passive past participle. This means it is a verb form of a completed action that can be used as an adjective to describe the subject of a sentence that experienced said action.$formationExplanation\n\n$bare ➡️ ${wordFormTypesToBareMap[WordFormType.ruVerbPastM]} ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbParticipleActivePresent:
        final bool isReflexive = correctAnswer.bare.endsWith('ся');
        String formationExplanation =
            ' ${isReflexive ? 'Reflexive a' : 'A'}ctive present participles are generally formed by taking the third-person plural form of the verb and replacing the "-${isReflexive ? 'тся' : 'т'}" suffix with a "-щий${isReflexive ? 'ся' : ''}" suffix.';
        return 'This word is a${isReflexive ? ' reflexive' : 'n'} active present participle. This means it is a verb form of a uncompleted action that can be used as an adjective to describe the subject of a sentence that is or will be performing said action${isReflexive ? ". This form is also reflexive, meaning the uncompleted verb's object is either the same as the subject or doesn't exist" : ''}.$formationExplanation\n\n$bare ➡️ ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} ➡️ ${correctAnswer.bare}';
      case WordFormType.ruVerbParticiplePassivePresent:
        return 'This word is a passive present participle. This means it is a verb form of an uncompleted action that can be used as an adjective to describe the subject of a sentence that experienced said action. To form a passive present participle, we generally take the 1st-person plural form of the verb and replace the "-м" suffix with a "-мый" suffix.\n\n$bare ➡️ ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl1]} ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounSgNom:
        return 'This word is a singular, nominative noun. This means it is typically the noun that is performing the verb in a sentence, i.e. the sentence\'s subject. This is the form of the noun that is listed in dictionaries.';
      case WordFormType.ruNounSgGen:
        String? formationExplanation;
        if (gender == null) {
          throw Exception(
              'Cannot explain formation of singular genitive noun if gender is not provided.');
        }

        switch (gender) {
          case Gender.m:
            if (correctAnswer.bare.endsWith('а')) {
              formationExplanation =
                  ' Masculine, genitive nouns with nominative forms ending in a consonant get an "-а" suffix after the stem.';
            } else if (correctAnswer.bare.endsWith('я')) {
              formationExplanation =
                  ' Masculine, genitive nouns with nominative forms ending in "-й" or "-ь" have their "-й" or "-ь" suffix replaced by a "-я" suffix.';
            } else if (correctAnswer.bare.endsWith('ы')) {
              formationExplanation =
                  ' Masculine, genitive nouns with nominative forms ending in "-а" have their "-а" suffix replaced by an "-ы" suffix.';
            } else if (correctAnswer.bare.endsWith('и')) {
              formationExplanation =
                  ' Masculine, genitive nouns with nominative forms ending in "-я" have their "-я" suffix replaced by an "-и" suffix.';
            }
          case Gender.f:
            if (correctAnswer.bare.endsWith('и') &&
                (bare.endsWith('ь') || bare.endsWith('я'))) {
              formationExplanation =
                  ' Feminine, genitive nouns with nominative forms ending in "-${bare.characters.last}" have their "-${bare.characters.last}" suffix replaced by an "-и" suffix.';
            } else if (correctAnswer.bare.endsWith('ы')) {
              formationExplanation =
                  ' Feminine, genitive nouns with nominative forms ending in "-а" have their "-а" suffix replaced by an "-ы" suffix.';
            }
          case Gender.n:
            if (correctAnswer.bare.endsWith('а')) {
              formationExplanation =
                  ' Neuter, genitive nouns with nominative forms ending in "-o" have their "-o" suffix replaced by an "-а" suffix.';
            } else if (correctAnswer.bare.endsWith('я')) {
              formationExplanation =
                  ' Neuter, genitive nouns with nominative forms ending in "-е" have their "-е" suffix replaced by an "-я" suffix.';
            }
          default:
            throw Exception('Expected a masculine, feminine, or neuter noun.');
        }

        return 'This word is a singular, genitive noun. This means it is a noun that indicates possession, origin, or close association of or to another noun.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounSgDat:
        String? formationExplanation;
        if (gender == null) {
          throw Exception(
              'Cannot explain formation of singular dative noun if gender is not provided.');
        }

        switch (gender) {
          case Gender.m:
            if (correctAnswer.bare.endsWith('у')) {
              formationExplanation =
                  ' Masculine, dative nouns with nominative forms ending in a consonant get an "-у" suffix after the stem.';
            } else if (correctAnswer.bare.endsWith('ю')) {
              formationExplanation =
                  ' Masculine, dative nouns with nominative forms ending in "-й" or "-ь" have their "-й" or "-ь" suffix replaced by a "-ю" suffix.';
            } else if (correctAnswer.bare.endsWith('е')) {
              formationExplanation =
                  ' Masculine, dative nouns with nominative forms ending in "-а" or "-я" have their "-а" or "-я" suffix replaced by an "-ы" suffix.';
            }
          case Gender.f:
            if (correctAnswer.bare.endsWith('е')) {
              formationExplanation =
                  ' Feminine, dative nouns with nominative forms ending in "-а" or "-я" have their "-а" or "-я" suffix replaced by an "-е" suffix.';
            } else if (correctAnswer.bare.endsWith('и')) {
              formationExplanation =
                  ' Feminine, dative nouns with nominative forms ending in "-ь" have their "-ь" suffix replaced by an "-и" suffix.';
            }
          case Gender.n:
            if (correctAnswer.bare.endsWith('у')) {
              formationExplanation =
                  ' Neuter, dative nouns with nominative forms ending in "-o" have their "-o" suffix replaced by an "-у" suffix.';
            } else if (correctAnswer.bare.endsWith('ю')) {
              formationExplanation =
                  ' Neuter, dative nouns with nominative forms ending in "-е" have their "-е" suffix replaced by an "-ю" suffix.';
            }
          default:
            throw Exception('Expected a masculine, feminine, or neuter noun.');
        }

        return 'This word is a singular, dative noun. This means it is a noun describing a single thing that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounSgAcc:
        String? formationExplanation;
        if (gender == null) {
          throw Exception(
              'Cannot explain formation of singular accusative noun if gender is not provided.');
        }

        switch (gender) {
          case Gender.m:
            if (correctAnswer.bare.endsWith('а')) {
              formationExplanation =
                  ' Masculine, animate, accusative nouns with nominative forms ending in a consonant get an "-а" suffix after the stem.';
            } else if (correctAnswer.bare.endsWith('я')) {
              formationExplanation =
                  ' Masculine, animate, accusative nouns with nominative forms ending in "-й" or "-ь" have their "-й" or "-ь" suffix replaced by a "-я" suffix.';
            } else if (bare == correctAnswer.bare) {
              formationExplanation =
                  ' Masculine, inanimate, accusative nouns are identical to their nominative forms.';
            }
          case Gender.f:
            if (correctAnswer.bare.endsWith('у')) {
              formationExplanation =
                  ' Feminine, accusative nouns with nominative forms ending in "-а" have their "-а" suffix replaced by an "-у" suffix.';
            } else if (correctAnswer.bare.endsWith('ю')) {
              formationExplanation =
                  ' Feminine, accusative nouns with nominative forms ending in "-я" have their "-я" suffix replaced by a "-ю" suffix.';
            } else if (correctAnswer.bare.endsWith('ь')) {
              formationExplanation =
                  ' Feminine, accusative nouns are identical to their nominative forms when their nominative forms end in a "-ь" suffix.';
            }
          case Gender.n:
            formationExplanation =
                ' Neuter, accusative nouns are identical to their nominative forms.';
          default:
            throw Exception('Expected a masculine, feminine, or neuter noun.');
        }

        return 'This word is a singular, accusative noun. This means it is a noun describing a single thing that is the direct object of a sentence, i.e. the thing that is acted on by the main verb.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounSgInst:
        String? formationExplanation;
        if (gender == null) {
          throw Exception(
              'Cannot explain formation of singular instrumental noun if gender is not provided.');
        }

        switch (gender) {
          case Gender.m:
            if (correctAnswer.bare.endsWith('ом')) {
              formationExplanation =
                  ' Masculine, instrumental nouns with nominative forms ending in a consonant get an "-ом" suffix after the stem.';
            } else if (correctAnswer.bare.endsWith('ем')) {
              formationExplanation =
                  ' Masculine, instrumental nouns with nominative forms ending in "-й" or "-ь" have their "-й" or "-ь" suffix replaced by a "-ем" suffix.';
            }
          case Gender.f:
            if (correctAnswer.bare.endsWith('ой')) {
              formationExplanation =
                  ' Feminine, instrumental nouns with nominative forms ending in "-а" have their "-а" suffix replaced by an "-ой" suffix.';
            } else if (correctAnswer.bare.endsWith('ей')) {
              formationExplanation =
                  ' Feminine, instrumental nouns with nominative forms ending in "-я" have their "-я" suffix replaced by a "-ей" suffix.';
            } else if (correctAnswer.bare.endsWith('ю')) {
              formationExplanation =
                  ' Feminine, instrumental nouns with nominative forms ending in "-ь" have their "-ь" suffix replaced by a "-ю" suffix.';
            }
          case Gender.n:
            if (correctAnswer.bare.endsWith('менем') && bare.endsWith('мя')) {
              formationExplanation =
                  ' Neuter, instrumental nouns with nominative forms ending in "-мя" have their "-мя" suffix replaced by a "-менем" suffix.';
            } else if (correctAnswer.bare.endsWith('ом')) {
              formationExplanation =
                  ' Neuter, instrumental nouns with nominative forms ending in "-о" have their "-о" suffix replaced by a "-ом" suffix.';
            } else if (correctAnswer.bare.endsWith('ем')) {
              formationExplanation =
                  ' Neuter, instrumental nouns with nominative forms ending in "-е" have their "-е" suffix replaced by a "-ем" suffix.';
            }
          default:
            throw Exception('Expected a masculine, feminine, or neuter noun.');
        }

        return 'This word is a singular, instrumental noun. This means it is a noun describing a single thing that is the means by or with which the subject accomplishes an action.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounSgPrep:
        String? formationExplanation;
        if (gender == null) {
          throw Exception(
              'Cannot explain formation of singular prepositional noun if gender is not provided.');
        }

        switch (gender) {
          case Gender.m:
            if (correctAnswer.bare.endsWith('е')) {
              if (bare.endsWith('й')) {
                formationExplanation =
                    ' Masculine, prepositional nouns with nominative forms ending in "-й" have their "-й" suffix replaced by an "-е" suffix.';
              } else {
                formationExplanation =
                    ' Masculine, prepositional nouns with nominative forms ending in a consonant get an "-е" suffix after the stem.';
              }
            }
          case Gender.f:
            if (correctAnswer.bare.endsWith('е') &&
                (bare.endsWith('а') || bare.endsWith('я'))) {
              formationExplanation =
                  ' Feminine, prepositional nouns with nominative forms ending in "-${bare.characters.last}" have their "-${bare.characters.last}" suffix replaced by an "-е" suffix.';
            } else if (correctAnswer.bare.endsWith('ии') &&
                bare.endsWith('ия')) {
              formationExplanation =
                  ' Feminine, prepositional nouns with nominative forms ending in "-ия" have their "-ия" suffix replaced by an "-ии" suffix.';
            } else if (correctAnswer.bare.endsWith('и') && bare.endsWith('ь')) {
              formationExplanation =
                  ' Feminine, prepositional nouns with nominative forms ending in "-ь" have their "-ь" suffix replaced by an "-и" suffix.';
            }
          case Gender.n:
            if (correctAnswer.bare.endsWith('е')) {
              if (bare.endsWith('о')) {
                formationExplanation =
                    ' Neuter, prepositional nouns with nominative forms ending in "-о" have their "-о" suffix replaced by an "-е" suffix.';
              } else if (bare.endsWith('е')) {
                formationExplanation =
                    ' Neuter, prepositional nouns are identical to their nominative forms when their nominative forms end in an "-е" suffix.';
              }
            } else if (correctAnswer.bare.endsWith('ии') &&
                bare.endsWith('ие')) {
              formationExplanation =
                  ' Neuter, prepositional nouns with nominative forms ending in "-ие" have their "-ие" suffix replaced by an "-ии" suffix.';
            } else if (correctAnswer.bare.endsWith('мени') &&
                bare.endsWith('мя')) {
              formationExplanation =
                  ' Neuter, prepositional nouns with nominative forms ending in "-мя" have their "-мя" suffix replaced by an "-мени" suffix.';
            }
          default:
            throw Exception('Expected a masculine, feminine, or neuter noun.');
        }
        return 'This word is a singular, prepositional noun. This means it is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?".$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounPlNom:
        String? formationExplanation;
        if (gender == null) {
          throw Exception(
              'Cannot explain formation of plural nominative noun if gender is not provided.');
        }

        switch (gender) {
          case Gender.m:
            if (correctAnswer.bare.endsWith('ы')) {
              formationExplanation =
                  ' Masculine, plural, nominative nouns with singular nominative forms ending in a consonant get a "-ы" suffix.';
            } else if (correctAnswer.bare.endsWith('и') &&
                (bare.endsWith('й') || bare.endsWith('ь'))) {
              formationExplanation =
                  ' Masculine, plural, nominative nouns with singular nominative forms ending in "-й" or "-ь" have their "-й" or "-ь" suffix replaced by an "-и" suffix.';
            }
          case Gender.f:
            if (correctAnswer.bare.endsWith('ы') && bare.endsWith('а')) {
              formationExplanation =
                  ' Feminine, plural, nominative nouns with singular nominative forms ending in "-а" have their "-а" suffix replaced by a "-ы" suffix.';
            } else if (correctAnswer.bare.endsWith('ии') &&
                bare.endsWith('ия')) {
              formationExplanation =
                  ' Feminine, plural, nominative nouns with singular nominative forms ending in "-ия" have their "-ия" suffix replaced by an "-ии" suffix.';
            } else if (correctAnswer.bare.endsWith('и') &&
                (bare.endsWith('я') || bare.endsWith('ь'))) {
              formationExplanation =
                  ' Feminine, plural, nominative nouns with singular nominative forms ending in "-я" or "-ь" have their "-я" or "-ь" suffix replaced by an "-и" suffix.';
            }
          case Gender.n:
            if (correctAnswer.bare.endsWith('a') && bare.endsWith('o')) {
              formationExplanation =
                  ' Neuter, plural, nominative nouns with singular nominative forms ending in "-o" have their "-o" suffix replaced by an "-a" suffix.';
            } else if (correctAnswer.bare.endsWith('ия') &&
                bare.endsWith('ие')) {
              formationExplanation =
                  ' Neuter, plural, nominative nouns with singular nominative forms ending in "-ие" have their "-ие" suffix replaced by an "-ия" suffix.';
            } else if (correctAnswer.bare.endsWith('мена') &&
                bare.endsWith('мя')) {
              formationExplanation =
                  ' Neuter, plural, nominative nouns with singular nominative forms ending in "-мя" have their "-мя" suffix replaced by an "-мена" suffix.';
            } else if (correctAnswer.bare.endsWith('я') && bare.endsWith('е')) {
              formationExplanation =
                  ' Neuter, plural, nominative nouns with singular nominative forms ending in "-e" have their "-e" suffix replaced by an "-я" suffix.';
            }
          default:
            throw Exception('Expected a masculine, feminine, or neuter noun.');
        }

        return 'This word is a plural, nominative noun. This means it describes multiple things and is typically the noun that is performing the verb in a sentence, i.e. the sentence\'s subject.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounPlGen:
        String? formationExplanation;
        if (gender == null) {
          throw Exception(
              'Cannot explain formation of plural genitive noun if gender is not provided.');
        }

        switch (gender) {
          case Gender.m:
            if (correctAnswer.bare.endsWith('ов')) {
              formationExplanation =
                  ' Masculine, plural, genitive nouns with singular nominative forms ending in a consonant get an "-ов" suffix.';
            } else if (correctAnswer.bare.endsWith('ев') &&
                bare.endsWith('й')) {
              formationExplanation =
                  ' Masculine, plural, genitive nouns with singular nominative forms ending in "-й" have their "-й" suffix replaced by an "-ев" suffix.';
            } else if (correctAnswer.bare.endsWith('ей') &&
                bare.endsWith('ь')) {
              formationExplanation =
                  ' Masculine, plural, genitive nouns with singular nominative forms ending in "-ь" have their "-ь" suffix replaced by an "-ей" suffix.';
            }
          case Gender.f:
            if (bare.endsWith('а')) {
              formationExplanation =
                  ' Feminine, plural, genitive nouns with singular nominative forms ending in "-а" have their "-а" suffix dropped.';
            } else if (correctAnswer.bare.endsWith('ь') && bare.endsWith('я')) {
              formationExplanation =
                  ' Feminine, plural, genitive nouns with singular nominative forms ending in "-я" have their "-я" suffix replaced by a "-ь" suffix.';
            } else if (correctAnswer.bare.endsWith('ий') &&
                bare.endsWith('ия')) {
              formationExplanation =
                  ' Feminine, plural, genitive nouns with singular nominative forms ending in "-ия" have their "-ия" suffix replaced by an "-ий" suffix.';
            } else if (correctAnswer.bare.endsWith('ей') &&
                bare.endsWith('ь')) {
              formationExplanation =
                  ' Feminine, plural, genitive nouns with singular nominative forms ending in "-ь" have their "-ь" suffix replaced by an "-ей" suffix.';
            }
          case Gender.n:
            if (bare.endsWith('o')) {
              formationExplanation =
                  ' Neuter, plural, genitive nouns with singular nominative forms ending in "-o" have their "-o" suffix dropped.';
            } else if (correctAnswer.bare.endsWith('ей') &&
                bare.endsWith('е')) {
              formationExplanation =
                  ' Neuter, plural, genitive nouns with singular nominative forms ending in "-е" have their "-е" suffix replaced by an "-ей" suffix.';
            } else if (correctAnswer.bare.endsWith('ий') &&
                bare.endsWith('ие')) {
              formationExplanation =
                  ' Neuter, plural, genitive nouns with singular nominative forms ending in "-ие" have their "-ие" suffix replaced by an "-ий" suffix.';
            }
          default:
            throw Exception('Expected a masculine, feminine, or neuter noun.');
        }
        return 'This word is a plural, genitive noun. This means it is a noun that describes multiple things and indicates possession, origin, or close association of or to another noun.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounPlDat:
        String? formationExplanation;

        if (correctAnswer.bare.endsWith('ам')) {
          if (bare.endsWith('а')) {
            formationExplanation =
                ' Plural, dative nouns with singular nominative forms ending in "-а" have their "-а" suffix replaced by an "-ам" suffix.';
          } else if (bare.endsWith('о')) {
            formationExplanation =
                ' Plural, dative nouns with singular nominative forms ending in "-о" have their "-о" suffix replaced by an "-ам" suffix.';
          } else {
            formationExplanation =
                ' Plural, dative nouns with singular nominative forms ending in a consonant get an "-ам" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ям')) {
          if (bare.endsWith('й') ||
              bare.endsWith('ь') ||
              bare.endsWith('е') ||
              bare.endsWith('я')) {
            final lastCharacter = bare.substring(bare.length - 1);
            formationExplanation =
                ' Plural, dative nouns with singular nominative forms ending in "-$lastCharacter" have their "-$lastCharacter" suffix replaced by an "-ям" suffix.';
          }
        }
        return 'This word is a plural, dative noun. This means it is a noun describing multiple things that are the indirect object of a sentence, i.e. the recipients or beneficiaries of the main verb.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounPlAcc:
        String? formationExplanation;
        if (gender == null) {
          throw Exception(
              'Cannot explain formation of plural accusative noun if gender is not provided.');
        }

        switch (gender) {
          case Gender.m:
            final String? pluralNominative =
                wordFormTypesToBareMap[WordFormType.ruNounPlNom];

            if (pluralNominative == null) {
              throw Exception(
                  'Cannot explain formation of plural accusative noun if plural nominative form is not provided.');
            } else if (correctAnswer.bare == pluralNominative) {
              formationExplanation =
                  ' Masculine, plural, inanimate, accusative nouns are identical to their plural nominative forms.';
            } else if (correctAnswer.bare.endsWith('ов')) {
              formationExplanation =
                  ' Masculine, plural, animate, accusative nouns with singular nominative forms ending in a consonant get an "-ов" suffix.';
            } else if (correctAnswer.bare.endsWith('ев') &&
                bare.endsWith('й')) {
              formationExplanation =
                  ' Masculine, plural, animate, accusative nouns with singular nominative forms ending in "-й" have their "-й" suffix replaced by an "-ев" suffix.';
            } else if (correctAnswer.bare.endsWith('ей') &&
                bare.endsWith('ь')) {
              formationExplanation =
                  ' Masculine, plural, animate, accusative nouns with singular nominative forms ending in "-ь" have their "-ь" suffix replaced by an "-ей" suffix.';
            }
          case Gender.f:
            final String? pluralNominative =
                wordFormTypesToBareMap[WordFormType.ruNounPlNom];

            if (pluralNominative == null) {
              throw Exception(
                  'Cannot explain formation of plural accusative noun if plural nominative form is not provided.');
            } else if (correctAnswer.bare == pluralNominative) {
              formationExplanation =
                  ' Feminine, plural, inanimate, accusative nouns are identical to their plural nominative forms.';
            } else if (bare.endsWith('а')) {
              formationExplanation =
                  ' Feminine, plural, accusative nouns with singular nominative forms ending in "-а" have their "-а" suffix dropped.';
            } else if (correctAnswer.bare.endsWith('ь') && bare.endsWith('я')) {
              formationExplanation =
                  ' Feminine, plural, accusative nouns with singular nominative forms ending in "-я" have their "-я" suffix replaced by a "-ь" suffix.';
            } else if (correctAnswer.bare.endsWith('ий') &&
                bare.endsWith('ия')) {
              formationExplanation =
                  ' Feminine, plural, accusative nouns with singular nominative forms ending in "-ия" have their "-ия" suffix replaced by an "-ий" suffix.';
            } else if (correctAnswer.bare.endsWith('ей') &&
                bare.endsWith('ь')) {
              formationExplanation =
                  ' Feminine, plural, accusative nouns with singular nominative forms ending in "-ь" have their "-ь" suffix replaced by an "-ей" suffix.';
            }
          case Gender.n:
            final String? pluralNominative =
                wordFormTypesToBareMap[WordFormType.ruNounPlNom];

            if (pluralNominative == null) {
              throw Exception(
                  'Cannot explain formation of plural accusative noun if plural nominative form is not provided.');
            } else if (correctAnswer.bare == pluralNominative) {
              formationExplanation =
                  ' Neuter, plural, accusative nouns are identical to their plural nominative forms.';
            }
          default:
            throw Exception('Expected a masculine, feminine, or neuter noun.');
        }

        return 'This word is a plural, accusative noun. This means it is a noun describing multiple things that are the direct object of a sentence, i.e. the things that are acted on by the main verb.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounPlInst:
        String? formationExplanation;

        if (correctAnswer.bare.endsWith('ами')) {
          if (bare.endsWith('а') || bare.endsWith('о')) {
            formationExplanation =
                ' Plural, instrumental nouns with singular nominative forms ending in "-а" or "-о" have their "-а" or "-о" suffix replaced by an "-ами" suffix.';
          } else {
            formationExplanation =
                ' Plural, instrumental nouns with singular nominative forms ending in a consonant get an "-ами" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ями') &&
            (bare.endsWith('й') ||
                bare.endsWith('ь') ||
                bare.endsWith('е') ||
                bare.endsWith('я'))) {
          final lastCharacter = bare.substring(bare.length - 1);
          formationExplanation =
              ' Plural, instrumental nouns with singular nominative forms ending in "-$lastCharacter" have their "-$lastCharacter" suffix replaced by an "-ями" suffix.';
        }

        return 'This word is a plural, instrumental noun. This means it is a noun describing multiple things that are the means by or with which the subject accomplishes an action.$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruNounPlPrep:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ах')) {
          if (bare.endsWith('а') || bare.endsWith('о')) {
            final lastCharacter = bare.substring(bare.length - 1);
            formationExplanation =
                ' Plural, prepositional nouns with singular nominative forms ending in "-$lastCharacter" have their "-$lastCharacter" suffix replaced by an "-ах" suffix.';
          } else {
            formationExplanation =
                ' Plural, prepositional nouns ending in a consonant get an "-ах" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ях')) {
          if (bare.endsWith('й') ||
              bare.endsWith('ь') ||
              bare.endsWith('е') ||
              bare.endsWith('я')) {
            final lastCharacter = bare.substring(bare.length - 1);
            formationExplanation =
                ' Plural, prepositional nouns with singular nominative forms ending in "-$lastCharacter" have their "-$lastCharacter" suffix replaced by an "-ях" suffix.';
          }
        }
        return 'This word is a plural, prepositional noun. This means it describes multiple things that are the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?".$formationExplanation\n\n$bare ➡️ ${correctAnswer.bare}';
      case WordFormType.ruAdjComparative:
        return '';
      case WordFormType.ruAdjSuperlative:
        return '';
      case WordFormType.ruAdjShortM:
        return '';
      case WordFormType.ruAdjShortF:
        return '';
      case WordFormType.ruAdjShortN:
        return '';
      case WordFormType.ruAdjShortPl:
        return '';
    }
    return 'This is the explanation for the sentence exercise.';
  }
}
