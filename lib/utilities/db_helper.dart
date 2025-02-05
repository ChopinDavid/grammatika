import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/services/shared_preferences_service.dart';

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
        GetIt.instance.get<SharedPreferencesService>().getDisabledExercises();
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
  AND gender IS NOT 'pl\'''';

    for (var disabledGenderExercise in disabledGenderExercises) {
      sqlString += '''
      AND gender IS NOT '$disabledGenderExercise'
      ''';
    }

    sqlString += '''
ORDER BY RANDOM()
LIMIT 1;
''';

    return sqlString;
  }
}
