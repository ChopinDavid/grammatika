import 'package:expandable_box_drawing_table/models/entry.dart';
import 'package:expandable_box_drawing_table/models/section.dart';
import 'package:flutter/material.dart';

import 'models/gender.dart';
import 'models/word_form_type.dart';

class GrammatikaSpacing {
  static const double S = 8;
  static const double M = 16;
  static const double L = 24;
  static const double XL = 32;
}

const sentenceWordPlaceholderText = '______';

const translatableTextStyle = TextStyle(
  fontSize: 18.0,
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

const String themeModeSharedPreferencesKey = 'theme_mode';
const String enabledExercisesSharedPreferencesKey = 'enabled_exercises';

final List<Section<String>> sections = [
  Section(
    title: 'Inflection',
    subSections: [
      Section(
        title: 'Nouns',
        subSections: [
          Section(
            title: 'Nominative',
            entries: [
              Entry(title: 'Singular', value: WordFormType.ruNounSgNom.name),
              Entry(title: 'Plural', value: WordFormType.ruNounPlNom.name)
            ],
          ),
          Section(
            title: 'Genitive',
            entries: [
              Entry(title: 'Singular', value: WordFormType.ruNounSgGen.name),
              Entry(title: 'Plural', value: WordFormType.ruNounPlGen.name),
            ],
          ),
          Section(
            title: 'Dative',
            entries: [
              Entry(title: 'Singular', value: WordFormType.ruNounSgDat.name),
              Entry(title: 'Singular', value: WordFormType.ruNounPlDat.name),
            ],
          ),
          Section(
            title: 'Accusative',
            entries: [
              Entry(title: 'Singular', value: WordFormType.ruNounSgAcc.name),
              Entry(title: 'Plural', value: WordFormType.ruNounPlAcc.name),
            ],
          ),
          Section(
            title: 'Instrumental',
            entries: [
              Entry(title: 'Singular', value: WordFormType.ruNounSgInst.name),
              Entry(title: 'Plural', value: WordFormType.ruNounPlInst.name),
            ],
          ),
          Section(
            title: 'Prepositional',
            entries: [
              Entry(title: 'Singular', value: WordFormType.ruNounSgPrep.name),
              Entry(title: 'Plural', value: WordFormType.ruNounPlPrep.name),
            ],
          ),
        ],
      ),
      Section(
        title: 'Verbs',
        subSections: [
          Section(
            title: 'First Person',
            entries: [
              Entry(
                  title: 'Singular', value: WordFormType.ruVerbPresfutSg1.name),
              Entry(title: 'Plural', value: WordFormType.ruVerbPresfutPl1.name),
            ],
          ),
          Section(
            title: 'Second Person',
            entries: [
              Entry(
                  title: 'Singular', value: WordFormType.ruVerbPresfutSg2.name),
              Entry(title: 'Plural', value: WordFormType.ruVerbPresfutPl2.name),
            ],
          ),
          Section(
            title: 'Third Person',
            entries: [
              Entry(
                  title: 'Singular', value: WordFormType.ruVerbPresfutSg3.name),
              Entry(title: 'Plural', value: WordFormType.ruVerbPresfutPl3.name),
            ],
          ),
          Section(
            title: 'Past',
            entries: [
              Entry(title: 'Masculine', value: WordFormType.ruVerbPastM.name),
              Entry(title: 'Feminine', value: WordFormType.ruVerbPastF.name),
              Entry(title: 'Neuter', value: WordFormType.ruVerbPastN.name),
              Entry(title: 'Plural', value: WordFormType.ruVerbPastPl.name),
            ],
          ),
          Section(
            title: 'Participles',
            subSections: [
              Section(
                title: 'Active',
                entries: [
                  Entry(
                      title: 'Past',
                      value: WordFormType.ruVerbParticipleActivePast.name),
                  Entry(
                      title: 'Present',
                      value: WordFormType.ruVerbParticipleActivePresent.name),
                ],
              ),
              Section(
                title: 'Passive',
                entries: [
                  Entry(
                      title: 'Past',
                      value: WordFormType.ruVerbParticiplePassivePast.name),
                  Entry(
                      title: 'Present',
                      value: WordFormType.ruVerbParticiplePassivePresent.name),
                ],
              ),
            ],
          ),
          Section(
            title: 'Imperative',
            entries: [
              Entry(
                  title: 'Singular',
                  value: WordFormType.ruVerbImperativeSg.name),
              Entry(
                  title: 'Plural', value: WordFormType.ruVerbImperativePl.name),
            ],
          ),
          Section(
            title: 'Gerunds',
            entries: [
              Entry(title: 'Past', value: WordFormType.ruVerbGerundPast.name),
              Entry(
                  title: 'Present',
                  value: WordFormType.ruVerbGerundPresent.name),
            ],
          )
        ],
      ),
      Section(
        title: 'Adjectives',
        subSections: [
          Section(
            title: 'Nominative',
            entries: [
              Entry(title: 'Masculine', value: WordFormType.ruAdjMNom.name),
              Entry(title: 'Feminine', value: WordFormType.ruAdjFNom.name),
              Entry(title: 'Neuter', value: WordFormType.ruAdjNNom.name),
              Entry(title: 'Plural', value: WordFormType.ruAdjPlNom.name),
            ],
          ),
          Section(
            title: 'Genitive',
            entries: [
              Entry(title: 'Masculine', value: WordFormType.ruAdjMGen.name),
              Entry(title: 'Feminine', value: WordFormType.ruAdjFGen.name),
              Entry(title: 'Neuter', value: WordFormType.ruAdjNGen.name),
              Entry(title: 'Plural', value: WordFormType.ruAdjPlGen.name),
            ],
          ),
          Section(
            title: 'Dative',
            entries: [
              Entry(title: 'Masculine', value: WordFormType.ruAdjMDat.name),
              Entry(title: 'Feminine', value: WordFormType.ruAdjFDat.name),
              Entry(title: 'Neuter', value: WordFormType.ruAdjNDat.name),
              Entry(title: 'Plural', value: WordFormType.ruAdjPlDat.name),
            ],
          ),
          Section(
            title: 'Accusative',
            entries: [
              Entry(title: 'Masculine', value: WordFormType.ruAdjMAcc.name),
              Entry(title: 'Feminine', value: WordFormType.ruAdjFAcc.name),
              Entry(title: 'Neuter', value: WordFormType.ruAdjNAcc.name),
              Entry(title: 'Plural', value: WordFormType.ruAdjPlAcc.name),
            ],
          ),
          Section(
            title: 'Instrumental',
            entries: [
              Entry(title: 'Masculine', value: WordFormType.ruAdjMInst.name),
              Entry(title: 'Feminine', value: WordFormType.ruAdjFInst.name),
              Entry(title: 'Neuter', value: WordFormType.ruAdjNInst.name),
              Entry(title: 'Plural', value: WordFormType.ruAdjPlInst.name),
            ],
          ),
          Section(
            title: 'Prepositional',
            entries: [
              Entry(title: 'Masculine', value: WordFormType.ruAdjMPrep.name),
              Entry(title: 'Feminine', value: WordFormType.ruAdjFPrep.name),
              Entry(title: 'Neuter', value: WordFormType.ruAdjNPrep.name),
              Entry(title: 'Plural', value: WordFormType.ruAdjPlPrep.name),
            ],
          ),
        ],
      ),
    ],
  ),
  Section(
    title: 'Identifying Gender',
    entries: [
      Entry(title: 'Masculine', value: Gender.m.name),
      Entry(title: 'Feminine', value: Gender.f.name),
      Entry(title: 'Neuter', value: Gender.n.name),
    ],
  ),
];

List<String> getAllExerciseIds() {
  final List<String> allExercises = [];
  for (var section in sections) {
    section.flattenEntries().forEach(
          (entry) => allExercises.add(entry.value),
        );
  }
  return allExercises;
}
