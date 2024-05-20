import 'package:equatable/equatable.dart';
import 'package:uchu/models/answer.dart';
import 'package:uchu/models/word_form_type.dart';

class WordForm extends Equatable implements Answer {
  final WordFormType type;
  final String form;
  final String bare;

  const WordForm._(
      {required this.type, required this.form, required this.bare});

  factory WordForm.fromJson(Map<String, dynamic> json) {
    return WordForm._(
      type: WordFormTypeExt.fromString(json['form_type']),
      form: json['form'],
      bare: json['_form_bare'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_type': type.name,
      'form': form,
      '_form_bare': bare,
    };
  }

  @override
  List<Object?> get props => [type, form, bare];
}
