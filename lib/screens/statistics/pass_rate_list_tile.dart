import 'package:flutter/material.dart';
import 'package:uchu/screens/statistics/pass_rate_bar.dart';

class PassRateListTile extends StatelessWidget {
  const PassRateListTile({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PassRateBar(
              passRate: value,
            ),
            const SizedBox(height: 4.0),
            Text(
              '${(value * 100).toStringAsFixed(2)}% pass rate',
            ),
          ],
        ),
      ),
    );
  }
}
