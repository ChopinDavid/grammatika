import 'package:flutter/material.dart';

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
