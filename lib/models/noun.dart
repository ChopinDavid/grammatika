import 'package:flutter/material.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/extensions/map_string_dynamic_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
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
    @visibleForTesting DbHelper? dbHelper,
  }) : dbHelper = dbHelper ?? DbHelper();

  final int wordId;
  final Gender? gender;
  final String? partner;
  final bool animate;
  final bool indeclinable;
  final bool sgOnly;
  final bool plOnly;
  final DbHelper dbHelper;

  factory Noun.fromJson(
    Map<String, dynamic> json, {
    @visibleForTesting DbHelper? dbHelper,
  }) {
    final genderJson = json['gender'];
    final partnerJson = json['partner'];

    final animateBool = json.parseBoolForKey('animate');
    final indeclinableBool = json.parseBoolForKey('indeclinable');
    final sgOnlyBool = json.parseBoolForKey('sg_only');
    final plOnlyBool = json.parseBoolForKey('pl_only');

    return Noun._(
      wordId: json.parseIntForKey('word_id'),
      gender: StringExtension.isNullOrEmpty(genderJson)
          ? null
          : Gender.values.byName(genderJson.toLowerCase()),
      partner: StringExtension.isNullOrEmpty(partnerJson) ? null : partnerJson,
      animate: animateBool,
      indeclinable: indeclinableBool,
      sgOnly: sgOnlyBool,
      plOnly: plOnlyBool,
      dbHelper: dbHelper,
    );
  }

  Future<Word> get word async {
    final db = await dbHelper.getDatabase();
    final result = await db.rawQuery('SELECT * FROM words WHERE id = $wordId');
    return Word.fromJson(result.single);
  }
}
