import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/extensions/gender_extension.dart';
import 'package:uchu/models/gender.dart';
import 'package:uchu/models/word_form_type.dart';
import 'package:uchu/services/statistics_service.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

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
        final passRate =
            await statisticsService.getExercisePassRate(element.$1);
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return ListView.builder(
              itemCount: passRates.length,
              itemBuilder: (context, index) {
                final sortedPassRateEntries = passRates.entries.toList()
                  ..sort(
                    (a, b) => (a.value > b.value) == true ? 1 : 0,
                  );
                final key = sortedPassRateEntries[index].key;
                final value = sortedPassRateEntries[index].value;
                return ListTile(
                  title: Text(key),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PassRateBar(
                          passRate: value,
                        ),
                        const SizedBox(height: 4.0),
                        Text('${(value * 100).toStringAsFixed(2)}% pass rate'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PassRateBar extends StatelessWidget {
  final double passRate;

  const PassRateBar({super.key, required this.passRate})
      : assert(passRate >= 0.0 && passRate <= 1.0,
            'Pass rate must be between 0.0 and 1.0');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.0)),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          Expanded(
            flex: (passRate * 100).toInt(),
            child: Container(
              height: 12,
              color: Colors.green,
            ),
          ),
          Expanded(
            flex: ((1 - passRate) * 100).toInt(),
            child: Container(
              height: 12,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
