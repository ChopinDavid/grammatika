import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uchu/extensions.dart';
import 'package:uchu/extensions/map_string_dynamic_extension.dart';
import 'package:uchu/models/level.dart';
import 'package:uchu/models/word_type.dart';

class Word extends Equatable {
  const Word._({
    required this.id,
    required this.position,
    required this.bare,
    required this.accented,
    required this.derivedFromWordId,
    required this.rank,
    required this.disabled,
    required this.audio,
    required this.usageEn,
    required this.usageDe,
    required this.numberValue,
    required this.type,
    required this.level,
    required this.createdAt,
  });

  final int id;
  final int? position;
  final String bare;
  final String accented;
  final int? derivedFromWordId;
  final int? rank;
  final bool disabled;
  final String? audio;
  final String? usageEn;
  final String? usageDe;
  final int? numberValue;
  final WordType? type;
  final Level? level;
  final DateTime? createdAt;

  factory Word.fromJson(Map<String, dynamic> json) {
    final levelString = json['level'];
    final usageDeString = json['usage_de'];
    final usageEnString = json['usage_en'];
    final createdAtString = json['created_at'];
    final typeString = json['type'];
    return Word._(
      accented: json['accented'],
      audio: json['audio'],
      bare: json['bare'],
      createdAt: StringExtensions.isNullOrEmpty(createdAtString)
          ? null
          : DateTime.parse(createdAtString),
      derivedFromWordId: json.parseOptionalIntForKey('derived_from_word_id'),
      disabled: json.parseBoolForKey('disabled'),
      id: json.parseIntForKey('id'),
      level: StringExtensions.isNullOrEmpty(levelString)
          ? null
          : Level.values.byName(levelString),
      numberValue: json.parseOptionalIntForKey('number_value'),
      position: json.parseOptionalIntForKey('position'),
      rank: json.parseOptionalIntForKey('rank'),
      type: StringExtensions.isNullOrEmpty(typeString)
          ? null
          : WordType.values.byName(typeString),
      usageDe:
          StringExtensions.isNullOrEmpty(usageDeString) ? null : usageDeString,
      usageEn:
          StringExtensions.isNullOrEmpty(usageEnString) ? null : usageEnString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<Object?> get props => [
        id,
        position,
        bare,
        accented,
        derivedFromWordId,
        rank,
        disabled,
        audio,
        usageEn,
        usageDe,
        numberValue,
        type,
        level,
        createdAt,
      ];

  @visibleForTesting
  factory Word.testValue({
    int id = 1411,
    int position = 1,
    String bare = 'тепло',
    String accented = 'тепло\'',
    int derivedFromWordId = 722,
    int rank = 1388,
    bool disabled = false,
    String audio = 'https://openrussian.org/audio-shtooka/тепло.mp3',
    String usageEn = 'warm',
    String usageDe = 'warm',
    int numberValue = 0,
    WordType type = WordType.adverb,
    Level level = Level.B2,
    DateTime? createdAt,
  }) {
    createdAt ??= DateTime.parse('2020-01-01 00:00:00');
    return Word.fromJson({
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
      'type': type.name,
      'level': level.name,
      'created_at': createdAt.toIso8601String(),
    });
  }

  @visibleForTesting
  factory Word.testValueSimple({
    int id = 1411,
    int? position,
    String bare = 'тепло',
    String accented = 'тепло\'',
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
  }) {
    return Word.fromJson({
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
    });
  }
}
