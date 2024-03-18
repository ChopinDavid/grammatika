import 'package:uchu/db_helper.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word.dart';

class Noun {
  Noun._({
    required this.wordId,
    required this.gender,
    required this.partner,
    required this.animate,
    required this.indeclinable,
    required this.sgOnly,
    required this.plOnly,
  });

  final int wordId;
  final Gender? gender;
  final String partner;
  final bool animate;
  final bool indeclinable;
  final bool sgOnly;
  final bool plOnly;

  factory Noun.fromJson(Map<String, dynamic> json) {
    final genderJson = json['gender'];
    return Noun._(
      wordId: int.parse(json['word_id']),
      gender: genderJson == '' ? null : Gender.values.byName(genderJson),
      partner: json['partner'],
      animate: json['animate'] == 0 ? false : true,
      indeclinable: json['indeclinable'] == 0 ? false : true,
      sgOnly: json['sgOnly'] == 0 ? false : true,
      plOnly: json['plOnly'] == 0 ? false : true,
    );
  }

  Future<Word> get word async {
    final db = await DbHelper.getDatabase();
    final result = await db.rawQuery("SELECT * FROM words WHERE id = $wordId");
    return Word.fromJson(result.single);
  }
}
