import 'package:equatable/equatable.dart';
import 'package:uchu/extensions/map_string_dynamic_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/level.dart';
import 'package:uchu/models/word_form_type.dart';

class Sentence extends Equatable {
  Sentence._({
    required this.id,
    required this.ru,
    required this.tatoebaKey,
    required this.disabled,
    required this.level,
    required this.wordId,
    required this.formType,
  });

  final int id;
  final String ru;
  final int? tatoebaKey;
  final bool disabled;
  final Level? level;
  final int wordId;
  final WordFormType formType;

  factory Sentence.fromJson(Map<String, dynamic> json) {
    final String? levelString = json['level'];

    return Sentence._(
      id: json.parseIntForKey('id'),
      ru: json['ru'],
      tatoebaKey: json.parseOptionalIntForKey('tatoeba_key'),
      disabled: json.parseBoolForKey('disabled'),
      level: StringExtension.isNullOrEmpty(levelString)
          ? null
          : Level.values.byName(levelString!),
      wordId: json.parseIntForKey('word_id'),
      formType: WordFormTypeExt.fromString(json['form_type']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        ru,
        tatoebaKey,
        disabled,
        level,
        wordId,
        formType,
      ];
}
