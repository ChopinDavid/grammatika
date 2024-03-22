import 'package:uchu/db_helper.dart';
import 'package:uchu/extensions.dart';
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
  final String? partner;
  final bool animate;
  final bool indeclinable;
  final bool sgOnly;
  final bool plOnly;

  factory Noun.fromJson(Map<String, dynamic> json) {
    final wordIdJson = json['word_id'];
    final wordIdInt =
        wordIdJson is String ? int.tryParse(wordIdJson) : wordIdJson;
    assert(wordIdInt is int, '"word_id" must be of type int or String');
    final genderJson = json['gender'];
    final partnerJson = json['partner'];

    bool parseBoolFromKey(String key) {
      late final bool? boolValue;
      final value = json[key];
      if (value is bool) {
        boolValue = value;
      } else if (value is int) {
        boolValue = value == 0
            ? false
            : value == 1
                ? true
                : null;
      } else if (value is String) {
        boolValue = value == '0'
            ? false
            : value == '1'
                ? true
                : null;
      } else if (value == null) {
        boolValue = false;
      } else {
        boolValue = null;
      }

      assert(boolValue is bool,
          '"$key" must be of type bool, int (0 or 1), or String ("0" or "1")');
      return boolValue!;
    }

    final animateBool = parseBoolFromKey('animate');
    final indeclinableBool = parseBoolFromKey('indeclinable');
    final sgOnlyBool = parseBoolFromKey('sg_only');
    final plOnlyBool = parseBoolFromKey('pl_only');

    return Noun._(
      wordId: wordIdInt,
      gender: StringExtensions.isNullOrEmpty(genderJson)
          ? null
          : Gender.values.byName(genderJson.toLowerCase()),
      partner: StringExtensions.isNullOrEmpty(partnerJson) ? null : partnerJson,
      animate: animateBool,
      indeclinable: indeclinableBool,
      sgOnly: sgOnlyBool,
      plOnly: plOnlyBool,
    );
  }

  Future<Word> get word async {
    final db = await DbHelper.getDatabase();
    final result = await db.rawQuery("SELECT * FROM words WHERE id = $wordId");
    return Word.fromJson(result.single);
  }
}
