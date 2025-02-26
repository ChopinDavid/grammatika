import 'package:expandable_box_drawing_table/widgets/expandable_box_drawing_table.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/screens/settings/appearance_setting_widget.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
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
        ExpandableBoxDrawingTable<String>(
          initialValues: GetIt.instance
              .get<EnabledExercisesService>()
              .getEnabledExercises(),
          onValuesChanged: (newValues) {
            GetIt.instance
                .get<EnabledExercisesService>()
                .setEnabledExercises(newValues);
          },
          sections: sections,
        ),
      ],
    );
  }
}
