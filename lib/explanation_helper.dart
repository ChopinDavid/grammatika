import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';

import 'consts.dart';
import 'models/gender.dart';

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
      default:
        return '';
    }
  }

  String? sentenceExplanation({
    required String bare,
    required WordForm correctAnswer,
    required Map<WordFormType, String> wordFormTypesToBareMap,
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
        return 'This word is a perfective gerund, also known as a perfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is perfective, meaning that the gerund denotes a result or completed action, having taken place before the main verb.${formationExplanation ?? ''}\n\n$bare -> ${correctAnswer.bare}';
      case WordFormType.ruVerbGerundPresent:
        bool isReflexive =
            bare.endsWith('ться') && correctAnswer.bare.endsWith('сь');
        final usesSpellingRule = correctAnswer.bare.endsWith('ась') ||
            correctAnswer.bare.endsWith('а');
        return 'This word is an imperfective gerund, also known as an imperfective adverbial participle. Gerunds are formed from verbs and are used to describe an action, preceding the action expressed by the main verb. This gerund is imperfective, meaning that the gerund denotes a process or incomplete action, taking place simultaneously with the main verb. Since the verb in this sentence is ${isReflexive ? '' : 'not '}reflexive, you take the third person plural form of the verb and replace its suffix with either a ${isReflexive ? '"-ась" or "-ясь"' : '"-а" or "-я"'} suffix. Since "a" always follows "ж", "ш", "ч", or "щ", we will use ${usesSpellingRule ? isReflexive ? '"-ась"' : '"-а"' : isReflexive ? '"-ясь"' : '"-я"'} in this case.\n\n$bare -> ${wordFormTypesToBareMap[WordFormType.ruVerbPresfutPl3]} -> ${correctAnswer.bare}';
      case WordFormType.ruBase:
        return '';
      case WordFormType.ruAdjMNom:
        String? formationExplanation =
            getAdjNomExplanation(bare, gender: Gender.m);

        return 'This word is a masculine adjective in the nominative case. This means that it is a word that modifies a masculine noun that is the subject of a verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
      case WordFormType.ruAdjMGen:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ого')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, genitive adjective with a hard-consonant stem, we add the "-ого" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('его')) {
          formationExplanation =
              ' Masculine, genitive adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
        }
        return 'This word is a masculine adjective in the genitive case. This means that it is a word that modifies a masculine noun that indicates possession, origin, or close association of or to another noun.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
      case WordFormType.ruAdjMDat:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ому')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, dative adjective with a hard-consonant stem, we add the "-ому" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('ему')) {
          formationExplanation =
              ' Masculine, dative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ему" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
        }
        return 'This word is a masculine adjective in the dative case. This means that it is a word that modifies a masculine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
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
        }
        if (correctAnswer.bare.endsWith('ого')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, accusative adjective with a hard-consonant stem, we add the "-ого" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('его')) {
          formationExplanation =
              ' Masculine, accusative adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-его" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
        }
        return 'This word is a masculine adjective in the accusative case. This means that it is a word that modifies a masculine noun that is the direct object of a sentence, i.e. the noun which the verb is acting on.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
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
        return 'This word is a masculine adjective in the instrumental case. This means that it is a word that modifies a masculine noun that is the means by or with which the subject accomplishes an action.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
      case WordFormType.ruAdjMPrep:
        String? formationExplanation;
        if (correctAnswer.bare.endsWith('ом')) {
          formationExplanation =
              ' The majority of Russian adjectives have a stem ending in a hard consonant, this adjective included. Since this is a masculine, prepositional adjective with a hard-consonant stem, we add the "-ом" suffix after the stem. Their nominative forms would normally have the "-ый" (or, more rarely, the "-ой") suffix.';
        } else if (correctAnswer.bare.endsWith('ем')) {
          formationExplanation =
              ' Masculine, prepositional adjectives with stems ending in "-к", "-г", "-х", "-ж", "-ш", "-ч", "-щ", or a soft "-н" get a "-ем" suffix after their stem. Their nominative forms would normally have the "-ий" suffix.';
        }
        return 'This word is a masculine adjective in the prepositional case. This means that it is a word that modifies a masculine noun that is the object of a preposition, the preposition generally being "в"/"во", "на", "о"/"об", "при", or "по", forming a phrase answering "about who?", "about what?", "in whose presence?", "where?", or "in/on what?".${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
      case WordFormType.ruAdjFNom:
        String? formationExplanation =
            getAdjNomExplanation(correctAnswer.bare, gender: Gender.f);

        return 'This word is a feminine adjective in the nominative case. This means that it is a word that modifies a feminine noun that is the subject of a verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
      case WordFormType.ruAdjFGen:
        String? formationExplanation;
        final nominativeForm = wordFormTypesToBareMap[WordFormType.ruAdjFNom];
        if (correctAnswer.bare.endsWith('ей')) {
          if (nominativeForm?.endsWith('ая') == true) {
            formationExplanation =
                ' Feminine, genitive adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
          } else {
            formationExplanation =
                ' Feminine, genitive adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ой')) {
          formationExplanation =
              ' Feminine, genitive adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
        }
        return 'This word is a feminine adjective in the genitive case. This means that it is a word that modifies a feminine noun that indicates possession, origin, or close association of or to another noun.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
      case WordFormType.ruAdjFDat:
        String? formationExplanation;
        final nominativeForm = wordFormTypesToBareMap[WordFormType.ruAdjFNom];
        if (correctAnswer.bare.endsWith('ей')) {
          if (nominativeForm?.endsWith('ая') == true) {
            formationExplanation =
                ' Feminine, dative adjectives with stems ending in "-ж", "-ш", "-ч", or "-щ" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
          } else {
            formationExplanation =
                ' Feminine, dative adjectives with stems ending in a soft "-н" get a "-ей" suffix after their stem. Their nominative forms would normally have the "-яя" suffix.';
          }
        } else if (correctAnswer.bare.endsWith('ой')) {
          formationExplanation =
              ' Feminine, dative adjectives with stems that do not end in "-ж", "-ш", "-ч", or "-щ", or a soft "-н" get a "-ой" suffix after their stem. Their nominative forms would normally have the "-ая" suffix.';
        }
        return 'This word is a feminine adjective in the dative case. This means that it is a word that modifies a masculine noun that is the indirect object of a sentence, i.e. the recipient or beneficiary of the main verb.${formationExplanation ?? ''}\n\n${bare.substring(0, bare.length - 2)}- -> ${correctAnswer.bare}';
      case WordFormType.ruAdjFAcc:
        return '';
      case WordFormType.ruAdjFInst:
        return '';
      case WordFormType.ruAdjFPrep:
        return '';
      case WordFormType.ruAdjNNom:
        return '';
      case WordFormType.ruAdjNGen:
        return '';
      case WordFormType.ruAdjNDat:
        return '';
      case WordFormType.ruAdjNAcc:
        return '';
      case WordFormType.ruAdjNInst:
        return '';
      case WordFormType.ruAdjNPrep:
        return '';
      case WordFormType.ruAdjPlNom:
        return '';
      case WordFormType.ruAdjPlGen:
        return '';
      case WordFormType.ruAdjPlDat:
        return '';
      case WordFormType.ruAdjPlAcc:
        return '';
      case WordFormType.ruAdjPlInst:
        return '';
      case WordFormType.ruAdjPlPrep:
        return '';
      case WordFormType.ruVerbImperativeSg:
        return '';
      case WordFormType.ruVerbImperativePl:
        return '';
      case WordFormType.ruVerbPastM:
        return '';
      case WordFormType.ruVerbPastF:
        return '';
      case WordFormType.ruVerbPastN:
        return '';
      case WordFormType.ruVerbPastPl:
        return '';
      case WordFormType.ruVerbPresfutSg1:
        return '';
      case WordFormType.ruVerbPresfutSg2:
        return '';
      case WordFormType.ruVerbPresfutSg3:
        return '';
      case WordFormType.ruVerbPresfutPl1:
        return '';
      case WordFormType.ruVerbPresfutPl2:
        return '';
      case WordFormType.ruVerbPresfutPl3:
        return '';
      case WordFormType.ruVerbParticipleActivePast:
        return '';
      case WordFormType.ruVerbParticiplePassivePast:
        return '';
      case WordFormType.ruVerbParticipleActivePresent:
        return '';
      case WordFormType.ruVerbParticiplePassivePresent:
        return '';
      case WordFormType.ruNounSgNom:
        return '';
      case WordFormType.ruNounSgGen:
        return '';
      case WordFormType.ruNounSgDat:
        return '';
      case WordFormType.ruNounSgAcc:
        return '';
      case WordFormType.ruNounSgInst:
        return '';
      case WordFormType.ruNounSgPrep:
        return '';
      case WordFormType.ruNounPlNom:
        return '';
      case WordFormType.ruNounPlGen:
        return '';
      case WordFormType.ruNounPlDat:
        return '';
      case WordFormType.ruNounPlAcc:
        return '';
      case WordFormType.ruNounPlInst:
        return '';
      case WordFormType.ruNounPlPrep:
        return '';
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
