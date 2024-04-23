import 'package:get_it/get_it.dart';
import 'package:uchu/consts.dart';

import 'db_helper.dart';
import 'models/answer.dart';
import 'models/gender.dart';
import 'models/noun.dart';

class AnswerHelper {
  const AnswerHelper();
  Future<Answer> processAnswer({
    required Answer answer,
  }) async {
    if (answer is Answer<Gender>) {
      final db = await GetIt.instance.get<DbHelper>().getDatabase();
      final noun = Noun.fromJson(
        ((await db.rawQuery(
                    "SELECT * FROM nouns WHERE word_id=${answer.word.id};"))
                as List<Map<String, dynamic>>)
            .single,
      );
      final gender = noun.gender;
      if (gender == Gender.pl || gender == Gender.both) {
        throw (Exception('Gender was not m, f, or n'));
      } else if (gender != null) {
        return answer.gradeAnswer(
            correctAnswer: gender,
            explanation: _getGenderExplanation(
              bare: answer.word.bare,
              gender: gender,
            ));
      } else {
        throw (Exception('Gender not found on noun'));
      }
    }
    return answer;
  }

  String? _getGenderExplanation({
    required String bare,
    required Gender gender,
  }) {
    final lastCharacter = bare.substring(bare.length - 1).toLowerCase();
    if (lastCharacter == 'ь') {
      return 'Most nouns ending in -ь are feminine, but there are many masculine ones too, so you have to learn the gender of soft-sign nouns.';
    }

    if (gender == Gender.m) {
      if (masculineNounEndings.contains(lastCharacter)) {
        return 'Masculine nouns normally end with a consonant or -й.';
      }

      if (feminineNounEndings.contains(lastCharacter)) {
        return 'Nouns ending in -а or -я which denote males are masculine. This may be the case here.';
      }
    }

    if (gender == Gender.f) {
      if (feminineNounEndings.contains(lastCharacter)) {
        return 'Feminine nouns normally end with -а or -я.';
      }

      return 'Foreign words denoting females are feminine, whatever their endings. This may be the case here.';
    }

    if (gender == Gender.n) {
      if (neuterNounEndings.contains(lastCharacter)) {
        return 'Neuter nouns generally end in -о or -е.';
      }

      if (foreignNeuterNounEndings.contains(lastCharacter)) {
        return 'If a noun ends in -и or -у or -ю, it is likely to be a foreign borrowing and to be neuter.';
      }
    }
  }
}
