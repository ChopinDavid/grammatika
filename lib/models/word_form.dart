import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:grammatika/extensions/map_string_dynamic_extension.dart';
import 'package:grammatika/models/answer.dart';
import 'package:grammatika/models/word_form_type.dart';

class WordForm extends Equatable implements Answer {
  final WordFormType type;
  final String form;
  final int position;
  final String bare;

  const WordForm._(
      {required this.type,
      required this.position,
      required this.form,
      required this.bare});

  factory WordForm.fromJson(Map<String, dynamic> json) {
    return WordForm._(
      type: WordFormTypeExt.fromString(json['form_type']),
      position: json.parseIntForKey('word_form_position'),
      form: json['form'],
      bare: json['_form_bare'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'form_type': type.name,
      'word_form_position': position,
      'form': form,
      '_form_bare': bare,
    };
  }

  @override
  List<Object?> get props => [type, position, form, bare];

  @visibleForTesting
  factory WordForm.testValue(
          {WordFormType type = WordFormType.ruVerbGerundPast,
          int position = 1,
          String form = "сказа'в",
          String bare = 'сказав'}) =>
      WordForm.fromJson(
        {
          'form_type': type.name,
          'word_form_position': position,
          'form': form,
          '_form_bare': bare,
        },
      );
}
