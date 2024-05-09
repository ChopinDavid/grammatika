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

  String? sentenceExplanation() {
    // TODO(DC): Flesh this out.
    return 'This is the explanation for the sentence exercise.';
  }
}
