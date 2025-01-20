import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/screens/settings/appearance_setting_widget.dart';
import 'package:uchu/services/shared_preferences_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var sharedPreferencesService =
        GetIt.instance.get<SharedPreferencesService>();
    var themeMode = sharedPreferencesService.getThemeMode();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appearance'),
            const SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppearanceSettingWidget(
                  isSelected: themeMode == ThemeMode.light ||
                      (themeMode == ThemeMode.system &&
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.light),
                  title: 'Light mode',
                  icon: Icons.light_mode,
                  onSelected: () => setState(() => sharedPreferencesService
                      .updateThemeMode(ThemeMode.light)),
                ),
                AppearanceSettingWidget(
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
      ),
    );
  }
}
