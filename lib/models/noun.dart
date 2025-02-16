import 'package:flutter/material.dart';
import 'package:grammatika/extensions/map_string_dynamic_extension.dart';
import 'package:grammatika/extensions/string_extension.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/level.dart';
import 'package:grammatika/models/question.dart';
import 'package:grammatika/models/word.dart';
import 'package:grammatika/models/word_type.dart';

class Noun extends Question<Gender> {
  const Noun._({
    required super.correctAnswer,
    required super.answerSynonyms,
    required super.possibleAnswers,
    required super.explanation,
    super.visualExplanation,
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
        answerSynonyms: const [],
        possibleAnswers: const [
          Gender.m,
          Gender.f,
          Gender.n,
        ],
        explanation: json['explanation'],
        visualExplanation: json['visual_explanation'],
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
      'gender': correctAnswer.name,
      'explanation': explanation,
      if (visualExplanation != null) 'visual_explanation': visualExplanation,
      'id': word.id,
      'position': word.position,
      'bare': word.bare,
      'accented': word.accented,
      'derived_from_word_id': word.derivedFromWordId,
      'rank': word.rank,
      'disabled': word.disabled,
      'audio': word.audio,
      'usage_en': word.usageEn,
      'usage_de': word.usageDe,
      'number_value': word.numberValue,
      'type': word.type?.name,
      'level': word.level?.name,
      'created_at': word.createdAt?.toIso8601String(),
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
    String explanation = 'because I said so',
    String visualExplanation = '',
    int wordId = 97,
    int position = 0,
    String bare = 'друг',
    String accented = "друг",
    int derivedFromWordId = 0,
    int rank = 83,
    bool wordDisabled = false,
    String audio = 'https://openrussian.org/audio-shtooka/сказать.mp3',
    String usageEn = '''друг с другом: with one another
друг к другу: to each other''',
    String usageDe = '''друг с другом: with one another
друг к другу: to each other''',
    int numberValue = 0,
    WordType type = WordType.noun,
    Level level = Level.A2,
    DateTime? createdAt,
    String partner = 'подру́га',
    bool animate = true,
    bool indeclinable = false,
    bool sgOnly = false,
    bool plOnly = false,
  }) {
    createdAt ??= DateTime.parse('2020-01-01 00:00:00');
    return Noun.fromJson({
      'gender': gender.name,
      'explanation': explanation,
      'visual_explanation': visualExplanation,
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
      'level': level.name,
      'created_at': createdAt.toIso8601String(),
      'partner': partner,
      'animate': animate,
      'indeclinable': indeclinable,
      'sg_only': sgOnly,
      'pl_only': plOnly,
    });
  }

  @visibleForTesting
  factory Noun.testValueSimple({
    Gender gender = Gender.m,
    String explanation = 'because I said so',
    String? visualExplanation,
    int id = 97,
    int? position,
    String bare = 'друг',
    String accented = "друг",
    int? derivedFromWordId,
    int? rank,
    bool disabled = false,
    String? audio,
    String? usageEn,
    String? usageDe,
    int? numberValue,
    WordType? type,
    Level? level,
    DateTime? createdAt,
    String? partner,
    bool animate = true,
    bool indeclinable = false,
    bool sgOnly = false,
    bool plOnly = false,
  }) {
    return Noun.fromJson({
      'gender': gender.name,
      'explanation': 'because I said so',
      'visual_explanation': visualExplanation,
      'id': id,
      'position': position,
      'bare': bare,
      'accented': accented,
      'derived_from_word_id': derivedFromWordId,
      'rank': rank,
      'disabled': disabled,
      'audio': audio,
      'usage_en': usageEn,
      'usage_de': usageDe,
      'number_value': numberValue,
      'type': type?.name,
      'level': level?.name,
      'created_at': createdAt?.toIso8601String(),
      'partner': partner,
      'animate': animate,
      'indeclinable': indeclinable,
      'sg_only': sgOnly,
      'pl_only': plOnly,
    });
  }
}
