import 'package:flutter/material.dart';
import 'package:uchu/models/sentence.dart';

class SentenceExerciseWidget extends StatelessWidget {
  const SentenceExerciseWidget({
    super.key,
    required this.sentence,
  });

  final Sentence sentence;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        sentence.ru.replaceFirst(
            sentence.possibleAnswers
                    ?.firstWhere((element) => element.type == sentence.formType)
                    .form ??
                '',
            '_ _ _'),
      )
    ]);
  }
}
