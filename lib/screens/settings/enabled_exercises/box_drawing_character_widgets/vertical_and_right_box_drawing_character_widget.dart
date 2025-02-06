import 'package:flutter/material.dart';

class VerticalAndRightBoxDrawingCharacterWidget extends StatelessWidget {
  const VerticalAndRightBoxDrawingCharacterWidget();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyLarge?.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VerticalDivider(
          color: color,
          width: 1.0,
          thickness: 1.0,
        ),
        SizedBox(
          width: 12,
          child: Divider(
            color: color,
            thickness: 1.0,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
