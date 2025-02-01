import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/screens/settings/appearance_setting_widget.dart';
import 'package:uchu/screens/settings/word_form_section_widget.dart';
import 'package:uchu/services/shared_preferences_service.dart';

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
              _EnabledWordFormsWidget(),
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
    var sharedPreferencesService =
        GetIt.instance.get<SharedPreferencesService>();
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

class _EnabledWordFormsWidget extends StatefulWidget {
  const _EnabledWordFormsWidget({super.key});

  @override
  State<_EnabledWordFormsWidget> createState() =>
      _EnabledWordFormsWidgetState();
}

class _EnabledWordFormsWidgetState extends State<_EnabledWordFormsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enabled Word Forms',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(
          height: 24.0,
        ),
        const WordFormSectionsWidget(
          sections: [
            WordFormSection(
              title: 'Nouns',
              subSections: [
                WordFormSection(title: 'Nominative', wordFormTypes: [
                  (WordFormType.ruNounSgNom, 'Singular'),
                  (WordFormType.ruNounPlNom, 'Plural'),
                ]),
                WordFormSection(title: 'Genitive', wordFormTypes: [
                  (WordFormType.ruNounSgGen, 'Singular'),
                  (WordFormType.ruNounPlGen, 'Plural'),
                ]),
                WordFormSection(title: 'Dative', wordFormTypes: [
                  (WordFormType.ruNounSgDat, 'Singular'),
                  (WordFormType.ruNounPlDat, 'Plural'),
                ]),
                WordFormSection(title: 'Accusative', wordFormTypes: [
                  (WordFormType.ruNounSgAcc, 'Singular'),
                  (WordFormType.ruNounPlAcc, 'Plural'),
                ]),
                WordFormSection(title: 'Instrumental', wordFormTypes: [
                  (WordFormType.ruNounSgInst, 'Singular'),
                  (WordFormType.ruNounPlInst, 'Plural'),
                ]),
                WordFormSection(title: 'Prepositional', wordFormTypes: [
                  (WordFormType.ruNounSgPrep, 'Singular'),
                  (WordFormType.ruNounPlPrep, 'Plural'),
                ]),
              ],
            ),
            WordFormSection(
              title: 'Verbs',
              subSections: [
                WordFormSection(title: 'First Person', wordFormTypes: [
                  (WordFormType.ruVerbPresfutSg1, 'Singular'),
                  (WordFormType.ruVerbPresfutPl1, 'Plural'),
                ]),
                WordFormSection(title: 'Second Person', wordFormTypes: [
                  (WordFormType.ruVerbPresfutSg2, 'Singular'),
                  (WordFormType.ruVerbPresfutPl2, 'Plural'),
                ]),
                WordFormSection(
                  title: 'Third Person',
                  wordFormTypes: [
                    (WordFormType.ruVerbPresfutSg3, 'Singular'),
                    (WordFormType.ruVerbPresfutPl3, 'Plural'),
                  ],
                ),
                WordFormSection(title: 'Past', wordFormTypes: [
                  (WordFormType.ruVerbPastM, 'Masculine'),
                  (WordFormType.ruVerbPastF, 'Feminine'),
                  (WordFormType.ruVerbPastN, 'Neuter'),
                  (WordFormType.ruVerbPastPl, 'Plural'),
                ]),
                WordFormSection(title: 'Participles', subSections: [
                  WordFormSection(title: 'Active', wordFormTypes: [
                    (WordFormType.ruVerbParticipleActivePast, 'Past'),
                    (WordFormType.ruVerbParticipleActivePresent, 'Present'),
                  ]),
                  WordFormSection(title: 'Passive', wordFormTypes: [
                    (WordFormType.ruVerbParticiplePassivePast, 'Past'),
                    (WordFormType.ruVerbParticiplePassivePresent, 'Present'),
                  ]),
                ]),
                WordFormSection(title: 'Imperative', wordFormTypes: [
                  (WordFormType.ruVerbImperativeSg, 'Singular'),
                  (WordFormType.ruVerbImperativePl, 'Plural'),
                ]),
                WordFormSection(
                  title: 'Gerunds',
                  wordFormTypes: [
                    (WordFormType.ruVerbGerundPast, 'Past'),
                    (WordFormType.ruVerbGerundPresent, 'Present'),
                  ],
                )
              ],
            ),
            WordFormSection(title: 'Adjectives', subSections: [
              WordFormSection(
                title: 'Nominative',
                wordFormTypes: [
                  (WordFormType.ruAdjMNom, 'Masculine'),
                  (WordFormType.ruAdjFNom, 'Feminine'),
                  (WordFormType.ruAdjNNom, 'Neuter'),
                  (WordFormType.ruAdjPlNom, 'Plural'),
                ],
              ),
              WordFormSection(
                title: 'Genitive',
                wordFormTypes: [
                  (WordFormType.ruAdjMGen, 'Masculine'),
                  (WordFormType.ruAdjFGen, 'Feminine'),
                  (WordFormType.ruAdjNGen, 'Neuter'),
                  (WordFormType.ruAdjPlGen, 'Plural')
                ],
              ),
              WordFormSection(title: 'Dative', wordFormTypes: [
                (WordFormType.ruAdjMDat, 'Masculine'),
                (WordFormType.ruAdjFDat, 'Feminine'),
                (WordFormType.ruAdjNDat, 'Neuter'),
                (WordFormType.ruAdjPlDat, 'Plural')
              ]),
              WordFormSection(title: 'Accusative', wordFormTypes: [
                (WordFormType.ruAdjMAcc, 'Masculine'),
                (WordFormType.ruAdjFAcc, 'Feminine'),
                (WordFormType.ruAdjNAcc, 'Neuter'),
                (WordFormType.ruAdjPlAcc, 'Plural')
              ]),
              WordFormSection(title: 'Instrumental', wordFormTypes: [
                (WordFormType.ruAdjMInst, 'Masculine'),
                (WordFormType.ruAdjFInst, 'Feminine'),
                (WordFormType.ruAdjNInst, 'Neuter'),
                (WordFormType.ruAdjPlInst, 'Plural')
              ]),
              WordFormSection(title: 'Prepositional', wordFormTypes: [
                (WordFormType.ruAdjMPrep, 'Masculine'),
                (WordFormType.ruAdjFPrep, 'Feminine'),
                (WordFormType.ruAdjNPrep, 'Neuter'),
                (WordFormType.ruAdjPlPrep, 'Plural')
              ]),
            ])
          ],
        )
      ],
    );
  }
}
