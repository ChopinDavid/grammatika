import 'package:expandable_box_drawing_table/models/expandable_box_drawing_table_configuration.dart';
import 'package:expandable_box_drawing_table/widgets/expandable_box_drawing_table.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/consts.dart';
import 'package:grammatika/screens/settings/appearance_setting_widget.dart';
import 'package:grammatika/services/enabled_exercises_service.dart';
import 'package:grammatika/services/miscellaneous_settings_service.dart';
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AppearanceSettingsWidget(),
              SizedBox(height: 24.0),
              _MiscellaneousSettingsWidget(),
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
  const _AppearanceSettingsWidget();

  @override
  State<_AppearanceSettingsWidget> createState() =>
      _AppearanceSettingsWidgetState();
}

class _AppearanceSettingsWidgetState extends State<_AppearanceSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    var themeService = GetIt.instance.get<ThemeService>();
    var themeMode = themeService.getThemeMode();
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
                onSelected: () => setState(
                    () => themeService.updateThemeMode(ThemeMode.light)),
              ),
              AppearanceSettingWidget(
                key: const Key('dark_mode_appearance_setting_widget'),
                isSelected: themeMode == ThemeMode.dark ||
                    (themeMode == ThemeMode.system &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark),
                title: 'Dark mode',
                icon: Icons.dark_mode,
                onSelected: () => setState(
                    () => themeService.updateThemeMode(ThemeMode.dark)),
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
                          themeService.updateThemeMode(ThemeMode.system);
                        } else {
                          themeService.updateThemeMode(
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

class _MiscellaneousSettingsWidget extends StatefulWidget {
  const _MiscellaneousSettingsWidget();

  @override
  State<_MiscellaneousSettingsWidget> createState() =>
      _MiscellaneousSettingsWidgetState();
}

class _MiscellaneousSettingsWidgetState
    extends State<_MiscellaneousSettingsWidget> {
  var miscellaneousSettingsService =
      GetIt.instance.get<MiscellaneousSettingsService>();

  late var miscellaneousSettings = miscellaneousSettingsService.getSettings();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Miscellaneous Settings',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(
            height: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12.0),
            child: Row(
              children: [
                const Text('Automatically show explanation'),
                const Spacer(),
                Switch(
                    key: const Key('automatically_show_explanation_switch'),
                    value: miscellaneousSettings.automaticallyShowExplanation,
                    activeTrackColor: Colors.blueAccent,
                    thumbColor: WidgetStateProperty.all(Colors.white),
                    onChanged: (value) {
                      setState(() {
                        miscellaneousSettings = miscellaneousSettings.copyWith(
                            automaticallyShowExplanation: value);
                        miscellaneousSettingsService
                            .updateSettings(miscellaneousSettings);
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
  const _EnabledExercisesWidget();

  @override
  State<_EnabledExercisesWidget> createState() =>
      _EnabledExercisesWidgetState();
}

class _EnabledExercisesWidgetState extends State<_EnabledExercisesWidget> {
  @override
  Widget build(BuildContext context) {
    final iconColor = GetIt.instance.get<ThemeService>().getBrightness(
                platformBrightness:
                    MediaQuery.of(context).platformBrightness) ==
            Brightness.light
        ? Colors.black
        : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enabled Exercises',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(
          height: 24.0,
        ),
        ExpandableBoxDrawingTable<String>(
          configuration: const ExpandableBoxDrawingTableConfigurationData
                  .defaultConfiguration()
              .copyWith(
                  expandedIconColor: iconColor, collapsedIconColor: iconColor),
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
