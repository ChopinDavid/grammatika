import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/services/enabled_exercises_service.dart';

class DbHelper {
  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "russian.db");

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {
        rethrow;
      }

      ByteData data = await rootBundle.load(url.join("assets", "russian.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, readOnly: true);
  }

  String randomNounQueryString() {
    final disabledExercises =
        GetIt.instance.get<EnabledExercisesService>().getDisabledExercises();
    final disabledGenderExercises = disabledExercises
        .where(
          (element) => Gender.values
              .map(
                (e) => e.name,
              )
              .contains(element),
        )
        .toList();
    var sqlString = '''SELECT *
FROM nouns
  INNER JOIN words ON words.id = nouns.word_id
WHERE gender IS NOT NULL
  AND gender IS NOT ''
  AND gender IS NOT 'both'
  AND gender IS NOT 'pl'${disabledGenderExercises.map(
              (e) => '''\n  AND gender IS NOT \'$e\'''',
            ).join()}
ORDER BY RANDOM()
LIMIT 1;''';

    return sqlString;
  }

  String randomSentenceQueryString() {
    final disabledExercises =
        GetIt.instance.get<EnabledExercisesService>().getDisabledExercises();
    final disabledWordFormExercises = disabledExercises
        .where(
          (element) => WordFormType.values
              .map(
                (e) => e.name,
              )
              .contains(element),
        )
        .toList();
    var sqlString = '''SELECT words.*,
       words.id AS word_id,
       words.disabled AS word_disabled,
       words.level AS word_level,
       sentences.id AS sentence_id,
       sentences.ru,
       sentences.tatoeba_key,
       sentences.disabled,
       sentences.level,
       words_forms.*,
       words_forms.position AS word_form_position,
       (SELECT nouns.gender
        FROM nouns
        WHERE nouns.word_id = words.id AND words.type = 'noun' AND nouns.gender IS NOT NULL AND nouns.gender != ""
        LIMIT 1) AS gender
FROM sentences_words
INNER JOIN sentences ON sentences.id = sentences_words.sentence_id
INNER JOIN words_forms ON words_forms.word_id = sentences_words.word_id
INNER JOIN words ON words.id = sentences_words.word_id
WHERE sentences_words.form_type IS NOT NULL
  AND sentences_words.form_type IS NOT 'ru_base'
  AND sentences_words.form_type IS NOT 'ru_adj_comparative'
  AND sentences_words.form_type IS NOT 'ru_adj_superlative'
  AND sentences_words.form_type IS NOT 'ru_adj_short_m'
  AND sentences_words.form_type IS NOT 'ru_adj_short_f'
  AND sentences_words.form_type IS NOT 'ru_adj_short_n'
  AND sentences_words.form_type IS NOT 'ru_adj_short_pl\'${disabledWordFormExercises.map((disabledWordFormExercise) => '''\n  AND sentences_words.form_type IS NOT '$disabledWordFormExercise\'''').join()}
  AND words_forms.form_type = sentences_words.form_type
ORDER BY RANDOM()
LIMIT 1;''';

    return sqlString;
  }
}
