class UchuSpacing {
  static const double S = 8;
  static const double M = 16;
  static const double L = 24;
  static const double XL = 32;
}

const masculineNounEndings = [
  'б',
  'в',
  'г',
  'д',
  'ж',
  'з',
  'й',
  'к',
  'л',
  'м',
  'н',
  'п',
  'р',
  'с',
  'т',
  'ф',
  'х',
  'ц',
  'ч',
  'ш',
  'щ'
];

const feminineNounEndings = ['а', 'я'];

const neuterNounEndings = ['о', 'е'];

const foreignNeuterNounEndings = ['и', 'у', 'ю'];

const randomNounQueryString = '''SELECT *
FROM nouns
  INNER JOIN words ON words.id = nouns.word_id
WHERE gender IS NOT NULL
  AND gender IS NOT ''
  AND gender IS NOT 'both'
  AND gender IS NOT 'pl'
ORDER BY RANDOM()
LIMIT 1;
''';

const randomSentenceQueryString = '''SELECT words.*,
       words.id AS word_id,
       words.disabled AS word_disabled,
       words.level AS word_level,
       sentences.id,
       sentences.ru,
       sentences.tatoeba_key,
       sentences.disabled,
       sentences.level,
       words_forms.*
FROM sentences_words
INNER JOIN sentences ON sentences.id = sentences_words.sentence_id
INNER JOIN words_forms ON words_forms.word_id = sentences_words.word_id
INNER JOIN words ON words.id = sentences_words.word_id
WHERE sentences_words.form_type IS NOT NULL
  AND sentences_words.form_type IS NOT 'ru_base'
  AND words_forms.form_type = sentences_words.form_type
ORDER BY RANDOM()
LIMIT 1;''';
