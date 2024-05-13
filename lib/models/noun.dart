import 'package:flutter/material.dart';
import 'package:uchu/extensions/map_string_dynamic_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/level.dart';
import 'package:uchu/models/question.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/models/word_type.dart';

class Noun extends Question<Gender> {
  const Noun._({
    required super.correctAnswer,
    required super.possibleAnswers,
    required super.explanation,
    required this.partner,
    required this.animate,
    required this.indeclinable,
    required this.sgOnly,
    required this.plOnly,
    required this.word,
  });

  final String? partner;
  final bool animate;
  final bool indeclinable;
  final bool sgOnly;
  final bool plOnly;
  final Word word;

  factory Noun.fromJson(Map<String, dynamic> json) {
    final genderJson = json['gender'];
    final partnerJson = json['partner'];

    final animateBool = json.parseBoolForKey('animate');
    final indeclinableBool = json.parseBoolForKey('indeclinable');
    final sgOnlyBool = json.parseBoolForKey('sg_only');
    final plOnlyBool = json.parseBoolForKey('pl_only');

    final gender = StringExtension.isNullOrEmpty(genderJson)
        ? null
        : Gender.values.byName(genderJson.toLowerCase());

    if (gender == null) {
      throw ArgumentError("Noun's gender must not be null");
    } else {
      return Noun._(
        correctAnswer: gender,
        possibleAnswers: const [
          Gender.m,
          Gender.f,
          Gender.n,
        ],
        explanation: json['explanation'],
        word: Word.fromJson({
          'id': json['id'],
          'position': json['position'],
          'bare': json['bare'],
          'accented': json['accented'],
          'derived_from_word_id': json['derived_from_word_id'],
          'rank': json['rank'],
          'disabled': json['disabled'],
          'audio': json['audio'],
          'usage_en': json['usage_en'],
          'usage_de': json['usage_de'],
          'number_value': json['number_value'],
          'type': json['type'],
          'level': json['level'],
          'created_at': json['created_at'],
        }),
        partner:
            StringExtension.isNullOrEmpty(partnerJson) ? null : partnerJson,
        animate: animateBool,
        indeclinable: indeclinableBool,
        sgOnly: sgOnlyBool,
        plOnly: plOnlyBool,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word.toJson(),
      'gender': correctAnswer.name,
      'partner': partner,
      'animate': animate,
      'indeclinable': indeclinable,
      'sg_only': sgOnly,
      'pl_only': plOnly,
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<Object?> get props => [
        ...super.props,
        word,
        partner,
        animate,
        indeclinable,
        sgOnly,
        plOnly,
      ];

  @visibleForTesting
  factory Noun.testValue({
    Gender gender = Gender.m,
    String partner = 'подру́га',
    bool animate = true,
    bool indeclinable = false,
    bool sgOnly = false,
    bool plOnly = false,
    String explanation = 'because I said so',
    int wordId = 28,
    int? position,
    String bare = 'сказать',
    String accented = "сказа'ть",
    int? derivedFromWordId,
    int rank = 20,
    bool wordDisabled = false,
    String audio = 'https://openrussian.org/audio-shtooka/сказать.mp3',
    String usageEn = 'скажи́те, пожа́луйста - tell me, please',
    String usageDe = 'кому? о чём?',
    int? numberValue,
    WordType type = WordType.verb,
    Level wordLevel = Level.A2,
    DateTime? createdAt,
  }) {
    return Noun.fromJson({
      'gender': gender.name,
      'partner': partner,
      'animate': animate,
      'indeclinable': indeclinable,
      'sg_only': sgOnly,
      'pl_only': plOnly,
      'explanation': explanation,
      'id': wordId,
      'position': position,
      'bare': bare,
      'accented': accented,
      'derived_from_word_id': derivedFromWordId,
      'rank': rank,
      'word_disabled': wordDisabled,
      'audio': audio,
      'usage_en': usageEn,
      'usage_de': usageDe,
      'number_value': numberValue,
      'type': type.name,
      'word_level': wordLevel,
      'created_at': createdAt,
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
