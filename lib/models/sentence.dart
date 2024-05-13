import 'package:flutter/widgets.dart';
import 'package:uchu/extensions/map_string_dynamic_extension.dart';
import 'package:uchu/extensions/string_extension.dart';
import 'package:uchu/models/level.dart';
import 'package:uchu/models/question.dart';
import 'package:uchu/models/word.dart';
import 'package:uchu/models/word_form.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/models/word_type.dart';

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

  @visibleForTesting
  factory Sentence.testValue({
    WordFormType formType = WordFormType.ruVerbGerundPast,
    String form = "сказа'л",
    String formBare = 'сказал',
    List<Map<String, dynamic>> possibleAnswers = const [
      {
        'type': WordFormType.ruVerbGerundPast,
        'form': "сказа'в",
        '_form_bare': 'сказав'
      },
      {
        'type': WordFormType.ruVerbGerundPast,
        'form': 'сказавши',
        '_form_bare': 'сказавши'
      },
      {
        'type': WordFormType.ruVerbImperativeSg,
        'form': "скажи'",
        '_form_bare': 'скажи'
      },
      {
        'type': WordFormType.ruVerbImperativePl,
        'form': "скажи'те",
        '_form_bare': 'скажите'
      },
      {
        'type': WordFormType.ruVerbPastM,
        'form': "сказа'л",
        '_form_bare': 'сказал'
      },
      {
        'type': WordFormType.ruVerbPastF,
        'form': "сказа'ла",
        '_form_bare': 'сказала'
      },
      {
        'type': WordFormType.ruVerbPastN,
        'form': "сказа'ло",
        '_form_bare': 'сказало'
      },
      {
        'type': WordFormType.ruVerbPastPl,
        'form': "сказа'ли",
        '_form_bare': 'сказали'
      },
      {
        'type': WordFormType.ruVerbPresfutSg1,
        'form': "скажу'",
        '_form_bare': 'скажу'
      },
      {
        'type': WordFormType.ruVerbPresfutSg2,
        'form': "ска'жешь",
        '_form_bare': 'скажешь'
      },
      {
        'type': WordFormType.ruVerbPresfutSg3,
        'form': "ска'жет",
        '_form_bare': 'скажет'
      },
      {
        'type': WordFormType.ruVerbPresfutPl1,
        'form': "ска'жем",
        '_form_bare': 'скажем'
      },
      {
        'type': WordFormType.ruVerbPresfutPl2,
        'form': "ска'жете",
        '_form_bare': 'скажете'
      },
      {
        'type': WordFormType.ruVerbPresfutPl3,
        'form': "ска'жут",
        '_form_bare': 'скажут'
      },
      {
        'type': WordFormType.ruVerbParticipleActivePast,
        'form': "сказа'вший",
        '_form_bare': 'сказавший'
      },
      {
        'type': WordFormType.ruVerbParticiplePassivePast,
        'form': "ска'занный",
        '_form_bare': 'сказанный'
      },
    ],
    String explanation = 'because I said so',
    int id = 33,
    String ru = "Я сказа'л им посла'ть мне ещё один биле'т.",
    int tatoebaKey = 5447,
    bool disabled = false,
    Level level = Level.B1,
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
    createdAt ??= DateTime.parse('2020-01-01 00:00:00');
    return Sentence.fromJson({
      'form_type': formType.name,
      'form': form,
      '_form_bare': formBare,
      'explanation': explanation,
      'id': id,
      'ru': ru,
      'tatoeba_key': tatoebaKey,
      'disabled': disabled,
      'level': level.name,
      'word_id': wordId,
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
      'word_level': wordLevel.name,
      'created_at': createdAt.toIso8601String(),
      'possible_answers': possibleAnswers,
    });
  }
}
