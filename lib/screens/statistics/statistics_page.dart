import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grammatika/extensions/gender_extension.dart';
import 'package:grammatika/extensions/intersperse_extensions.dart';
import 'package:grammatika/models/gender.dart';
import 'package:grammatika/models/word_form_type.dart';
import 'package:grammatika/screens/statistics/pass_rate_list_tile.dart';
import 'package:grammatika/services/statistics_service.dart';

import 'duration_radio_button.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Duration? selectedDuration;

  void _onDurationChanged(Duration? duration) {
    setState(() {
      selectedDuration = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> passRates = {};
    final statisticsService = GetIt.instance.get<StatisticsService>();
    final statisticsFutures = <Future<void>>[];

    final exerciseNames = [
      ...WordFormType.values.map(
        (e) => (e.name, e.displayName),
      ),
      ...Gender.values.map(
        (e) => (e.name, '${e.displayString} Nouns'),
      ),
    ];

    for (var element in exerciseNames) {
      statisticsFutures.add(() async {
        final passRate = await statisticsService.getExercisePassRate(
            element.$1, selectedDuration);
        if (passRate != null) {
          passRates[element.$2] = passRate;
        }
      }());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Center(
        child: FutureBuilder(
          future: Future.wait(statisticsFutures),
          builder: (context, snapshot) {
            return passRates.isEmpty &&
                    snapshot.connectionState != ConnectionState.waiting
                ? const Text('Complete exercises to view your statistics.')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              DurationRadioButton(
                                text: 'All',
                                duration: null,
                                selectedDuration: selectedDuration,
                                onChanged: _onDurationChanged,
                              ),
                              DurationRadioButton(
                                text: 'Day',
                                duration: const Duration(days: 1),
                                selectedDuration: selectedDuration,
                                onChanged: _onDurationChanged,
                              ),
                              DurationRadioButton(
                                text: 'Week',
                                duration: const Duration(days: 7),
                                selectedDuration: selectedDuration,
                                onChanged: _onDurationChanged,
                              ),
                              DurationRadioButton(
                                text: 'Month',
                                duration: const Duration(days: 31),
                                selectedDuration: selectedDuration,
                                onChanged: _onDurationChanged,
                              ),
                              DurationRadioButton(
                                text: 'Year',
                                duration: const Duration(days: 365),
                                selectedDuration: selectedDuration,
                                onChanged: _onDurationChanged,
                              ),
                            ]
                                .intersperse(
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Flexible(
                              child: Column(
                                children: [
                                  Spacer(),
                                  Center(child: CircularProgressIndicator()),
                                  Spacer()
                                ],
                              ),
                            )
                          : Builder(builder: (context) {
                              final sortedPassRateEntries = passRates.entries
                                  .toList()
                                ..sort((a, b) => a.value.compareTo(b.value));
                              return Flexible(
                                child: ListView.builder(
                                  itemCount: passRates.length,
                                  itemBuilder: (context, index) {
                                    final title =
                                        sortedPassRateEntries[index].key;
                                    final value =
                                        sortedPassRateEntries[index].value;
                                    return PassRateListTile(
                                      title: title,
                                      value: value,
                                    );
                                  },
                                ),
                              );
                            }),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
