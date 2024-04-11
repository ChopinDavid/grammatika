import 'package:get_it/get_it.dart';

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
        return answer.gradeAnswer(correctAnswer: gender);
      } else {
        throw (Exception('Gender not found on noun'));
      }
    }
    return answer;
  }
}
