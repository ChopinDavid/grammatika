import 'package:flutter/widgets.dart';
import 'package:grammatika/extensions/map_string_dynamic_extension.dart';
import 'package:grammatika/extensions/string_extension.dart';
import 'package:grammatika/models/level.dart';
import 'package:grammatika/models/question.dart';
import 'package:grammatika/models/word.dart';
import 'package:grammatika/models/word_form.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/models/word_type.dart';

class Sentence extends Question<WordForm> {
  const Sentence._({
    required super.correctAnswer,
    required super.answerSynonyms,
    required super.possibleAnswers,
    required super.explanation,
    required super.visualExplanation,
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

  factory Sentence.fromJson(Map<String, dynamic> json) {
    final String? levelString = json['level'];

    return Sentence._(
      correctAnswer: WordForm.fromJson(json),
      answerSynonyms: json['answer_synonyms']
          .map<WordForm?>((e) {
            try {
              return WordForm.fromJson(e);
            } catch (e) {
              return null;
            }
          })
          .whereType<WordForm>()
          .toList(),
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
      visualExplanation: json['visual_explanation'],
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

  Map<String, dynamic> toJson() {
    return {
      'form_type': correctAnswer.type.name,
      'word_form_position': correctAnswer.position,
      'form': correctAnswer.form,
      '_form_bare': correctAnswer.bare,
      'answer_synonyms': answerSynonyms.map((e) => e.toJson()).toList(),
      'possible_answers': possibleAnswers.map((e) => e.toJson()).toList(),
      'explanation': explanation,
      'visual_explanation': visualExplanation,
      'id': id,
      'ru': ru,
      'tatoeba_key': tatoebaKey,
      'disabled': disabled,
      'level': level?.name,
      'word_id': word.id,
      'position': word.position,
      'bare': word.bare,
      'accented': word.accented,
      'derived_from_word_id': word.derivedFromWordId,
      'rank': word.rank,
      'word_disabled': word.disabled,
      'audio': word.audio,
      'usage_en': word.usageEn,
      'usage_de': word.usageDe,
      'number_value': word.numberValue,
      'type': word.type?.name,
      'word_level': word.level?.name,
      'created_at': word.createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
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
    List<WordForm>? answerSynonyms,
    WordFormType formType = WordFormType.ruVerbGerundPast,
    int wordFormPosition = 1,
    String form = "сказа'л",
    String formBare = 'сказал',
    List<WordForm>? possibleAnswers,
    String explanation = 'because I said so',
    String visualExplanation = 'сказ- ➡️ сказал',
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
    answerSynonyms ??= [
      WordForm.fromJson({
        'form_type': WordFormType.ruVerbPastM.name,
        'word_form_position': 1,
        'form': "сказа'л",
        '_form_bare': 'сказал'
      }),
    ];
    possibleAnswers ??= [
      {
        'form_type': WordFormType.ruVerbGerundPast.name,
        'word_form_position': 1,
        'form': "сказа'в",
        '_form_bare': 'сказав'
      },
      {
        'form_type': WordFormType.ruVerbGerundPast.name,
        'word_form_position': 2,
        'form': 'сказавши',
        '_form_bare': 'сказавши'
      },
      {
        'form_type': WordFormType.ruVerbImperativeSg.name,
        'word_form_position': 1,
        'form': "скажи'",
        '_form_bare': 'скажи'
      },
      {
        'form_type': WordFormType.ruVerbImperativePl.name,
        'word_form_position': 1,
        'form': "скажи'те",
        '_form_bare': 'скажите'
      },
      {
        'form_type': WordFormType.ruVerbPastM.name,
        'word_form_position': 1,
        'form': "сказа'л",
        '_form_bare': 'сказал'
      },
      {
        'form_type': WordFormType.ruVerbPastF.name,
        'word_form_position': 1,
        'form': "сказа'ла",
        '_form_bare': 'сказала'
      },
      {
        'form_type': WordFormType.ruVerbPastN.name,
        'word_form_position': 1,
        'form': "сказа'ло",
        '_form_bare': 'сказало'
      },
      {
        'form_type': WordFormType.ruVerbPastPl.name,
        'word_form_position': 1,
        'form': "сказа'ли",
        '_form_bare': 'сказали'
      },
      {
        'form_type': WordFormType.ruVerbPresfutSg1.name,
        'word_form_position': 1,
        'form': "скажу'",
        '_form_bare': 'скажу'
      },
      {
        'form_type': WordFormType.ruVerbPresfutSg2.name,
        'word_form_position': 1,
        'form': "ска'жешь",
        '_form_bare': 'скажешь'
      },
      {
        'form_type': WordFormType.ruVerbPresfutSg3.name,
        'word_form_position': 1,
        'form': "ска'жет",
        '_form_bare': 'скажет'
      },
      {
        'form_type': WordFormType.ruVerbPresfutPl1.name,
        'word_form_position': 1,
        'form': "ска'жем",
        '_form_bare': 'скажем'
      },
      {
        'form_type': WordFormType.ruVerbPresfutPl2.name,
        'word_form_position': 1,
        'form': "ска'жете",
        '_form_bare': 'скажете'
      },
      {
        'form_type': WordFormType.ruVerbPresfutPl3.name,
        'word_form_position': 1,
        'form': "ска'жут",
        '_form_bare': 'скажут'
      },
      {
        'form_type': WordFormType.ruVerbParticipleActivePast.name,
        'word_form_position': 1,
        'form': "сказа'вший",
        '_form_bare': 'сказавший'
      },
      {
        'form_type': WordFormType.ruVerbParticiplePassivePast.name,
        'word_form_position': 1,
        'form': "ска'занный",
        '_form_bare': 'сказанный'
      },
    ]
        .map(
          (answer) => WordForm.fromJson(answer),
        )
        .toList();
    createdAt ??= DateTime.parse('2020-01-01 00:00:00');
    return Sentence.fromJson({
      'answer_synonyms': answerSynonyms.map(
        (answer) => answer.toJson(),
      ),
      'form_type': formType.name,
      'word_form_position': wordFormPosition,
      'form': form,
      '_form_bare': formBare,
      'explanation': explanation,
      'visual_explanation': visualExplanation,
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
      'possible_answers': possibleAnswers.map(
        (answer) => answer.toJson(),
      ),
    });
  }
}
