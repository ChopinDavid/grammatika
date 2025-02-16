import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:grammatika/utilities/db_helper.dart';

import '../mocks.dart';

main() {
  late EnabledExercisesService mockEnabledExercisesService;
  late DbHelper testObject;

  setUp(() async {
    await GetIt.instance.reset();

    mockEnabledExercisesService = MockEnabledExercisesService();

    testObject = DbHelper();

    GetIt.instance.registerSingleton<EnabledExercisesService>(
        mockEnabledExercisesService);
  });

  group('randomNounQueryString', () {
    test(
        'appends each identifier returned from EnabledExercisesService.getDisabledExercises that is the name of a Gender to the returned query string',
        () {
      final disabledGenderIdentifiers = [Gender.n.name, Gender.m.name];
      final allDisabledIdentifiers = [
        ...disabledGenderIdentifiers,
        WordFormType.ruAdjFAcc.name
      ];

      when(() => mockEnabledExercisesService.getDisabledExercises())
          .thenReturn(allDisabledIdentifiers);

      final expectedRandomNounQueryString = '''SELECT *
FROM nouns
  INNER JOIN words ON words.id = nouns.word_id
WHERE gender IS NOT NULL
  AND gender IS NOT ''
  AND gender IS NOT 'both'
  AND gender IS NOT 'pl'
${disabledGenderIdentifiers.map((disabledGenderIdentifier) => '''  AND gender IS NOT \'$disabledGenderIdentifier\'''').join('\n')}
ORDER BY RANDOM()
LIMIT 1;''';
      expect(testObject.randomNounQueryString(), expectedRandomNounQueryString);
    });
  });

  group('randomSentenceQueryString', () {
    test(
        'appends each identifier returned from EnabledExercisesService.getDisabledExercises that is the name of a WordFormType to the returned query string',
        () {
      final disabledWordFormTypeIdentifiers = [
        WordFormType.ruAdjFAcc.name,
        WordFormType.ruAdjMDat.name
      ];
      final allDisabledIdentifiers = [
        ...disabledWordFormTypeIdentifiers,
        Gender.m.name
      ];

      when(() => mockEnabledExercisesService.getDisabledExercises())
          .thenReturn(allDisabledIdentifiers);

      final expectedRandomSentenceQueryString = '''SELECT words.*,
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
  AND sentences_words.form_type IS NOT 'ru_adj_short_pl\'
${disabledWordFormTypeIdentifiers.map((disabledWordFormExercise) => '''  AND sentences_words.form_type IS NOT '$disabledWordFormExercise\'''').join('\n')}
  AND words_forms.form_type = sentences_words.form_type
ORDER BY RANDOM()
LIMIT 1;''';
      expect(testObject.randomSentenceQueryString(),
          expectedRandomSentenceQueryString);
    });
  });
}
