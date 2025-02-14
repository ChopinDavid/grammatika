import 'package:flutter/material.dart';

class DurationRadioButton extends StatelessWidget {
  const DurationRadioButton({
    super.key,
    required this.text,
    required this.duration,
    required this.selectedDuration,
    required this.onChanged,
  });
  final String text;
  final Duration? duration;
  final Duration? selectedDuration;
  final void Function(Duration?) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          bottom: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(text),
            IgnorePointer(
              child: Radio<Duration?>(
                key: Key('$text-radio'),
                value: duration,
                groupValue: selectedDuration,
                onChanged: (_) {},
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashRadius: 0.0,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
      onTap: () => onChanged(duration),
    );
  }
}
