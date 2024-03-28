import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/db_helper.dart';
import 'package:uchu/extensions/map_string_dynamic_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word.dart';

class Noun extends Equatable {
  const Noun._({
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word_id': wordId,
      'gender': gender?.name,
      'partner': partner,
      'animate': animate,
      'indeclinable': indeclinable,
      'sg_only': sgOnly,
      'pl_only': plOnly,
    }..removeWhere((key, value) => value == null);
  }

  Future<Word> get word async {
    final db = await GetIt.instance.get<DbHelper>().getDatabase();
    final result = await db.rawQuery('SELECT * FROM words WHERE id = $wordId');
    return Word.fromJson(result.single);
  }

  @override
  List<Object?> get props => [
        wordId,
        gender,
        partner,
        animate,
        indeclinable,
        sgOnly,
        plOnly,
      ];

  @visibleForTesting
  factory Noun.testValue({
    int wordId = 97,
    Gender gender = Gender.m,
    String partner = 'подру́га',
    bool animate = true,
    bool indeclinable = false,
    bool sgOnly = false,
    bool plOnly = false,
  }) {
    return Noun.fromJson({
      'word_id': wordId,
      'gender': gender.name,
      'partner': partner,
      'animate': animate,
      'indeclinable': indeclinable,
      'sg_only': sgOnly,
      'pl_only': plOnly,
    });
  }

  @visibleForTesting
  factory Noun.testValueSimple({
    int wordId = 97,
    Gender? gender,
    String? partner,
    bool animate = true,
    bool indeclinable = false,
    bool sgOnly = false,
    bool plOnly = false,
  }) {
    return Noun.fromJson({
      'word_id': wordId,
      'gender': gender?.name,
      'partner': partner,
      'animate': animate,
      'indeclinable': indeclinable,
      'sg_only': sgOnly,
      'pl_only': plOnly,
    });
  }
}
