import 'package:uchu/extensions/map_string_dynamic_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/level.dart';
import 'package:uchu/models/question.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/models/word_form.dart';

// TODO(DC): Should extend `Answerable` with an answer of type `WordFormType`
class Sentence extends Question<WordForm> {
  const Sentence._({
    required super.correctAnswer,
    required super.possibleAnswers,
    required super.explanation,
    required this.id,
    required this.ru,
    required this.tatoebaKey,
    required this.disabled,
    required this.level,
    required this.word,
  });

  final int id;
  final String ru;
  final int? tatoebaKey;
  final bool disabled;
  final Level? level;
  final Word word;
  final String explanation = 'because I said so';

  factory Sentence.fromJson(Map<String, dynamic> json) {
    final String? levelString = json['level'];

    return Sentence._(
      correctAnswer: WordForm.fromJson({
        'form_type': json['form_type'],
        'form': json['form'],
        '_form_bare': json['_form_bare'],
      }),
      possibleAnswers: json['possible_answers']
          .map<WordForm?>((e) {
            try {
              return WordForm.fromJson(e);
            } catch (e) {
              return null;
            }
          })
          .whereType<WordForm>()
          .toList(),
      explanation: json['explanation'],
      id: json.parseIntForKey('id'),
      ru: json['ru'],
      tatoebaKey: json.parseOptionalIntForKey('tatoeba_key'),
      disabled: json.parseBoolForKey('disabled'),
      level: StringExtension.isNullOrEmpty(levelString)
          ? null
          : Level.values.byName(levelString!),
      word: Word.fromJson({
        'id': json['word_id'],
        'position': json['position'],
        'bare': json['bare'],
        'accented': json['accented'],
        'derived_from_word_id': json['derived_from_word_id'],
        'rank': json['rank'],
        'disabled': json['word_disabled'],
        'audio': json['audio'],
        'usage_en': json['usage_en'],
        'usage_de': json['usage_de'],
        'number_value': json['number_value'],
        'type': json['type'],
        'level': json['word_level'],
        'created_at': json['created_at']
      }),
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        id,
        ru,
        tatoebaKey,
        disabled,
        level,
        word,
        possibleAnswers,
      ];
}
