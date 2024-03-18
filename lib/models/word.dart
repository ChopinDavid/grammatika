import 'package:uchu/models/level.dart';
import 'package:uchu/models/word_type.dart';

class Word {
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
  final int rank;
  final bool disabled;
  final String audio;
  final String? usageEn;
  final String? usageDe;
  final int? numberValue;
  final WordType type;
  final Level? level;
  final DateTime createdAt;

  factory Word.fromJson(Map<String, dynamic> json) {
    final derivedFromWordIdString = json['derived_from_word_id'];
    final levelString = json['level'];
    final numberValueString = json['number_value'];
    final positionString = json['position'];
    final usageDeString = json['usage_de'];
    final usageEnString = json['usage_en'];
    return Word._(
      accented: json['accented'],
      audio: json['audio'],
      bare: json['bare'],
      createdAt: DateTime.parse(json['created_at']),
      derivedFromWordId: derivedFromWordIdString == ''
          ? null
          : int.parse(derivedFromWordIdString),
      disabled: json['disabled'] == 0 ? false : true,
      id: int.parse(json['id']),
      level: levelString == '' ? null : Level.values.byName(levelString),
      numberValue:
          numberValueString == '' ? null : int.parse(numberValueString),
      position: positionString == '' ? null : int.parse(positionString),
      rank: int.parse(json['rank']),
      type: WordType.values.byName(json['type']),
      usageDe: usageDeString == '' ? null : usageDeString,
      usageEn: usageEnString == '' ? null : usageEnString,
    );
  }
}
