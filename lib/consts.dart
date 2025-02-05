import 'package:flutter/material.dart';

class UchuSpacing {
  static const double S = 8;
  static const double M = 16;
  static const double L = 24;
  static const double XL = 32;
}

const sentenceWordPlaceholderText = '______';

const translatableTextStyle = TextStyle(
  decoration: TextDecoration.underline,
  decorationColor: Colors.blue,
  decorationThickness: 3,
  decorationStyle: TextDecorationStyle.dashed,
);

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

const randomSentenceQueryString = '''SELECT words.*,
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
  AND sentences_words.form_type IS NOT 'ru_adj_short_pl'
  AND words_forms.form_type = sentences_words.form_type
ORDER BY RANDOM()
LIMIT 1;''';
