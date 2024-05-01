import 'package:equatable/equatable.dart';
import 'package:uchu/extensions/map_string_dynamic_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/level.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';

class Sentence extends Equatable {
  const Sentence._({
    required this.id,
    required this.ru,
    required this.tatoebaKey,
    required this.disabled,
    required this.level,
    required this.wordId,
    required this.formType,
    required this.possibleAnswers,
  });

  final int id;
  final String ru;
  final int? tatoebaKey;
  final bool disabled;
  final Level? level;
  final int wordId;
  final WordFormType formType;
  final List<WordForm>? possibleAnswers;

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
      possibleAnswers: null,
    );
  }

  Sentence withPossibleAnswers(List<WordForm> possibleAnswers) {
    return Sentence._(
      id: id,
      ru: ru,
      tatoebaKey: tatoebaKey,
      disabled: disabled,
      level: level,
      wordId: wordId,
      formType: formType,
      possibleAnswers: possibleAnswers,
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
        possibleAnswers,
      ];
}
