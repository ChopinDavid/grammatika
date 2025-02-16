import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/screens/settings/appearance_setting_widget.dart';
import 'package:grammatika/screens/settings/enabled_exercises/exercise_section.dart';
import 'package:grammatika/screens/settings/enabled_exercises/exercise_sections_widget.dart';
import 'package:grammatika/services/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 24.0, left: 24.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppearanceSettingsWidget(),
              SizedBox(height: 24.0),
              _EnabledExercisesWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppearanceSettingsWidget extends StatefulWidget {
  const _AppearanceSettingsWidget({super.key});

  @override
  State<_AppearanceSettingsWidget> createState() =>
      _AppearanceSettingsWidgetState();
}

class _AppearanceSettingsWidgetState extends State<_AppearanceSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    var sharedPreferencesService = GetIt.instance.get<ThemeService>();
    var themeMode = sharedPreferencesService.getThemeMode();
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppearanceSettingWidget(
                key: const Key('light_mode_appearance_setting_widget'),
                isSelected: themeMode == ThemeMode.light ||
                    (themeMode == ThemeMode.system &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.light),
                title: 'Light mode',
                icon: Icons.light_mode,
                onSelected: () => setState(() =>
                    sharedPreferencesService.updateThemeMode(ThemeMode.light)),
              ),
              AppearanceSettingWidget(
                key: const Key('dark_mode_appearance_setting_widget'),
                isSelected: themeMode == ThemeMode.dark ||
                    (themeMode == ThemeMode.system &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark),
                title: 'Dark mode',
                icon: Icons.dark_mode,
                onSelected: () => setState(() =>
                    sharedPreferencesService.updateThemeMode(ThemeMode.dark)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12.0),
            child: Row(
              children: [
                const Text('Automatic'),
                const Spacer(),
                Switch(
                    value: themeMode == ThemeMode.system,
                    activeTrackColor: Colors.blueAccent,
                    thumbColor: WidgetStateProperty.all(Colors.white),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          sharedPreferencesService
                              .updateThemeMode(ThemeMode.system);
                        } else {
                          sharedPreferencesService.updateThemeMode(
                              MediaQuery.of(context).platformBrightness ==
                                      Brightness.light
                                  ? ThemeMode.light
                                  : ThemeMode.dark);
                        }
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EnabledExercisesWidget extends StatefulWidget {
  const _EnabledExercisesWidget({super.key});

  @override
  State<_EnabledExercisesWidget> createState() =>
      _EnabledExercisesWidgetState();
}

class _EnabledExercisesWidgetState extends State<_EnabledExercisesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enabled Exercises',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(
          height: 24.0,
        ),
        ExerciseSectionsWidget(
          sections: [
            ExerciseSection(
              title: 'Inflection',
              subSections: [
                ExerciseSection(
                  title: 'Nouns',
                  subSections: [
                    ExerciseSection(
                      title: 'Nominative',
                      exercises: [
                        (WordFormType.ruNounSgNom.name, 'Singular'),
                        (WordFormType.ruNounPlNom.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Genitive',
                      exercises: [
                        (WordFormType.ruNounSgGen.name, 'Singular'),
                        (WordFormType.ruNounPlGen.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Dative',
                      exercises: [
                        (WordFormType.ruNounSgDat.name, 'Singular'),
                        (WordFormType.ruNounPlDat.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Accusative',
                      exercises: [
                        (WordFormType.ruNounSgAcc.name, 'Singular'),
                        (WordFormType.ruNounPlAcc.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Instrumental',
                      exercises: [
                        (WordFormType.ruNounSgInst.name, 'Singular'),
                        (WordFormType.ruNounPlInst.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Prepositional',
                      exercises: [
                        (WordFormType.ruNounSgPrep.name, 'Singular'),
                        (WordFormType.ruNounPlPrep.name, 'Plural'),
                      ],
                    ),
                  ],
                ),
                ExerciseSection(
                  title: 'Verbs',
                  subSections: [
                    ExerciseSection(
                      title: 'First Person',
                      exercises: [
                        (WordFormType.ruVerbPresfutSg1.name, 'Singular'),
                        (WordFormType.ruVerbPresfutPl1.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Second Person',
                      exercises: [
                        (WordFormType.ruVerbPresfutSg2.name, 'Singular'),
                        (WordFormType.ruVerbPresfutPl2.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Third Person',
                      exercises: [
                        (WordFormType.ruVerbPresfutSg3.name, 'Singular'),
                        (WordFormType.ruVerbPresfutPl3.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Past',
                      exercises: [
                        (WordFormType.ruVerbPastM.name, 'Masculine'),
                        (WordFormType.ruVerbPastF.name, 'Feminine'),
                        (WordFormType.ruVerbPastN.name, 'Neuter'),
                        (WordFormType.ruVerbPastPl.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Participles',
                      subSections: [
                        ExerciseSection(
                          title: 'Active',
                          exercises: [
                            (
                              WordFormType.ruVerbParticipleActivePast.name,
                              'Past'
                            ),
                            (
                              WordFormType.ruVerbParticipleActivePresent.name,
                              'Present'
                            ),
                          ],
                        ),
                        ExerciseSection(
                          title: 'Passive',
                          exercises: [
                            (
                              WordFormType.ruVerbParticiplePassivePast.name,
                              'Past'
                            ),
                            (
                              WordFormType.ruVerbParticiplePassivePresent.name,
                              'Present'
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Imperative',
                      exercises: [
                        (WordFormType.ruVerbImperativeSg.name, 'Singular'),
                        (WordFormType.ruVerbImperativePl.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Gerunds',
                      exercises: [
                        (WordFormType.ruVerbGerundPast.name, 'Past'),
                        (WordFormType.ruVerbGerundPresent.name, 'Present'),
                      ],
                    )
                  ],
                ),
                ExerciseSection(
                  title: 'Adjectives',
                  subSections: [
                    ExerciseSection(
                      title: 'Nominative',
                      exercises: [
                        (WordFormType.ruAdjMNom.name, 'Masculine'),
                        (WordFormType.ruAdjFNom.name, 'Feminine'),
                        (WordFormType.ruAdjNNom.name, 'Neuter'),
                        (WordFormType.ruAdjPlNom.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Genitive',
                      exercises: [
                        (WordFormType.ruAdjMGen.name, 'Masculine'),
                        (WordFormType.ruAdjFGen.name, 'Feminine'),
                        (WordFormType.ruAdjNGen.name, 'Neuter'),
                        (WordFormType.ruAdjPlGen.name, 'Plural')
                      ],
                    ),
                    ExerciseSection(
                      title: 'Dative',
                      exercises: [
                        (WordFormType.ruAdjMDat.name, 'Masculine'),
                        (WordFormType.ruAdjFDat.name, 'Feminine'),
                        (WordFormType.ruAdjNDat.name, 'Neuter'),
                        (WordFormType.ruAdjPlDat.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Accusative',
                      exercises: [
                        (WordFormType.ruAdjMAcc.name, 'Masculine'),
                        (WordFormType.ruAdjFAcc.name, 'Feminine'),
                        (WordFormType.ruAdjNAcc.name, 'Neuter'),
                        (WordFormType.ruAdjPlAcc.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Instrumental',
                      exercises: [
                        (WordFormType.ruAdjMInst.name, 'Masculine'),
                        (WordFormType.ruAdjFInst.name, 'Feminine'),
                        (WordFormType.ruAdjNInst.name, 'Neuter'),
                        (WordFormType.ruAdjPlInst.name, 'Plural'),
                      ],
                    ),
                    ExerciseSection(
                      title: 'Prepositional',
                      exercises: [
                        (WordFormType.ruAdjMPrep.name, 'Masculine'),
                        (WordFormType.ruAdjFPrep.name, 'Feminine'),
                        (WordFormType.ruAdjNPrep.name, 'Neuter'),
                        (WordFormType.ruAdjPlPrep.name, 'Plural'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            ExerciseSection(
              title: 'Identifying Gender',
              exercises: [
                (Gender.m.name, 'Masculine'),
                (Gender.f.name, 'Feminine'),
                (Gender.n.name, 'Neuter'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
