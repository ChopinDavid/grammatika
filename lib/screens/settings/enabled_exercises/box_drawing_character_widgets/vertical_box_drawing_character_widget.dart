import 'package:flutter/material.dart';

class VerticalBoxDrawingCharacterWidget extends StatelessWidget {
  const VerticalBoxDrawingCharacterWidget();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyLarge?.color;
    return VerticalDivider(
      color: color,
      width: 1.0,
      thickness: 1.0,
    );
  }
}
